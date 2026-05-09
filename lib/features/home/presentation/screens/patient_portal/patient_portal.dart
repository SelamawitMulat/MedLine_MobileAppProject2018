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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome\nback,",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlack,
                        ),
                      ),
                      Text(
                        "John Doe",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlack,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: AppColors.errorRed,
                          size: 32,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.logout,
                          color: AppColors.textBlack,
                          size: 32,
                        ),
                        onPressed: () => context.go('/'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // --- NEXT APPOINTMENT CARD ---
              Container(
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
                        Icon(
                          Icons.access_time_filled,
                          color: AppColors.primaryBlue,
                          size: 30,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Next Appointment",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildInfoRow(
                      Icons.calendar_today_outlined,
                      "Wednsday, April 15, 2026",
                    ),
                    const SizedBox(height: 15),
                    _buildInfoRow(Icons.access_time, "10:00 PM"),
                    const SizedBox(height: 15),
                    _buildInfoRow(
                      Icons.groups_outlined,
                      "Queue Position : 1",
                      isBold: true,
                    ),
                    const SizedBox(height: 25),

                    // Status Banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFFD1F2B9,
                        ), // Light green from image
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          "Your turn is coming up soon!",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2E4D1A),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // --- GRID BUTTONS ---
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.3,
                  children: [
                    _buildMenuButton(
                      "Book\nAppointment",
                      Icons.calendar_month,
                      AppColors.primaryBlue,
                    ),
                    _buildMenuButton(
                      "My\nAppointments",
                      Icons.access_time,
                      AppColors.primaryBlue,
                    ),
                    _buildMenuButton(
                      "Check In",
                      Icons.groups_outlined,
                      AppColors.heartBeatGreen,
                    ),
                    _buildMenuButton(
                      "Visit\nHistory",
                      Icons.assignment_outlined,
                      AppColors.primaryBlue,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {bool isBold = false}) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textDark, size: 24),
        const SizedBox(width: 15),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuButton(String title, IconData icon, Color iconColor) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardGrey,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 15,
            right: 15,
            child: Icon(icon, color: iconColor, size: 35),
          ),
          Positioned(
            bottom: 15,
            left: 15,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
