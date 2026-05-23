import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:med_line/features/auth/presentation/providers/auth_provider.dart';
import '../../providers/appointment_provider.dart';

class PatientPortalScreen extends ConsumerWidget {
  const PatientPortalScreen({super.key});

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
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
                  const Text("Are you sure?",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final appointments = ref.watch(appointmentProvider);

    if (authState.hasValue && authState.value == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final user = authState.value;
    final displayName =
        user?.name.isNotEmpty == true ? user!.name : (user?.username ?? "User");
    final currentPatientId = user?.id ?? '';
    final currentPatientName = user?.name.toLowerCase() ?? '';

    final upcomingAppointments = appointments
        .where((app) =>
            app.status == "Upcoming" &&
            (app.patientId == currentPatientId ||
                app.patientName.toLowerCase() == currentPatientName))
        .toList();

    upcomingAppointments.sort((a, b) => a.date.compareTo(b.date));

    final hasAppointment = upcomingAppointments.isNotEmpty;

    // 3. FIX: Select .first (the nearest appointment) instead of .last
    final nextApp = hasAppointment ? upcomingAppointments.first : null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Welcome back,",
                          style: TextStyle(fontSize: 18, color: Colors.grey)),
                      Text("Hi, $displayName",
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  IconButton(
                      icon: const Icon(Icons.logout,
                          color: Colors.black, size: 28),
                      onPressed: () => _showLogoutDialog(context, ref)),
                ],
              ),
              const SizedBox(height: 25),

              // --- DYNAMIC NEXT APPOINTMENT BANNER ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FB),
                    borderRadius: BorderRadius.circular(20)),
                child: !hasAppointment
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text(
                            "No upcoming appointments found.\nTap below to schedule your first visit!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.grey,
                                height: 1.4,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.access_time_filled,
                                  color: Colors.purple, size: 24),
                              SizedBox(width: 10),
                              Text("Next Appointment",
                                  style: TextStyle(
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Text(
                            DateFormat('EEEE, MMMM d, yyyy')
                                .format(nextApp!.date),
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          Text(
                            nextApp.timeSlot,
                            style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.person_outline,
                                  color: Colors.grey, size: 20),
                              const SizedBox(width: 5),
                              Text(
                                "Doctor: ${nextApp.doctorName}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF475569)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: const Color(0xFFDCEDC8),
                                borderRadius: BorderRadius.circular(10)),
                            child: const Center(
                              child: Text(
                                "Your turn is coming up soon!",
                                style: TextStyle(
                                    color: Color(0xFF33691E),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 30),

              // ACTION TILES GRID
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 1.0,
                children: [
                  _actionTile(context, "Book\nAppointment",
                      Icons.calendar_today, Colors.blue, '/book-appointment'),
                  _actionTile(context, "My\nAppointments", Icons.access_time,
                      Colors.purple, '/my-appointments'),
                  _actionTile(context, "Check In", Icons.people_outline,
                      Colors.green, '/check-in'),
                  _actionTile(
                      context,
                      "Visit\nHistory",
                      Icons.description_outlined,
                      Colors.blueAccent,
                      '/visit-summary'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionTile(BuildContext context, String title, IconData icon,
      Color color, String route) {
    return InkWell(
      onTap: () => context.push(route),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: const Color(0xFFF8F9FB),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
