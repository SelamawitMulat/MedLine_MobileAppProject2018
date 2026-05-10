import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:med_line/core/constants/app_colors.dart';

class PatientPortalScreen extends StatelessWidget {
  const PatientPortalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Welcome\nback,",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("John Doe",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: AppColors.errorRed, size: 32),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout,
                            color: AppColors.textBlack, size: 32),
                        onPressed: () => context.go('/login'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 25),

              _buildAppointmentCard(),
              const SizedBox(height: 35),

              // Navigation Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 1.4,
                children: [
                  // --- FIXED: Added navigation logic here ---
                  _actionTile(
                    "Book\nAppointment",
                    Icons.calendar_today,
                    AppColors.primaryBlue,
                    () => context.push('/book-appointment'),
                  ),

                  _actionTile(
                    "My\nAppointments",
                    Icons.access_time,
                    AppColors.secondaryPurple,
                    () => context.push('/my-appointments'),
                  ),

                  _actionTile("Check In", Icons.people_outline,
                      AppColors.successGreen, () => context.push('/check-in')),

                  _actionTile(
                      "Visit\nHistory",
                      Icons.description_outlined,
                      AppColors.accentBlue,
                      () => context.push('/visit-summary')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardGrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.access_time_filled,
                  color: AppColors.secondaryPurple, size: 28),
              SizedBox(width: 10),
              Text("Next Appointment",
                  style: TextStyle(
                      color: AppColors.secondaryPurple,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 15),
          _detailRow(Icons.calendar_today, "Wednesday, April 15, 2026"),
          _detailRow(Icons.access_time, "10:00 PM"),
          _detailRow(Icons.people_outline, "Queue Position : 1"),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textGrey, size: 20),
            const SizedBox(width: 10),
            Text(text,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          ],
        ),
      );

  Widget _actionTile(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.borderGrey.withOpacity(0.4),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            Align(
                alignment: Alignment.bottomLeft,
                child: Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14))),
            Align(
                alignment: Alignment.topRight,
                child: Icon(icon, color: color, size: 30)),
          ],
        ),
      ),
    );
  }
}