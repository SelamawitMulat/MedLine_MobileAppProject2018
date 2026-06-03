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
