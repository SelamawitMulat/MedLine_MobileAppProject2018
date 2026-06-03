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

exports.insertAppointment = async (appointment) => {
  return new Promise((resolve, reject) => {
    const sql = `INSERT INTO appointments 
      (patient_id, doctor_id, date, time, reason, status, queue_position, checked_in)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)`;

    const params = [
      appointment.patient_id,
      appointment.doctor_id,
      appointment.date,
      appointment.time,
      appointment.reason,
      appointment.status,
      appointment.queue_position,
      appointment.checked_in,
    ];

    db.run(sql, params, function (err) {
      if (err) return reject(err);
      resolve({ id: this.lastID, ...appointment });
    });
  });
};
