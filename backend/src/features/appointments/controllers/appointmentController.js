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

exports.rescheduleAppointment = async (req, res, next) => {
  try {
    const { id } = req.params;
    const appointment = await appointmentService.updateAppointment(id, req.body);
    res.json({ appointment });
  } catch (err) {
    next(err);
  }
};

exports.cancelAppointment = async (req, res, next) => {
  try {
    const { id } = req.params;
    const appointment = await appointmentService.cancelAppointment(id);
    res.json({ appointment });
  } catch (err) {
    next(err);
  }
};
