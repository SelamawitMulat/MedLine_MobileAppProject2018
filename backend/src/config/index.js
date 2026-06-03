const path = require('path');
const dotenv = require('dotenv');

dotenv.config();

module.exports = {
  PORT: process.env.PORT || 4000,
  DB_FILE: process.env.DB_FILE || path.join(__dirname, '..', 'database', 'medline.db'),
};
