import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
                        // Map skip to 'skipped' status to keep appointment visible
                        ref
                            .read(appointmentProvider.notifier)
                            .updateAppointmentStatus(appointmentId, 'skipped');
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
    final appointments = ref.watch(appointmentProvider);

    // Show ALL appointments (not filtered by doctor) excluding cancelled
    final queueAppointments = appointments
        .where((app) => app.status.toLowerCase() != 'cancelled')
        .toList()
      ..sort((a, b) {
        // Sort by date + time
        DateTime combine(Appointment ap) {
          try {
            final parts = ap.timeSlot.split(':').map(int.parse).toList();
            return DateTime(
                ap.date.year, ap.date.month, ap.date.day, parts[0], parts[1]);
          } catch (_) {
            return ap.date;
          }
        }

        return combine(a).compareTo(combine(b));
      });

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
          ? const Center(
              child: Text(
                'No queue appointments available.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
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
                final isSkipped = app.status.toLowerCase() == 'skipped';
                final isCompleted =
                    app.status.toLowerCase() == 'completed' || hasSummary;
                final isMissed = app.isMissed;

                return Opacity(
                  opacity: isSkipped || isMissed || isCompleted ? 0.6 : 1.0,
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
                                color: isSkipped
                                    ? Colors.grey.withAlpha(30)
                                    : Colors.green.withAlpha(30),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                app.displayStatus,
                                style: TextStyle(
                                  color: isSkipped ? Colors.grey : Colors.green,
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
                                onPressed: (isSkipped || isCompleted)
                                    ? null
                                    : () => _showSkipDialog(
                                          context,
                                          ref,
                                          app.id,
                                        ),
                                icon: const Icon(Icons.skip_next, size: 18),
                                label: const Text('Skip'),
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
                                onPressed: (isSkipped || isCompleted)
                                    ? null
                                    : () async {
                                        final result = await context.push<bool>(
                                          '/create-summary',
                                          extra: app,
                                        );
                                        if (result == true) {
                                          // Placeholder: user navigated to create visit summary.
                                        }
                                      },
                                icon: const Icon(Icons.check_circle_outline,
                                    size: 18, color: Colors.black),
                                label: Text(
                                  isCompleted ? 'Completed' : 'Complete',
                                  style: const TextStyle(color: Colors.black),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: (isSkipped || isCompleted)
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
