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

async function initializeDatabase() {
  await createSchema();
  await seedDefaultDoctor();
}

module.exports = {
  initializeDatabase,
};
