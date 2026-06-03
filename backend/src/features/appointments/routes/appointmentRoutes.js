const express = require('express');
const {
  appointmentStatus,
  getAllAppointments,
  createAppointment,
} = require('../controllers/appointmentController');

const router = express.Router();
router.get('/', getAllAppointments);
router.post('/', createAppointment);
router.get('/status', appointmentStatus);

module.exports = router;
