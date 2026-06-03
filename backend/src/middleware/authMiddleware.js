function authMiddleware(req, res, next) {
  const authHeader = req.headers.authorization || '';

  if (!authHeader.startsWith('Bearer ')) {
    req.user = null;
    return next();
  }

  const token = authHeader.split(' ')[1];
  req.user = {
    id: null,
    role: null,
    token,
    placeholder: true,
  };

  return next();
}

module.exports = authMiddleware;
