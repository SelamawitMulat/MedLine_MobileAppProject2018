const visitService = require('../services/visitService');

exports.visitSummaryStatus = (req, res) => {
  res.json({ message: 'Visit summaries feature placeholder ready for Phase 2' });
};

exports.getAllVisitSummaries = async (req, res, next) => {
  try {
    const summaries = await visitService.getAllVisitSummaries();
    res.json({ visitSummaries: summaries });
  } catch (err) {
    next(err);
  }
};

exports.getVisitSummary = async (req, res, next) => {
  try {
    const { appointmentId } = req.params;
    const summary = await visitService.getVisitSummaryByAppointmentId(appointmentId);
    if (!summary) {
      return res.status(404).json({ message: 'Visit summary not found' });
    }
    res.json({ visitSummary: summary });
  } catch (err) {
    next(err);
  }
};

exports.createVisitSummary = async (req, res, next) => {
  try {
    const summary = await visitService.createVisitSummary(req.body);
    res.status(201).json({ visitSummary: summary });
  } catch (err) {
    next(err);
  }
};

exports.updateVisitSummary = async (req, res, next) => {
  try {
    const { appointmentId } = req.params;
    const summary = await visitService.updateVisitSummary(appointmentId, req.body);
    res.json({ visitSummary: summary });
  } catch (err) {
    next(err);
  }
};

exports.deleteVisitSummary = async (req, res, next) => {
  try {
    const { appointmentId } = req.params;
    await visitService.deleteVisitSummary(appointmentId);
    res.status(204).end();
  } catch (err) {
    next(err);
  }
};
