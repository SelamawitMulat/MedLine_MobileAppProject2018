const express = require('express');
const {
  appointmentStatus,
  getAllAppointments,
  createAppointment,
  rescheduleAppointment,
  cancelAppointment,
} = require('../controllers/appointmentController');

const router = express.Router();
router.get('/', getAllAppointments);
router.post('/', createAppointment);
router.put('/:id', rescheduleAppointment);
router.delete('/:id', cancelAppointment);
router.get('/status', appointmentStatus);

module.exports = router;
