import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:med_line/core/constants/app_colors.dart';

class PatientPortalScreen extends StatelessWidget {
  const PatientPortalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER WITH DELETE & LOGOUT ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome\nback,",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "John Doe",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 35,
                        ),
                        onPressed: () {
                          // Requirement: Delete Account
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.black,
                          size: 35,
                        ),
                        onPressed: () =>
                            context.go('/login'), // Requirement: User Logout
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // --- NEXT APPOINTMENT CARD ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(
                    0xFFF8F8F8,
                  ), // Light grey background from image
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.indigo, size: 28),
                        SizedBox(width: 10),
                        Text(
                          "Next Appointment",
                          style: TextStyle(
                            color: Colors.indigo,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    _buildAppointmentDetail(
                      Icons.calendar_today_outlined,
                      "Wednesday, April 15, 2026",
                    ),
                    const SizedBox(height: 10),
                    _buildAppointmentDetail(Icons.access_time, "10:00 PM"),
                    const SizedBox(height: 10),
                    _buildAppointmentDetail(
                      Icons.group_outlined,
                      "Queue Position : 1",
                    ),
                    const SizedBox(height: 20),

                    // Requirement: Turn Notification Alert (Position <= 2)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4F1B4), // Soft green from image
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: const Center(
                        child: Text(
                          "Your turn is coming up soon!",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 35),

              // --- ACTION GRID ---
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 1.3, // Matches the rectangular shape in image
                children: [
                  _actionCard(
                    "Book\nAppointment",
                    Icons.calendar_month,
                    Colors.indigo,
                    () => context.push('/patient-portal/appointment-booking'),
                  ),
                  _actionCard(
                    "My\nAppointments",
                    Icons.access_time,
                    Colors.indigo,
                    () => context.push('/patient-portal/my-appointments'),
                  ),
                  _actionCard(
                    "Check In",
                    Icons.group_outlined,
                    Colors.green,
                    () => context.push('/patient-portal/check-in'),
                  ),
                  _actionCard(
                    "Visit\nHistory",
                    Icons.description_outlined,
                    Colors.indigo,
                    () => context.push('/patient-portal/visit-summary'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentDetail(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.black54, size: 22),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _actionCard(
    String title,
    IconData icon,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFEEEEEE), // Muted grey button background
          borderRadius: BorderRadius.circular(18),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  height: 1.2,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Icon(icon, color: iconColor, size: 35),
            ),
          ],
        ),
      ),
    );
  }
}
