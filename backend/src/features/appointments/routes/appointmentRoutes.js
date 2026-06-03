const express = require('express');
const { appointmentStatus } = require('../controllers/appointmentController');

const router = express.Router();
router.get('/status', appointmentStatus);

module.exports = router;
