import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_line/features/auth/presentation/providers/auth_provider.dart';
import 'package:med_line/features/home/domain/entities/appointment.dart';
import 'package:med_line/features/home/presentation/providers/appointment_provider.dart';
import 'package:med_line/features/home/presentation/providers/visit_summary_provider.dart';

class QueueManagementScreen extends ConsumerWidget {
  const QueueManagementScreen({super.key});

  void _showSkipDialog(
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
                      "Are you sure to skip this patient?",
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
                      onPressed: () {
                        ref
                            .read(appointmentProvider.notifier)
                            .updateAppointmentStatus(appointmentId, 'Skipped');
                        Navigator.pop(context);
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUser = ref.watch(authProvider).value;
    final doctorName = authUser?.name.isNotEmpty == true
        ? authUser!.name
        : authUser?.username ?? 'Doctor';
    final appointments = ref.watch(appointmentProvider);

    String normalize(String n) => n
        .replaceFirst(RegExp(r'^dr\.?\s*', caseSensitive: false), '')
        .trim()
        .toLowerCase();
    final normDoctor = normalize(doctorName);

    final queueAppointments = appointments
        .where((app) =>
            normalize(app.doctorName) == normDoctor &&
            app.status != 'Cancelled' &&
            app.status != 'Completed')
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text("Queue Management",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: queueAppointments.isEmpty
          ? Center(
              child: Text(
                'No queue appointments found for $doctorName.',
                style: const TextStyle(color: Colors.grey, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: queueAppointments.length,
              separatorBuilder: (_, __) => const SizedBox(height: 15),
              itemBuilder: (context, index) {
                final app = queueAppointments[index];
                final hasSummary = ref
                    .watch(visitSummaryProvider)
                    .any((summary) => summary.appointmentId == app.id);
                final isSkipped = app.status == 'Skipped';
                final isCompleted = app.status == 'Completed';
                final queueLabel = '#${index + 1}';

                return Opacity(
                  opacity: isSkipped ? 0.5 : 1,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.shade100),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withAlpha(13),
                            blurRadius: 5,
                            offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(app.patientName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                                const SizedBox(height: 6),
                                Text(
                                  '${app.date.toLocal().toString().split(' ').first} · ${app.timeSlot}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isCompleted
                                    ? Colors.blue.withAlpha(30)
                                    : isSkipped
                                        ? Colors.red.withAlpha(30)
                                        : Colors.green.withAlpha(30),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                isCompleted
                                    ? 'Completed'
                                    : isSkipped
                                        ? 'Skipped'
                                        : app.status,
                                style: TextStyle(
                                  color: isCompleted
                                      ? Colors.blue
                                      : isSkipped
                                          ? Colors.red
                                          : Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: isSkipped || isCompleted
                                    ? null
                                    : () => _showSkipDialog(
                                          context,
                                          ref,
                                          app.id,
                                        ),
                                icon: const Icon(Icons.skip_next, size: 18),
                                label: Text(
                                  isSkipped ? 'Skipped' : 'Skip',
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: isSkipped || hasSummary
                                    ? null
                                    : () async {
                                        final result = await context.push<bool>(
                                          '/create-summary',
                                          extra: app,
                                        );
                                        if (result == true) {
                                          // The form already updates the appointment status.
                                        }
                                      },
                                icon: const Icon(Icons.check_circle_outline,
                                    size: 18, color: Colors.black),
                                label: Text(
                                  hasSummary ? 'Completed' : 'Complete',
                                  style: const TextStyle(color: Colors.black),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: hasSummary
                                      ? Colors.grey.shade300
                                      : const Color(0xFF81C784),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ),
                          ],
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
