const sqlite3 = require('sqlite3').verbose();
const db = new sqlite3.Database('./src/database/medline.db');

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
    u.name as patientName,
    d.name as doctorName
  FROM appointments a
  LEFT JOIN users u ON a.patient_id = u.id
  LEFT JOIN users d ON a.doctor_id = d.id
  LIMIT 1
`;

db.all(sql, [], (err, rows) => {
  if (err) {
    console.error('Error:', err);
  } else {
    console.log(JSON.stringify(rows, null, 2));
  }
  db.close();
});
