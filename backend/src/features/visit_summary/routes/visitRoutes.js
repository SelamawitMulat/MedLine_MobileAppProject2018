const express = require('express');
const {
  visitSummaryStatus,
  getAllVisitSummaries,
  getVisitSummary,
  createVisitSummary,
  updateVisitSummary,
  deleteVisitSummary,
} = require('../controllers/visitController');

const router = express.Router({ mergeParams: true });
router.get('/', getAllVisitSummaries);
router.post('/', createVisitSummary);
router.get('/status', visitSummaryStatus);
router.get('/:appointmentId', getVisitSummary);
router.put('/:appointmentId', updateVisitSummary);
router.delete('/:appointmentId', deleteVisitSummary);

module.exports = router;
