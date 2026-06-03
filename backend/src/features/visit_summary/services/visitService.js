const visitRepository = require('../repositories/visitRepository');

exports.getStatus = () => ({ ready: true });

exports.getAllVisitSummaries = async () => {
  return visitRepository.findAll();
};
