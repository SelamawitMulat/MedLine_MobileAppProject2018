const express = require('express');
const { loginStatus } = require('../controllers/authController');

const router = express.Router();
router.get('/status', loginStatus);

module.exports = router;
