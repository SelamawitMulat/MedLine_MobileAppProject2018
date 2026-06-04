// Usage: node e2e_book_and_checkin.js
// Creates an appointment then checks it in, then fetches all appointments to verify.
const BASE = process.env.BASE || 'http://localhost:4000';
const fetch = globalThis.fetch || require('node-fetch');

async function run() {
  // 1) Create appointment
  const createUrl = `${BASE}/api/appointments`;
  const createBody = {
    patientId: '5',
    appointmentDate: new Date(Date.now() + 24 * 60 * 60 * 1000)
      .toISOString()
      .split('T')[0],
    appointmentTime: '09:30',
    reason: 'E2E test booking',
  };
  console.log('Creating appointment...');
  const createRes = await fetch(createUrl, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(createBody),
  });
  const createData = await createRes.json();
  console.log('Create status', createRes.status);
  console.log(JSON.stringify(createData, null, 2));

  const id = createData?.appointment?.id || createData?.id;
  if (!id) {
    console.error('Failed to create appointment, no id returned');
    process.exit(1);
  }

  // 2) Check-in (PUT)
  console.log(`Checking in appointment ${id}...`);
  const checkUrl = `${BASE}/api/appointments/${id}`;
  const checkRes = await fetch(checkUrl, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ status: 'checked_in', checked_in: 1 }),
  });
  const checkData = await checkRes.json();
  console.log('Check-in status', checkRes.status);
  console.log(JSON.stringify(checkData, null, 2));

  // 3) Verify via GET all
  console.log('Fetching all appointments to verify...');
  const allRes = await fetch(`${BASE}/api/appointments`);
  const allData = await allRes.json();
  console.log('GET all status', allRes.status);
  const found = (allData.appointments || allData).find((a) => a.id == id || a.id == String(id));
  console.log('Found appointment:', found ? JSON.stringify(found, null, 2) : 'NOT FOUND');
}

run().catch((e) => {
  console.error('E2E script error', e);
  process.exit(1);
});
