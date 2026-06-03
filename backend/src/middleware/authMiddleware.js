const { verify } = require('../shared/utils/jwt');

function authMiddleware(req, res, next) {
  const authHeader = req.headers.authorization;

  if (!authHeader || typeof authHeader !== 'string' || !authHeader.startsWith('Bearer ')) {
    req.user = null;
    return next();
  }

  const parts = authHeader.split(' ');
  if (parts.length !== 2) {
    req.user = null;
    return next();
  }

  const token = parts[1];
  try {
    const payload = verify(token);
    if (!payload || !payload.id) {
      req.user = null;
      return next();
    }

    req.user = payload;
    return next();
  } catch (_) {
    req.user = null;
    return next();
  }
}

module.exports = authMiddleware;
