const { verify } = require('../shared/utils/jwt');

function authMiddleware(req, res, next) {
  const authHeader = req.headers.authorization;

  if (!authHeader || typeof authHeader !== 'string' || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ error: 'Unauthorized: missing or invalid Authorization header' });
  }

  const parts = authHeader.split(' ');
  if (parts.length !== 2) {
    return res.status(401).json({ error: 'Unauthorized: malformed Authorization header' });
  }

  const token = parts[1];
  try {
    const payload = verify(token);
    if (!payload || !payload.id) {
      return res.status(401).json({ error: 'Unauthorized: invalid token payload' });
    }

    req.user = payload;
    return next();
  } catch (err) {
    return res.status(401).json({ error: 'Unauthorized: invalid token' });
  }
}

module.exports = authMiddleware;
