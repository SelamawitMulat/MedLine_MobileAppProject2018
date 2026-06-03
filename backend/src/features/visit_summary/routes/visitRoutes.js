const express = require('express');
const { visitSummaryStatus } = require('../controllers/visitController');

const router = express.Router();
router.get('/status', visitSummaryStatus);

module.exports = router;
