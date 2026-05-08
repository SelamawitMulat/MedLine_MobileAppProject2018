

 | FULL NAME          |  ID           |
 |--------------------|---------------|
 | Betelehem Meheret  |  UGR/2245/16  |
 | Hanisa Gammada     |  UGR/0694/14  |
 | Selamawit Mulat    |  UGR/1033/16  |
 | Selam Tewodros     |  UGR /2331/16 |
 | Solomon Waganeh    |  UGR/0092/18  |


#  MedLine- Clinical Appointment and Queue Management System 

 ##  Features

 ### 1. Appointment Management (Patient)

Create: Patients can book appointments by selecting an available date and time slot. The system validates availability to prevent double booking.
Read: Patients can view all their appointments along with details such as date, status, queue position, and estimated waiting time.
Update: Patients can reschedule their appointments based on available time slots.
Delete: Patients can cancel their appointments, which automatically updates the queue.



 ### 2. Queue Management System (Doctor)

Create: Each confirmed appointment is automatically assigned a queue position based on booking order.
Read: Doctors can view the full queue list, including patient details and check-in status.
Update: Doctors can manage the queue dynamically by:

- Calling the next patient
- Skipping patients who have not checked in
- Automatically reordering queue positions
  Delete: Doctors can remove patients from the queue by marking appointments as completed or cancelled.



### 3. Patient Check-in System (Patient)

Create: Patients can check in upon arrival at the clinic.
Read: Doctors can view the check-in status of all patients in the queue.
Update: Patients can update their check-in status before being served.
Delete: Check-in status is automatically cleared after the appointment is completed or cancelled.


 ### 4. Authentication & Authorization

Authentication

- User Sign Up
- User Login
- User Logout
- Delete Account

Authorization (Role-Based Access Control)

- Patient:
  
  - Book, view, update, and cancel appointments
  - Check in upon arrival
  - View queue position and estimated waiting time

- Doctor:
  
  - View all appointments
  - Manage and control the queue
  - Monitor patient check-in status


### 5. System Intelligence & Enhancements

- Smart Waiting Time Estimation:
  Calculates estimated waiting time using queue position and average consultation time.

- Time Slot Validation:
  Prevents double booking by ensuring only available time slots can be selected.

- Turn Notification Alert:
  Notifies patients when their turn is near (e.g., when queue position ≤ 2).

- Dynamic Queue Adjustment:
  Automatically updates queue positions when appointments are added, cancelled, skipped, or completed.

- Offline-First Functionality:
  The system operates without internet by storing and managing data locally on the device.

  ### 6. Visit Summary (Doctor & Patient)

Create: Doctors record a visit summary after each completed appointment, including diagnosis, prescription, and notes.

Read: Patients can view their past visit summaries along with appointment details. Doctors can also review previous summaries.

Update: Doctors can edit visit summaries if needed.

Delete: Doctors can remove incorrect or duplicate visit summaries.


# Future Enhancements

- Admin role for system management
- Push notifications
- Multi-doctor support
- Advanced analytics dashboard
