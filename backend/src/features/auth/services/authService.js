const authRepository = require('../repositories/authRepository');
const { hashPassword, comparePassword } = require('../../../shared/utils/password');
const { sign } = require('../../../shared/utils/jwt');

exports.getAuthStatus = () => ({ ready: true, phase: 'Phase 2' });

exports.deleteAccount = async (id) => {
	if (!id) {
		const err = new Error('Invalid user id');
		err.status = 400;
		throw err;
	}

	await authRepository.deleteUserById(id);
	return true;
};

exports.signup = async ({ name, email, password }) => {
	if (!name || !email || !password) {
		const err = new Error('Invalid input');
		err.status = 400;
		throw err;
	}

	const existing = await authRepository.findUserByEmail(email);
	if (existing) {
		const err = new Error('Email already in use');
		err.status = 409;
		throw err;
	}

	const passwordHash = await hashPassword(password);
	const user = await authRepository.createUser({ name, email, passwordHash, role: 'patient' });
	const token = sign({ id: user.id, role: user.role, email: user.email });
	return { token, user };
};

exports.login = async ({ email, password }) => {
	if (!email || !password) {
		const err = new Error('Invalid input');
		err.status = 400;
		throw err;
	}

	const user = await authRepository.findUserByEmail(email);
	if (!user) {
		const err = new Error('Invalid credentials');
		err.status = 401;
		throw err;
	}

	if (!user.password_hash) {
		const err = new Error('Invalid credentials');
		err.status = 401;
		throw err;
	}

	const valid = await comparePassword(password, user.password_hash);
	if (!valid) {
		const err = new Error('Invalid credentials');
		err.status = 401;
		throw err;
	}

	const token = sign({ id: user.id, role: user.role, email: user.email });
	const { password_hash, ...safeUser } = user;
	return { token, user: safeUser };
};

exports.getUserById = async (id) => {
	if (!id) return null;
	return authRepository.findUserById(id);
};
