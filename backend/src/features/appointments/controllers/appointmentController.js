const appointmentService = require('../services/appointmentService');

exports.appointmentStatus = (req, res) => {
  res.json({ message: 'Appointment feature placeholder ready for Phase 2' });
};

exports.getAllAppointments = async (req, res, next) => {
  try {
    const appointments = await appointmentService.getAllAppointments();
    res.json({ appointments });
  } catch (err) {
    next(err);
  }
};

exports.createAppointment = async (req, res, next) => {
  try {
    const appointment = await appointmentService.createAppointment(req.body);
    res.status(201).json({ appointment });
  } catch (err) {
    next(err);
  }
};
