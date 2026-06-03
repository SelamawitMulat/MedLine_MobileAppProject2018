const db = require('../../../database/connection');
const { buildUserPayload } = require('../models/userModel');

exports.findUserByEmail = async (email) => {
  return new Promise((resolve, reject) => {
    const sql = 'SELECT id, name, email, password_hash, role, created_at FROM users WHERE email = ? LIMIT 1';
    db.get(sql, [email], (err, row) => {
      if (err) return reject(err);
      resolve(row || null);
    });
  });
};

exports.findUserById = async (id) => {
  return new Promise((resolve, reject) => {
    const sql = 'SELECT id, name, email, role, created_at FROM users WHERE id = ? LIMIT 1';
    db.get(sql, [id], (err, row) => {
      if (err) return reject(err);
      resolve(row || null);
    });
  });
};

exports.createUser = async ({ name, email, passwordHash, role = 'patient' }) => {
  const payload = buildUserPayload({ name, email, passwordHash, role });
  return new Promise((resolve, reject) => {
    const sql = `INSERT INTO users (name, email, password_hash, role) VALUES (?, ?, ?, ?)`;
    db.run(sql, [payload.name, payload.email, payload.password_hash, payload.role], function (err) {
      if (err) return reject(err);
      // retrieve created user
      const id = this.lastID;
      const select = 'SELECT id, name, email, role, created_at FROM users WHERE id = ? LIMIT 1';
      db.get(select, [id], (err2, row) => {
        if (err2) return reject(err2);
        resolve(row);
      });
    });
  });
};
