import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:med_line/features/auth/presentation/providers/auth_provider.dart';
import 'package:med_line/core/logging/app_logger.dart';
import 'package:med_line/features/home/domain/entities/appointment.dart';
import 'package:med_line/features/home/presentation/providers/appointment_provider.dart';

class CheckInScreen extends ConsumerWidget {
  const CheckInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointments = ref.watch(appointmentProvider);
    final currentUser = ref.watch(authProvider).value;
    final currentPatientId = currentUser?.id ?? '';
    final currentPatientName = currentUser?.name.toLowerCase() ?? '';
    // Show only pending and already checked-in appointments (exclude cancelled, skipped, and completed)
    final upcomingAppointments = appointments
        .where((app) =>
            app.status.toLowerCase() != 'cancelled' &&
            app.status.toLowerCase() != 'skipped' &&
            app.status.toLowerCase() != 'completed' &&
            (app.patientId == currentPatientId ||
                app.patientName.toLowerCase() == currentPatientName))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text("Check In",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: upcomingAppointments.isEmpty
          ? const Center(
              child: Text(
                "No upcoming appointments available to check into.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(25),
              itemCount: upcomingAppointments.length,
              itemBuilder: (context, index) {
                final app = upcomingAppointments[index];
                final isCheckedIn = app.status == Appointment.checkedIn;
                return Opacity(
                  opacity: isCheckedIn ? 0.65 : 1.0,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FB),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              app.doctorName,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: app.status == Appointment.checkedIn
                                    ? Colors.green.withAlpha(40)
                                    : Colors.green.withAlpha(25),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                app.displayStatus,
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "Date: ${DateFormat('EEEE, MMMM d, yyyy').format(app.date)}",
                          style: TextStyle(
                              color: Colors.black.withAlpha(
                                  216)), // Replaced broken black85 property
                        ),
                        Text(
                          "Time Slot: ${app.timeSlot}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        IgnorePointer(
                          ignoring: isCheckedIn,
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                final validId = int.tryParse(app.id);
                                final validIdFormat =
                                    RegExp(r'^[1-9]\d{0,9}$').hasMatch(app.id);
                                if (validId == null || !validIdFormat) {
                                  AppLogger.warn(
                                    'Invalid appointment id ${app.id} on check-in',
                                    name: 'CheckInScreen',
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Invalid appointment ID detected. Please refresh and try again."),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }


                                try {
                                  AppLogger.info(
                                    'Attempting check-in for appointment ${app.id}',
                                    name: 'CheckInScreen',
                                  );
                                  await ref
                                      .read(appointmentProvider.notifier)
                                      .updateAppointmentStatus(
                                          app.id, 'checked_in');
                                  AppLogger.info(
                                    'Check-in succeeded for appointment ${app.id}',
                                    name: 'CheckInScreen',
                                  );
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text("Successfully Checked In!"),
                                          backgroundColor: Colors.green),
                                    );
                                  }
                                } catch (e, st) {
                                  AppLogger.error(
                                    'Check-in failed for appointment ${app.id}: $e',
                                    name: 'CheckInScreen',
                                  );
                                  AppLogger.error(
                                    st.toString(),
                                    name: 'CheckInScreen',
                                  );
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(e
                                            .toString()
                                            .replaceAll('Exception: ', '')),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                disabledBackgroundColor: Colors.grey.shade300,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: isCheckedIn
                                  ? const Text("Checked In",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))
                                  : const Text("Confirm Check-In",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
