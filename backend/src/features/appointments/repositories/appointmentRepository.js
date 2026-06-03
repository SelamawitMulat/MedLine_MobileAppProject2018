const db = require('../../../database/connection');

exports.findAll = async () => {
  return new Promise((resolve, reject) => {
    const sql = 'SELECT * FROM appointments';
    db.all(sql, [], (err, rows) => {
      if (err) return reject(err);
      resolve(rows || []);
    });
  });
};
