const app = require('./app');
const { PORT } = require('./config');
const { initializeDatabase } = require('./database/seed');

async function startServer() {
  try {
    await initializeDatabase();
    app.listen(PORT, () => {
      console.log(`MedLine backend listening on port ${PORT}`);
    });
  } catch (error) {
    console.error('Failed to start server:', error.message);
    process.exit(1);
  }
}

startServer();
