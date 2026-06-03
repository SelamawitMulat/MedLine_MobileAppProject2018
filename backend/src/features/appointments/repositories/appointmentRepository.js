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

exports.updateAppointment = async (id, updateFields) => {
  return new Promise((resolve, reject) => {
    const setClauses = [];
    const params = [];

    if (updateFields.date) {
      setClauses.push('date = ?');
      params.push(updateFields.date);
    }
    if (updateFields.time) {
      setClauses.push('time = ?');
      params.push(updateFields.time);
    }

    if (setClauses.length === 0) {
      return reject(new Error('No fields to update'));
    }

    params.push(id);
    const sql = `UPDATE appointments SET ${setClauses.join(', ')} WHERE id = ?`;

    db.run(sql, params, function (err) {
      if (err) return reject(err);
      if (this.changes === 0) {
        const error = new Error('Appointment not found');
        error.status = 404;
        return reject(error);
      }
      resolve({ id, ...updateFields });
    });
  });
};

exports.updateAppointmentStatus = async (id, status) => {
  return new Promise((resolve, reject) => {
    const sql = 'UPDATE appointments SET status = ? WHERE id = ?';
    const params = [status, id];

    db.run(sql, params, function (err) {
      if (err) return reject(err);
      if (this.changes === 0) {
        const error = new Error('Appointment not found');
        error.status = 404;
        return reject(error);
      }
      resolve({ id, status });
    });
  });
};
