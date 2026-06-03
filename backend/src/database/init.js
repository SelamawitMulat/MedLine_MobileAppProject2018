const fs = require('fs');
const path = require('path');
const bcrypt = require('bcryptjs');
const db = require('./connection');

const schemaPath = path.join(__dirname, 'schema.sql');
const schemaSql = fs.readFileSync(schemaPath, 'utf-8');

function createSchema() {
  return new Promise((resolve, reject) => {
    db.exec(schemaSql, (err) => {
      if (err) {
        return reject(err);
      }
      console.log('Database schema initialized');
      resolve();
    });
  });
}

function seedDefaultDoctor() {
  const passwordHash = bcrypt.hashSync('seli2123', 10);
  const insertSql = `
    INSERT INTO users (name, email, password_hash, role)
    SELECT ?, ?, ?, ?
    WHERE NOT EXISTS (SELECT 1 FROM users WHERE email = ?);
  `;

  return new Promise((resolve, reject) => {
    db.run(insertSql, ['Default Doctor', 'selam@gmail.com', passwordHash, 'doctor', 'selam@gmail.com'], function (err) {
      if (err) {
        return reject(err);
      }
      if (this.changes) {
        console.log('Default doctor seeded: selam@gmail.com');
      } else {
        console.log('Default doctor already exists, skipping seed.');
      }
      resolve();
    });
  });
}

function migrateAppointmentsTable() {
  return new Promise((resolve, reject) => {
    db.all("PRAGMA table_info(appointments);", [], (err, columns) => {
      if (err) return reject(err);
      
      const columnNames = columns.map((col) => col.name);
      const missingColumns = [];
      
      if (!columnNames.includes('doctor_id')) {
        missingColumns.push('ALTER TABLE appointments ADD COLUMN doctor_id INTEGER');
      }
      if (!columnNames.includes('reason')) {
        missingColumns.push('ALTER TABLE appointments ADD COLUMN reason TEXT');
      }
      
      if (missingColumns.length === 0) {
        return resolve();
      }
      
      let completed = 0;
      missingColumns.forEach((sql) => {
        db.run(sql, (err) => {
          if (err) return reject(err);
          completed++;
          if (completed === missingColumns.length) {
            console.log('Appointment table migrated with missing columns');
            resolve();
          }
        });
      });
    });
  });
}

async function initializeDatabase() {
  await createSchema();
  await migrateAppointmentsTable();
  await seedDefaultDoctor();
}

module.exports = {
  initializeDatabase,
};
