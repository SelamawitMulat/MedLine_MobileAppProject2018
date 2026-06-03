const authService = require('../services/authService');

exports.signup = async (req, res, next) => {
  try {
    const { name, email, password } = req.body || {};
    const user = await authService.signup({ name: (name || '').trim(), email: (email || '').trim(), password });
    res.status(201).json({ user });
  } catch (err) {
    next(err);
  }
};

exports.login = async (req, res, next) => {
  try {
    const { email, password } = req.body || {};
    const result = await authService.login({ email: (email || '').trim(), password });
    res.json(result);
  } catch (err) {
    next(err);
  }
};

exports.me = async (req, res, next) => {
  try {
    if (!req.user || !req.user.id) {
      return res.json({
        message:
          'Protected endpoint. Use GET /api/auth/me with Authorization: Bearer <token>.',
      });
    }

    const user = await authService.getUserById(req.user.id);
    if (!user) return res.status(404).json({ error: 'User not found' });
    res.json({ user });
  } catch (err) {
    next(err);
  }
};
