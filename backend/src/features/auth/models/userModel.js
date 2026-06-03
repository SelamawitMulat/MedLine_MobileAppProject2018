module.exports = {
  buildUserPayload: ({ name, email, passwordHash, role }) => ({
    name,
    email,
    password_hash: passwordHash,
    role,
  }),
};
