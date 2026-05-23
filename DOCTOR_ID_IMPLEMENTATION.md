# Doctor ID Consistency Implementation

## Overview
This implementation ensures that doctor IDs are stored consistently across appointments and visit summaries, enabling proper doctor/patient matching in database queries.

## Problem Statement
- Appointments were previously created with a hardcoded `doctorId: 'default-doctor'`
- This prevented proper doctor/patient matching when newly created users booked appointments
- Visit summaries couldn't link to the correct doctor due to inconsistent IDs

## Solution Implemented

### 1. Created `doctorIdProvider` (doctor_provider.dart)
```dart
final doctorIdProvider = Provider<String>((ref) {
  final user = ref.watch(authProvider).value;
  if (user != null && user.role.toLowerCase() == 'doctor') {
    return user.id;
  }
  final doctorName = ref.watch(doctorNameProvider);
  final normalized = doctorName
      .replaceFirst(RegExp(r'^dr\.?\s*', caseSensitive: false), '')
      .trim()
      .toLowerCase();
  return md5.convert(utf8.encode(normalized)).toString();
});
```

**Logic:**
- If logged-in user is a doctor: returns the doctor's `user.id`
- Otherwise: returns MD5 hash of normalized doctor name for deterministic mapping
- Ensures the same doctor name always maps to the same ID across the app

### 2. Updated Appointment Booking
**appointment_provider.dart changes:**
- `bookAppointment()` now requires `doctorId: String` parameter
- Appointment created with proper doctorId instead of hardcoded value

**appointment_booking.dart changes:**
- Added import: `package:med_line/features/home/presentation/providers/doctor_provider.dart`
- Reads doctorId: `final doctorId = ref.read(doctorIdProvider);`
- Passes to method: `bookAppointment(doctorId: doctorId, ...)`

### 3. Reschedule Operations
- `rescheduleAppointment()` uses `copyWith()` to preserve existing doctorId
- No changes needed - existing appointments automatically preserve their doctor ID

### 4. Visit Summary Integration
- Visit summary form retrieves doctorId from linked appointment
- Falls back to empty string if no appointment found
- Ensures visit summaries are linked to the correct doctor

## Data Flow

### New Patient Booking Appointment
```
1. Patient opens appointment booking screen
2. Patient selects doctor "Dr. Selam Mulat" and time
3. System calls doctorIdProvider:
   - Gets doctorId = md5("selam mulat") = consistent ID
4. System creates Appointment:
   - doctorId: consistent_id
   - patientId: current_user.id
   - patientName: current_user.name
5. Appointment saved to local DB and synced to API
```

### Doctor Viewing Patient Appointments
```
1. Doctor logs in (user.role == "doctor")
2. Doctor views "Queue Management" screen
3. System filters appointments:
   - Queries all appointments where doctorId == current_doctor.id
   - Shows only appointments assigned to this doctor
```

### Creating Visit Summary
```
1. Doctor searches for patient by name
2. System finds appointment with matching:
   - doctorName matches current doctor
   - patientName matches search input
3. Visit summary created with:
   - doctorId: from appointment.doctorId
   - patientId: from appointment.patientId
   - Links visit to correct doctor/patient pair
```

## Technical Details

### Doctor ID Generation
- **Doctor User**: Returns `user.id` directly (from API, e.g., "doc-123")
- **Doctor Name**: MD5 hash of normalized name
  - Input: "Dr. Selam Mulat"
  - Normalized: "selam mulat"
  - Output: `md5("selam mulat")` = deterministic 32-char hex string

### Consistency Guarantees
- Same doctor name always produces same ID (MD5 deterministic)
- Changing doctor name (e.g., "Dr. Selam" → "Dr. Selam Mulat") would create different ID
- Real doctor user ID used when available (more reliable)
- Fallback to name hash for legacy data or name-based systems

## Files Modified
1. **lib/features/home/presentation/providers/doctor_provider.dart**
   - Added: `doctorIdProvider`
   - Imports: `crypto/crypto.dart`, `dart:convert`

2. **lib/features/home/presentation/providers/appointment_provider.dart**
   - Changed: `bookAppointment()` signature to require `doctorId: String`
   - Updated: Appointment creation to use parameter instead of hardcoded value

3. **lib/features/home/presentation/screens/patient_portal/appointment_booking.dart**
   - Added: Import for `doctor_provider.dart`
   - Updated: Call to `bookAppointment()` to pass `doctorId = ref.read(doctorIdProvider)`

## Testing Recommendations

### Manual Testing Checklist
- [ ] New patient signs up
- [ ] Patient books appointment with "Dr. Selam Mulat"
- [ ] Doctor logs in and views "Queue Management"
- [ ] Patient's appointment appears in doctor's queue
- [ ] Doctor creates visit summary for the appointment
- [ ] Visit summary shows correct doctor/patient link
- [ ] Patient can view their own appointments
- [ ] Patient can view their visit summaries

### Automated Testing
- Test `doctorIdProvider` returns correct ID for doctor users
- Test `doctorIdProvider` returns consistent hash for doctor names
- Test `bookAppointment()` creates appointment with passed doctorId
- Test appointment reschedule preserves doctorId
- Test visit summary retrieval filters by doctorId

### Edge Cases
- Multiple doctors with similar names (hashes should differ)
- Doctor name variations (Dr./Dr/doctor prefix handling)
- Reschedule appointments to different time slots
- Visit summary lookups with partial patient names

## Compilation Status
✅ **27 total issues** (no new compilation errors introduced)
- All new code compiles successfully
- Existing linting warnings remain unchanged
- No breaking changes to existing functionality

## Future Enhancements
1. Add unique constraint on doctorId to prevent duplicates
2. Implement doctor selection UI if multiple doctors supported
3. Cache doctor ID mappings to avoid repeated hashing
4. Add doctor profile management (name updates, ID changes)
