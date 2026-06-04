const appointmentRepository = require('../repositories/appointmentRepository');
const DOCTOR_ID = 1;

exports.getStatus = () => ({ ready: true });

exports.getAllAppointments = async () => {
  return appointmentRepository.findAll();
};

exports.createAppointment = async (appointmentData) => {
  const requiredFields = ['patientId', 'appointmentDate', 'appointmentTime', 'reason'];
  const missingFields = requiredFields.filter((field) => !appointmentData[field]);

  if (missingFields.length) {
    const error = new Error(`Missing required field(s): ${missingFields.join(', ')}`);
    error.status = 400;
    throw error;
  }

  const appointment = {
    patient_id: appointmentData.patientId,
    doctor_id: DOCTOR_ID,
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
    doctorId: DOCTOR_ID,
    reason: appointmentData.reason,
  };
};

exports.updateAppointment = async (id, updateData) => {
  if (!id || isNaN(id)) {
    const error = new Error('Invalid appointment ID');
    error.status = 400;
    throw error;
  }

  const updateFields = {};

  if (updateData.appointmentDate) {
    updateFields.date = updateData.appointmentDate;
  }
  if (updateData.appointmentTime) {
    updateFields.time = updateData.appointmentTime;
  }

  // allow status and checked_in via the same PUT endpoint for check-in and other status updates
  if (typeof updateData.status !== 'undefined') {
    updateFields.status = updateData.status;
  }

  if (typeof updateData.checked_in !== 'undefined') {
    // accept either boolean or numeric truthy value
    updateFields.checked_in = updateData.checked_in ? 1 : 0;
  }

  if (Object.keys(updateFields).length === 0) {
    const error = new Error('No valid fields to update. Allowed fields: appointmentDate, appointmentTime, status, checked_in');
    error.status = 400;
    throw error;
  }

  return appointmentRepository.updateAppointment(id, updateFields);
};

exports.cancelAppointment = async (id) => {
  if (!id || isNaN(id)) {
    const error = new Error('Invalid appointment ID');
    error.status = 400;
    throw error;
  }

  return appointmentRepository.updateAppointmentStatus(id, 'cancelled');
};
