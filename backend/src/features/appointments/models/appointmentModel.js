module.exports = {
  appointmentShape: ({ patientId, date, time, status, queuePosition, checkedIn }) => ({
    patient_id: patientId,
    date,
    time,
    status,
    queue_position: queuePosition,
    checked_in: checkedIn,
  }),
};
