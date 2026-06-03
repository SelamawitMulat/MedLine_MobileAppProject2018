const jwt = require('jsonwebtoken');
const { JWT_SECRET, JWT_EXPIRES_IN } = require('../../config');

exports.sign = (payload) => {
	return jwt.sign(payload, JWT_SECRET, { expiresIn: JWT_EXPIRES_IN });
};

exports.verify = (token) => {
	// Let jwt.verify throw if invalid — caller should handle errors
	return jwt.verify(token, JWT_SECRET);
};
