const express = require('express');
const { loginStatus, deleteAccount, signup, login, me } = require('../controllers/authController');
const authMiddleware = require('../../../middleware/authMiddleware');

const router = express.Router();

router.get('/status', loginStatus);
router.post('/signup', signup);
router.post('/login', login);
router.get('/me', authMiddleware, me);
router.delete('/me', authMiddleware, deleteAccount);

module.exports = router;
