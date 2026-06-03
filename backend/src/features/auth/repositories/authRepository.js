const db = require('../../../database/connection');

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
  return new Promise((resolve, reject) => {
    const sql = `INSERT INTO users (name, email, password_hash, role) VALUES (?, ?, ?, ?)`;
    db.run(sql, [name, email, passwordHash, role], function (err) {
      if (err) return reject(err);
      const id = this.lastID;
      const select = 'SELECT id, name, email, role, created_at FROM users WHERE id = ? LIMIT 1';
      db.get(select, [id], (err2, row) => {
        if (err2) return reject(err2);
        resolve(row);
      });
    });
  });
};

exports.deleteUserById = async (id) => {
  return new Promise((resolve, reject) => {
    // Delete visit_summaries linked to appointments of this user
    const deleteVisitSql = `DELETE FROM visit_summaries WHERE appointment_id IN (SELECT id FROM appointments WHERE patient_id = ?)`;
    const deleteAppointmentsSql = `DELETE FROM appointments WHERE patient_id = ?`;
    const deleteUserSql = `DELETE FROM users WHERE id = ?`;

    db.serialize(() => {
      db.run('BEGIN TRANSACTION');
      db.run(deleteVisitSql, [id], function (err) {
        if (err) return db.run('ROLLBACK', () => reject(err));
        db.run(deleteAppointmentsSql, [id], function (err2) {
          if (err2) return db.run('ROLLBACK', () => reject(err2));
          db.run(deleteUserSql, [id], function (err3) {
            if (err3) return db.run('ROLLBACK', () => reject(err3));
            db.run('COMMIT', (cErr) => {
              if (cErr) return reject(cErr);
              resolve(true);
            });
          });
        });
      });
    });
  });
};
