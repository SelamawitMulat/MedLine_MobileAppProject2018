const appointmentRepository = require('../repositories/appointmentRepository');

exports.getStatus = () => ({ ready: true });

exports.getAllAppointments = async () => {
  return appointmentRepository.findAll();
};
