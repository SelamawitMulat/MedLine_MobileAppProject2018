const express = require('express');
const cors = require('cors');
const routes = require('./routes');
const errorMiddleware = require('./middleware/errorMiddleware');

const app = express();

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.get('/', (req, res) => {
  res.json({ status: 'ok', message: 'MedLine backend foundation is running' });
});

app.use('/api', routes);
app.use(errorMiddleware);

module.exports = app;
