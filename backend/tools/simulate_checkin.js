// Usage: node simulate_checkin.js <appointmentId>
// Sends a PUT to /api/appointments/:id with checked_in flag
const BASE = process.env.BASE || 'http://localhost:4000';
const id = process.argv[2];
if (!id) {
  console.error('Usage: node simulate_checkin.js <appointmentId>');
  process.exit(2);
}

async function run() {
  const url = `${BASE}/api/appointments/${id}`;
  const body = { status: 'checked_in', checked_in: 1 };
  try {
    const res = await fetch(url, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(body),
    });
    const data = await res.json();
    console.log('Status:', res.status);
    console.log('Body:', JSON.stringify(data, null, 2));
  } catch (err) {
    console.error('Request failed:', err);
    process.exit(1);
  }
}

run();
