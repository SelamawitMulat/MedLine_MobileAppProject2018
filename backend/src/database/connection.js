const sqlite3 = require('sqlite3');
const path = require('path');
const { DB_FILE } = require('../config');

const sqlite = sqlite3.verbose();
const dbPath = path.isAbsolute(DB_FILE) ? DB_FILE : path.resolve(process.cwd(), DB_FILE);

const db = new sqlite.Database(dbPath, (err) => {
  if (err) {
    console.error('SQLite connection error:', err.message);
    return;
  }
  console.log('SQLite connected at', dbPath);
});

db.serialize();

module.exports = db;
