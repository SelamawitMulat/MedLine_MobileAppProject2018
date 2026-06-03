module.exports = function allowRoles(...allowedRoles) {
  return (req, res, next) => {
    if (!req.user || !req.user.role) {
      const error = new Error('Authorization required');
      error.status = 401;
      return next(error);
    }

    if (!allowedRoles.includes(req.user.role)) {
      const error = new Error('Forbidden');
      error.status = 403;
      return next(error);
    }

    next();
  };
};
