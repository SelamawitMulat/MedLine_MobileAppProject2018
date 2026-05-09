import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:med_line/core/constants/app_colors.dart';
import 'package:med_line/core/widgets/primary_button.dart';

class DoctorPortalScreen extends StatelessWidget {
  const DoctorPortalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER SECTION ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Doctor Portal",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Dr. Sarah Smith",
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.textGrey,
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
                          size: 30,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout, size: 30),
                        onPressed: () => context.go('/'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // --- STATS CARDS ---
              Row(
                children: [
                  _buildStatCard("Total\nAppointments", "2"),
                  const SizedBox(width: 15),
                  _buildStatCard(
                    "In\nQueue",
                    "2",
                    countColor: Colors.greenAccent,
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // --- QUEUE OVERVIEW CARD ---
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
                    _buildPatientTile("John Doe", "10:00", "#1"),
                    const SizedBox(height: 10),
                    _buildPatientTile("Jane Wilson", "10:30", "#2"),
                    const SizedBox(height: 20),
                    // Navigation trigger for the Manage Queue screen
                    PrimaryButton(
                      text: "Manage Queue",
                      onPressed: () => context.push('/queue-management'),
                    ),
                  ],
                ),
              ),

              // Reduced vertical space here
              const SizedBox(height: 15),

              // --- BOTTOM DASHBOARD BUTTONS ---
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
                      onTap: () {
                        // Navigate to summaries when ready
                      },
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

  // Helper for Statistics (Appointments/Queue)
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

  // Helper for Patient Tiles in Overview
  Widget _buildPatientTile(String name, String time, String queueNum) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(
                time,
                style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
              ),
            ],
          ),
          Text(
            queueNum,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  // Helper for Bottom Action Cards
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
