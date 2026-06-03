const express = require('express');
const {
  appointmentStatus,
  getAllAppointments,
} = require('../controllers/appointmentController');

const router = express.Router();
router.get('/', getAllAppointments);
router.get('/status', appointmentStatus);

module.exports = router;
