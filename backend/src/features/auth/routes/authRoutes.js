const express = require('express');
const { signup, login, me } = require('../controllers/authController');
const authMiddleware = require('../../../middleware/authMiddleware');

const router = express.Router();

router.get('/signup', (req, res) => {
  res.json({
    message: 'Signup endpoint available. Use POST /api/auth/signup to create an account.',
  });
});

router.get('/login', (req, res) => {
  res.json({
    message: 'Login endpoint available. Use POST /api/auth/login to authenticate.',
  });
});

router.post('/signup', signup);
router.post('/login', login);
router.get('/me', authMiddleware, me);

module.exports = router;
