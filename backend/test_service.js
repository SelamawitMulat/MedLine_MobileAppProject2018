const appointmentService = require('./src/features/appointments/services/appointmentService');

(async () => {
  try {
    const appointments = await appointmentService.getAllAppointments();
    console.log('First appointment from service:');
    console.log(JSON.stringify(appointments[0], null, 2));
  } catch (err) {
    console.error('Error:', err);
  }
})();
