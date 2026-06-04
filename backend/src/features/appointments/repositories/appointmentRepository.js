const db = require('../../../database/connection');

exports.findAll = async () => {
  return new Promise((resolve, reject) => {
    const sql = `
      SELECT 
        a.id,
        a.patient_id,
        a.doctor_id,
        a.date,
        a.time,
        a.reason,
        a.status,
        a.queue_position,
        a.checked_in,
        COALESCE(u.name, 'Unknown Patient') as patientName,
        COALESCE(d.name, 'Unknown Doctor') as doctorName
      FROM appointments a
      LEFT JOIN users u ON a.patient_id = u.id
      LEFT JOIN users d ON a.doctor_id = d.id
    `;
    db.all(sql, [], (err, rows) => {
      if (err) return reject(err);
      resolve(rows || []);
    });
  });
};

const fetchAppointmentById = (id) => {
  return new Promise((resolve, reject) => {
    const sql = `
      SELECT 
        a.id,
        a.patient_id,
        a.doctor_id,
        a.date,
        a.time,
        a.reason,
        a.status,
        a.queue_position,
        a.checked_in,
        COALESCE(u.name, 'Unknown Patient') as patientName,
        COALESCE(d.name, 'Unknown Doctor') as doctorName
      FROM appointments a
      LEFT JOIN users u ON a.patient_id = u.id
      LEFT JOIN users d ON a.doctor_id = d.id
      WHERE a.id = ?
    `;
    db.get(sql, [id], (err, row) => {
      if (err) return reject(err);
      resolve(row || null);
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
      const newlyInsertedId = this.lastID;
      fetchAppointmentById(newlyInsertedId)
        .then((row) => {
          if (!row) return reject(new Error('Inserted appointment not found'));
          resolve(row);
        })
        .catch(reject);
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

    if (updateFields.status) {
      setClauses.push('status = ?');
      params.push(updateFields.status);
    }

    if (typeof updateFields.checked_in !== 'undefined') {
      setClauses.push('checked_in = ?');
      params.push(updateFields.checked_in ? 1 : 0);
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
      fetchAppointmentById(id)
        .then((row) => {
          if (!row) return reject(new Error('Updated appointment not found'));
          resolve(row);
        })
        .catch(reject);
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
      fetchAppointmentById(id)
        .then((row) => {
          if (!row) return reject(new Error('Updated appointment not found'));
          resolve(row);
        })
        .catch(reject);
    });
  });
};
