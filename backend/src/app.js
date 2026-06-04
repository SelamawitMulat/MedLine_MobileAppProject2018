const express = require('express');
const cors = require('cors');
const loggingMiddleware = require('./middleware/loggingMiddleware');
const routes = require('./routes');
const errorMiddleware = require('./middleware/errorMiddleware');
const {
  visitSummaryStatus,
  getAllVisitSummaries,
  getVisitSummary,
  createVisitSummary,
  updateVisitSummary,
  deleteVisitSummary,
} = require('./features/visit_summary/controllers/visitController');

const app = express();

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(loggingMiddleware);

app.get('/', (req, res) => {
  res.json({
    message: 'MedLine Backend Running',
    routes: [
      '/api/auth/signup',
      '/api/auth/login',
      '/api/auth/me',
      '/api/users',
      '/api/appointments',
      '/api/visit-summaries',
    ],
  });
});

app.get('/api/visit-summaries', getAllVisitSummaries);
app.post('/api/visit-summaries', createVisitSummary);
app.get('/api/visit-summaries/status', visitSummaryStatus);
app.get('/api/visit-summaries/:appointmentId', getVisitSummary);
app.put('/api/visit-summaries/:appointmentId', updateVisitSummary);
app.delete('/api/visit-summaries/:appointmentId', deleteVisitSummary);

app.use('/api', routes);

app.use((req, res) => {
  res.status(404).json({
    error: 'Route not found',
    message: 'Check API documentation.',
  });
});

app.use(errorMiddleware);

module.exports = app;
