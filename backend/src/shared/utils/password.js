const bcrypt = require('bcryptjs');

const SALT_ROUNDS = 10;

exports.hashPassword = async (password) => {
	if (!password || typeof password !== 'string') throw new Error('Invalid password');
	const salt = await bcrypt.genSalt(SALT_ROUNDS);
	return bcrypt.hash(password, salt);
};

exports.comparePassword = async (password, hash) => {
	if (!password || !hash) return false;
	return bcrypt.compare(password, hash);
};

exports.hashPasswordSync = (password) => {
	const salt = bcrypt.genSaltSync(SALT_ROUNDS);
	return bcrypt.hashSync(password, salt);
};
