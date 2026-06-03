const express = require('express');
const { queueStatus } = require('../controllers/queueController');

const router = express.Router();
router.get('/', (req, res) => {
  res.json({
    message: 'Queue API',
    availableEndpoints: ['POST /api/queue', 'GET /api/queue/:id'],
  });
});
router.get('/status', queueStatus);

module.exports = router;
