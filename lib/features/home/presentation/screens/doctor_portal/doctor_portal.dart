import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_line/core/constants/app_colors.dart';
import 'package:med_line/core/widgets/primary_button.dart';
import 'package:med_line/features/auth/presentation/providers/auth_provider.dart';
import 'package:med_line/features/home/domain/entities/appointment.dart';
import 'package:med_line/features/home/presentation/providers/appointment_provider.dart';

class DoctorPortalScreen extends ConsumerWidget {
  const DoctorPortalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final appointments = ref.watch(appointmentProvider);
    final user = authState.value;
    final doctorName =
        user?.name.isNotEmpty == true ? user!.name : user?.username ?? 'Doctor';
    final displayName = doctorName.toLowerCase().startsWith('dr.')
        ? doctorName
        : 'Dr. $doctorName';
    String normalize(String n) => n
        .replaceFirst(RegExp(r'^dr\.?\s*', caseSensitive: false), '')
        .trim()
        .toLowerCase();
    final normDoctor = normalize(doctorName);

    final doctorAppointments = appointments
        .where((app) =>
            normalize(app.doctorName) == normDoctor &&
            app.status != 'cancelled')
        .toList();

    // Queue Overview: Show 3 nearest appointments from ALL patients
    final allQueueAppointments = appointments
        .where((app) => app.status != 'cancelled')
        .toList()
      ..sort((a, b) {
        // sort by combined date+time
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
    final queueOverview = allQueueAppointments.take(3).toList();

    // Queue stats: For this doctor's appointments
    final queueAppointments = doctorAppointments
        .where((app) => app.status == 'pending' || app.status == 'checked_in')
        .toList();

    final totalAppointments = doctorAppointments.length;
    final inQueue = queueAppointments.length;

    void showLogoutDialog() {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Are you sure?",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context)),
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
                          Navigator.pop(context);
                          ref.read(authProvider.notifier).logout();
                          context.go('/login');
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

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Doctor Portal",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        displayName,
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, size: 30),
                    onPressed: showLogoutDialog,
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  _buildStatCard(
                      "Total\nAppointments", totalAppointments.toString()),
                  const SizedBox(width: 15),
                  _buildStatCard(
                    "In\nQueue",
                    inQueue.toString(),
                    countColor: Colors.greenAccent,
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardGrey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.groups_outlined,
                          color: AppColors.primaryBlue,
                          size: 30,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Queue Overview",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (queueOverview.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: const Text(
                          'No queue appointments available.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    else
                      for (var i = 0; i < queueOverview.length; i++) ...[
                        _buildQueueAppointmentCard(
                          queueOverview[i],
                          '#${i + 1}',
                        ),
                        if (i < queueOverview.length - 1)
                          const SizedBox(height: 10),
                      ],
                    const SizedBox(height: 20),
                    PrimaryButton(
                      text: "Manage Queue",
                      onPressed: () => context.push('/queue-management'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      context,
                      icon: Icons.group_outlined,
                      label: "Queue\nManagement",
                      onTap: () => context.push('/queue-management'),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildActionCard(
                      context,
                      icon: Icons.description_outlined,
                      label: "Visit\nSummaries",
                      onTap: () => context.push('/doctor-visit-summary'),
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

  Widget _buildStatCard(String title, String count, {Color? countColor}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.cardGrey,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(color: AppColors.textGrey, height: 1.2),
            ),
            Text(
              count,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: countColor ?? AppColors.primaryBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQueueAppointmentCard(Appointment appointment, String queueNum) {
    final isSkipped = appointment.status.toLowerCase() == 'skipped';

    return Opacity(
      opacity: isSkipped ? 0.6 : 1.0,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.patientName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${appointment.date.toLocal().toString().split(' ').first} · ${appointment.timeSlot}',
                        style: const TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: isSkipped
                            ? Colors.grey.withAlpha(30)
                            : Colors.green.withAlpha(30),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        appointment.displayStatus,
                        style: TextStyle(
                          color: isSkipped ? Colors.grey : Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          queueNum,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.cardGrey,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primaryBlue, size: 35),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, height: 1.1),
            ),
          ],
        ),
      ),
    );
  }
}
