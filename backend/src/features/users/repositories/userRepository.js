const db = require('../../../database/connection');

exports.findAllUsers = async () => {
  return new Promise((resolve, reject) => {
    const sql = 'SELECT id, name, email, role, created_at FROM users';
    db.all(sql, [], (err, rows) => {
      if (err) return reject(err);
      resolve(rows || []);
    });
  });
};
