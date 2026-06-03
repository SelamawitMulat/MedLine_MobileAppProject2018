const express = require('express');
const {
  visitSummaryStatus,
  getAllVisitSummaries,
} = require('../controllers/visitController');

const router = express.Router();
router.get('/', getAllVisitSummaries);
router.get('/status', visitSummaryStatus);

module.exports = router;
