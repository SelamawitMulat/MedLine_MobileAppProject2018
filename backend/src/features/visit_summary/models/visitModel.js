module.exports = {
  buildVisitSummary: ({ appointmentId, diagnosis, prescription, notes }) => ({
    appointment_id: appointmentId,
    diagnosis,
    prescription,
    notes,
  }),
};
