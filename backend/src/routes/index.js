const express = require('express');
const authRoutes = require('../features/auth/routes/authRoutes');
const appointmentRoutes = require('../features/appointments/routes/appointmentRoutes');
const queueRoutes = require('../features/queue/routes/queueRoutes');
const visitRoutes = require('../features/visit_summary/routes/visitRoutes');
const userRoutes = require('../features/users/routes/userRoutes');

const router = express.Router();

router.use('/auth', authRoutes);
router.use('/users', userRoutes);
router.use('/appointments', appointmentRoutes);
router.use('/queue', queueRoutes);
router.use('/visit-summaries', visitRoutes);

module.exports = router;
