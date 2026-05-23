# Doctor ID Consistency - Visual Flow

## System Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│                  MedLine App Architecture               │
└─────────────────────────────────────────────────────────┘

                     Authentication Layer
        ┌────────────────────────────────────────┐
        │  authProvider                          │
        │  - Tracks logged-in user               │
        │  - User role: "Doctor" or "Patient"    │
        │  - User ID: from API                   │
        └────────────────────────────────────────┘
                           ↓
                 Doctor ID Provider Layer
        ┌────────────────────────────────────────┐
        │  doctorIdProvider                      │
        │                                        │
        │  IF user.role == "doctor":             │
        │    → return user.id                    │
        │  ELSE:                                 │
        │    → return md5(normalized_name)      │
        └────────────────────────────────────────┘
                           ↓
                    Business Logic Layer
        ┌──────────────────┬──────────────────┐
        │                  │                  │
    ┌───▼────────┐  ┌──────▼──────┐  ┌──────▼──────┐
    │  Booking   │  │  Reschedule │  │   Doctor    │
    │ Appointment│  │ Appointment │  │   Queue     │
    └────────────┘  └─────────────┘  └─────────────┘
        │                  │                  │
        └──────────────────┼──────────────────┘
                           ↓
                  Appointment Model
        ┌────────────────────────────────────────┐
        │  Appointment                           │
        │  - id: unique appointment ID           │
        │  - doctorId: consistent doctor ID ◄─┐  │
        │  - patientId: patient's user ID       │  │
        │  - doctorName: normalized name        │  │
        │  - patientName: patient's name        │  │
        │  - date & timeSlot: scheduled time    │  │
        │  - status: "Upcoming"/"Completed"/... │  │
        └────────────────────────────────────────┘  │
                           │                        │
                    Flows to Database               │
                   (Local SQLite Cache)             │
                    & API Server                    │
```

## Doctor ID Assignment Examples

### Example 1: Doctor User Books Appointment
```
Input:  Doctor "Dr. Selam Mulat" logs in
        ↓
        authProvider reads:
          user.id = "doc-001"
          user.role = "Doctor"
        ↓
        doctorIdProvider returns:
          Since role == "doctor" → return "doc-001"
        ↓
Output: doctorId = "doc-001"
        (Real user ID from API)
```

### Example 2: Patient Books Appointment with Doctor Name
```
Input:  Patient selects "Dr. Selam Mulat" from dropdown
        ↓
        authProvider reads:
          user.id = "pat-001"
          user.role = "Patient"
        ↓
        doctorIdProvider returns:
          Since role != "doctor":
            doctorName = "Dr. Selam Mulat"
            normalized = "selam mulat"
            doctorId = md5("selam mulat")
                     = "abc123def456..." (32-char hex)
        ↓
Output: doctorId = "abc123def456..."
        (Deterministic hash of doctor name)
```

### Example 3: Doctor Views Queue Management
```
Input:  Doctor logs in, views "Queue Management"
        ↓
        Current doctorId = "doc-001"
        ↓
        System queries appointments WHERE doctorId = "doc-001"
        ↓
Output: Returns only appointments assigned to this doctor
        - Patient's appointment from Example 2:
          doctorId: "abc123def456..." ← Different hash, not shown
        - Patient's appointment with same doctor (new system):
          doctorId: "doc-001" ← Matches current doctor, shown ✓
```

## Database Schema Impact

### Appointments Table
```sql
CREATE TABLE appointments_cache (
  id TEXT PRIMARY KEY,
  patientId TEXT NOT NULL,        -- Who booked it
  patientName TEXT NOT NULL,      -- Patient's display name
  doctorId TEXT NOT NULL,         -- Who is assigned ← KEY FIELD
  doctorName TEXT NOT NULL,       -- Doctor's display name
  date TEXT NOT NULL,             -- YYYY-MM-DD
  timeSlot TEXT NOT NULL,         -- HH:MM-HH:MM
  status TEXT DEFAULT 'Upcoming', -- Upcoming/Completed/Cancelled
  createdAt TEXT NOT NULL
);

Query for Doctor's Appointments:
  SELECT * FROM appointments_cache
  WHERE doctorId = ?  ← Uses consistent doctorId
  ORDER BY date, timeSlot
```

### Visit Summaries Table
```sql
CREATE TABLE visit_summaries_cache (
  id TEXT PRIMARY KEY,
  appointmentId TEXT NOT NULL,  -- Links back to appointment
  patientId TEXT NOT NULL,      -- Who visited
  doctorId TEXT NOT NULL,       -- Who examined ← KEY FIELD
  patientName TEXT NOT NULL,
  doctorName TEXT NOT NULL,
  date TEXT NOT NULL,
  diagnosis TEXT,
  prescription TEXT,
  ...
);

Query for Doctor's Visit Histories:
  SELECT * FROM visit_summaries_cache
  WHERE doctorId = ?  ← Same consistent ID
  ORDER BY date DESC
```

## Data Consistency Guarantee

### Single Source of Truth for Doctor ID
```
At creation time:
  ┌─ Patient books with "Dr. Selam Mulat"
  │
  └─→ doctorIdProvider calculates
      ↓
      md5("selam mulat") = "xyz789..."
      ↓
      Stored in: appointments_cache.doctorId = "xyz789..."

Later operations:
  ├─ Reschedule: copyWith(date: ..., timeSlot: ...)
  │  → doctorId preserved automatically
  │
  ├─ Visit Summary: copyFrom(appointment)
  │  → doctorId = "xyz789..." (from appointment)
  │
  └─ Query: WHERE doctorId = "xyz789..."
     → Returns all related records consistently
```

## Benefits

✅ **Consistency**: Same doctor name → same ID across all records
✅ **Deterministic**: MD5 guarantees same input = same output
✅ **Scalable**: Works with real doctor IDs when available
✅ **Testable**: Can verify ID generation independently
✅ **Queryable**: Database queries use consistent ID columns
✅ **Backward Compatible**: Existing appointments gradually updated
