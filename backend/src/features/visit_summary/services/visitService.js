const visitRepository = require('../repositories/visitRepository');
const { buildVisitSummary } = require('../models/visitModel');

exports.getStatus = () => ({ ready: true });

exports.getAllVisitSummaries = async () => {
  return visitRepository.findAll();
};

exports.getVisitSummaryByAppointmentId = async (appointmentId) => {
  return visitRepository.findByAppointmentId(appointmentId);
};

exports.createVisitSummary = async (summaryData) => {
  if (!summaryData.appointmentId) {
    const error = new Error('Missing required field: appointmentId');
    error.status = 400;
    throw error;
  }

  const summary = buildVisitSummary(summaryData);
  return visitRepository.insert(summary);
};

exports.updateVisitSummary = async (appointmentId, summaryData) => {
  const existing = await visitRepository.findByAppointmentId(appointmentId);
  if (!existing) {
    const error = new Error('Visit summary not found');
    error.status = 404;
    throw error;
  }

  const summary = buildVisitSummary({
    appointmentId,
    diagnosis: summaryData.diagnosis ?? existing.diagnosis,
    prescription: summaryData.prescription ?? existing.prescription,
    notes: summaryData.notes ?? existing.notes,
  });

  return visitRepository.update(appointmentId, summary);
};

exports.deleteVisitSummary = async (appointmentId) => {
  const deletedCount = await visitRepository.delete(appointmentId);
  if (deletedCount === 0) {
    const error = new Error('Visit summary not found');
    error.status = 404;
    throw error;
  }
  return deletedCount;
};
