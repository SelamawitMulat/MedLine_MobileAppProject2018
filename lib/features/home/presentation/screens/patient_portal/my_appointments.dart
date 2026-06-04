import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:med_line/features/auth/presentation/providers/auth_provider.dart';
import 'package:med_line/core/logging/app_logger.dart';

// FIXED: Converted relative backsteps to absolute package paths
import 'package:med_line/features/home/presentation/providers/appointment_provider.dart';
import 'package:med_line/features/home/domain/entities/appointment.dart';

class MyAppointmentsScreen extends ConsumerWidget {
  const MyAppointmentsScreen({super.key});

  void _showCancelDialog(
      BuildContext context, WidgetRef ref, String appointmentId) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      "Are you sure to cancel this appointment?",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF0F0F0),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.grey.shade300)),
                      ),
                      child: const Text("NO",
                          style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          AppLogger.info(
                            'Attempting to cancel appointment $appointmentId',
                            name: 'MyAppointmentsScreen',
                          );
                          await ref
                              .read(appointmentProvider.notifier)
                              .cancelAppointment(appointmentId);
                          AppLogger.info(
                            'Cancelled appointment $appointmentId',
                            name: 'MyAppointmentsScreen',
                          );
                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text("Appointment cancelled successfully"),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        } catch (e, st) {
                          AppLogger.error(
                            'Failed to cancel appointment $appointmentId: $e',
                            name: 'MyAppointmentsScreen',
                          );
                          AppLogger.error(st.toString(),
                              name: 'MyAppointmentsScreen');
                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    e.toString().replaceAll('Exception: ', '')),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Colors.red)),
                      ),
                      child: const Text("Yes",
                          style: TextStyle(color: Colors.red)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showRescheduleModal(
      BuildContext context, WidgetRef ref, Appointment appointment) async {
    DateTime focusedDay = appointment.date;
    DateTime selectedDay = appointment.date;
    String selectedTime = appointment.timeSlot;

    final timeSlots = [
      "09:00",
      "09:30",
      "10:00",
      "10:30",
      "11:00",
      "11:30",
      "14:00",
      "14:30",
      "15:00",
      "15:30",
      "16:00",
      "16:30",
    ];

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Reschedule Appointment',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: focusedDay,
              selectedDayPredicate: (day) => isSameDay(day, selectedDay),
              onDaySelected: (day, focus) {
                selectedDay = day;
                focusedDay = focus;
              },
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: timeSlots.map((timeSlot) {
                final isSelected = timeSlot == selectedTime;
                return ChoiceChip(
                  label: Text(timeSlot),
                  selected: isSelected,
                  onSelected: (_) {
                    selectedTime = timeSlot;
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () async {
                if (selectedDay.isBefore(DateTime.now()) ||
                    (selectedDay.isAtSameMomentAs(DateTime.now()) &&
                        selectedTime == appointment.timeSlot &&
                        selectedDay.isBefore(DateTime.now()))) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Cannot reschedule into the past or same slot.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                try {
                  await ref
                      .read(appointmentProvider.notifier)
                      .rescheduleAppointment(
                        appointment.id,
                        selectedDay,
                        selectedTime,
                      );
                  if (!context.mounted) {
                    return;
                  }
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Appointment rescheduled.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString().replaceAll('Exception: ', '')),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Confirm Reschedule'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointments = ref.watch(appointmentProvider);
    final currentUser = ref.watch(authProvider).value;
    final currentPatientId = currentUser?.id ?? '';
    final currentPatientName = currentUser?.name.toLowerCase() ?? '';

    // Filter appointments for current user that are not cancelled
    final userAppointments = appointments
        .where((app) =>
            app.status.toLowerCase() != 'cancelled' &&
            (app.patientId == currentPatientId ||
                app.patientName.toLowerCase() == currentPatientName))
        .toList();

    // Sort by upcoming first, by combined date+time ascending.
    DateTime combine(Appointment ap) {
      try {
        final parts = ap.timeSlot.split(':').map(int.parse).toList();
        return DateTime(
            ap.date.year, ap.date.month, ap.date.day, parts[0], parts[1]);
      } catch (_) {
        return ap.date;
      }
    }

    userAppointments.sort((a, b) => combine(a).compareTo(combine(b)));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => context.pop()),
          title: const Text("My Appointments",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
      body: userAppointments.isEmpty
          ? const Center(
              child: Text(
                "No active appointments found.\nGo back to book a new one!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16, height: 1.4),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(25),
              itemCount: userAppointments.length,
              itemBuilder: (context, index) {
                final app = userAppointments[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _buildAppointmentItem(context, ref, app, index + 1),
                );
              },
            ),
    );
  }

  Widget _buildAppointmentItem(
      BuildContext context, WidgetRef ref, Appointment app, int queueNumber) {
    final isSkipped = app.status.toLowerCase() == 'skipped';

    final isCompleted = app.status.toLowerCase() == 'completed';

    return Opacity(
      opacity: (isSkipped || isCompleted) ? 0.6 : 1.0,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: const Color(0xFFF8F9FB),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade100)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Show checked-in badge when applicable
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSkipped
                        ? Colors.grey.withAlpha(25)
                        : app.isCheckedIn
                            ? Colors.green.withAlpha(25)
                            : Colors.blue.withAlpha(25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    app.displayStatus,
                    style: TextStyle(
                        color: isSkipped
                            ? Colors.grey
                            : app.displayStatus == 'Checked In'
                                ? Colors.green
                                : Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.people_outline,
                        color: Colors.grey, size: 20),
                    const SizedBox(width: 5),
                    Text(
                      "Queue: $queueNumber",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.black, size: 20),
                const SizedBox(width: 10),
                Text(
                  DateFormat('EEEE, MMMM d, yyyy').format(app.date),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.black, size: 20),
                const SizedBox(width: 10),
                Text(app.timeSlot),
              ],
            ),
            if (app.reason.isNotEmpty) ...[
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.description_outlined,
                      color: Colors.black, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      app.reason,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: (app.isCheckedIn || isSkipped || isCompleted)
                        ? null
                        : () => _showRescheduleModal(context, ref, app),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Reschedule",
                        style: TextStyle(color: Colors.black)),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: (app.isCheckedIn || isSkipped || isCompleted)
                        ? null
                        : () => _showCancelDialog(context, ref, app.id),
                    icon: const Icon(Icons.cancel_outlined,
                        color: Colors.red, size: 20),
                    label: const Text("Cancel",
                        style: TextStyle(color: Colors.red)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
