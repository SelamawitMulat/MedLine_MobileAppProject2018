const express = require('express');
const authRoutes = require('../features/auth/routes/authRoutes');
const appointmentRoutes = require('../features/appointments/routes/appointmentRoutes');
const queueRoutes = require('../features/queue/routes/queueRoutes');
const {
  visitSummaryStatus,
  getAllVisitSummaries,
  getVisitSummary,
  createVisitSummary,
  updateVisitSummary,
  deleteVisitSummary,
} = require('../features/visit_summary/controllers/visitController');
const userRoutes = require('../features/users/routes/userRoutes');

const router = express.Router();

router.use('/auth', authRoutes);
router.use('/users', userRoutes);
router.use('/appointments', appointmentRoutes);
router.use('/queue', queueRoutes);

router.get('/visit-summaries', getAllVisitSummaries);
router.post('/visit-summaries', createVisitSummary);
router.get('/visit-summaries/status', visitSummaryStatus);
router.get('/visit-summaries/:appointmentId', getVisitSummary);
router.put('/visit-summaries/:appointmentId', updateVisitSummary);
router.delete('/visit-summaries/:appointmentId', deleteVisitSummary);

module.exports = router;
