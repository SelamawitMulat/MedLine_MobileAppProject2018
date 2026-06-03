const express = require('express');
const { queueStatus } = require('../controllers/queueController');

const router = express.Router();
router.get('/status', queueStatus);

module.exports = router;
