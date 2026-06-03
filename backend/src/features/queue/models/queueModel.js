module.exports = {
  buildQueueItem: ({ appointmentId, position, status }) => ({
    appointment_id: appointmentId,
    position,
    status,
  }),
};
