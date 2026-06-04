const db = require('../../../database/connection');

exports.findAll = async () => {
  return new Promise((resolve, reject) => {
    const sql = 'SELECT * FROM visit_summaries';
    db.all(sql, [], (err, rows) => {
      if (err) return reject(err);
      resolve(rows || []);
    });
  });
};

exports.findByAppointmentId = async (appointmentId) => {
  return new Promise((resolve, reject) => {
    const sql = 'SELECT * FROM visit_summaries WHERE appointment_id = ?';
    db.get(sql, [appointmentId], (err, row) => {
      if (err) return reject(err);
      resolve(row || null);
    });
  });
};

exports.insert = async (visitSummary) => {
  return new Promise((resolve, reject) => {
    const sql = 'INSERT INTO visit_summaries (appointment_id, diagnosis, prescription, notes) VALUES (?, ?, ?, ?)';
    db.run(
      sql,
      [
        visitSummary.appointment_id,
        visitSummary.diagnosis,
        visitSummary.prescription,
        visitSummary.notes,
      ],
      function (err) {
        if (err) return reject(err);
        resolve({ id: this.lastID, ...visitSummary });
      },
    );
  });
};

exports.update = async (appointmentId, visitSummary) => {
  return new Promise((resolve, reject) => {
    const sql =
      'UPDATE visit_summaries SET diagnosis = ?, prescription = ?, notes = ? WHERE appointment_id = ?';
    db.run(
      sql,
      [visitSummary.diagnosis, visitSummary.prescription, visitSummary.notes, appointmentId],
      function (err) {
        if (err) return reject(err);
        if (this.changes === 0) {
          return reject(new Error('Visit summary not found'));
        }
        resolve({ appointment_id: appointmentId, ...visitSummary });
      },
    );
  });
};

exports.delete = async (appointmentId) => {
  return new Promise((resolve, reject) => {
    const sql = 'DELETE FROM visit_summaries WHERE appointment_id = ?';
    db.run(sql, [appointmentId], function (err) {
      if (err) return reject(err);
      resolve(this.changes);
    });
  });
};
