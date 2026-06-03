const path = require('path');
const dotenv = require('dotenv');

dotenv.config();

module.exports = {
  PORT: process.env.PORT || 4000,
  DB_FILE: process.env.DB_FILE || path.join(__dirname, '..', 'database', 'medline.db'),
  JWT_SECRET: process.env.JWT_SECRET || 'change_this_jwt_secret',
  JWT_EXPIRES_IN: process.env.JWT_EXPIRES_IN || '7d',
};
