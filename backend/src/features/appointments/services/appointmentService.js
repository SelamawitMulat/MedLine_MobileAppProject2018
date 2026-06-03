const appointmentRepository = require('../repositories/appointmentRepository');

exports.getStatus = () => ({ ready: true });

exports.getAllAppointments = async () => {
  return appointmentRepository.findAll();
};

exports.createAppointment = async (appointmentData) => {
  const requiredFields = ['patientId', 'doctorId', 'appointmentDate', 'appointmentTime', 'reason'];
  const missingFields = requiredFields.filter((field) => !appointmentData[field]);

  if (missingFields.length) {
    const error = new Error(`Missing required field(s): ${missingFields.join(', ')}`);
    error.status = 400;
    throw error;
  }

  const appointment = {
    patient_id: appointmentData.patientId,
    doctor_id: appointmentData.doctorId,
    date: appointmentData.appointmentDate,
    time: appointmentData.appointmentTime,
    reason: appointmentData.reason,
    status: appointmentData.status || 'pending',
    queue_position: null,
    checked_in: 0,
  };

  const insertedAppointment = await appointmentRepository.insertAppointment(appointment);

  return {
    ...insertedAppointment,
    doctorId: appointmentData.doctorId,
    reason: appointmentData.reason,
  };
};
