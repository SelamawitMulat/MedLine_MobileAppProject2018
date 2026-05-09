import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DoctorPortalScreen extends StatelessWidget {
  const DoctorPortalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER SECTION ---
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
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        "Dr. Sarah Smith",
                        style: TextStyle(fontSize: 18, color: Colors.black87),
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
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.black,
                          size: 30,
                        ),
                        onPressed: () => context.go('/'), // Back to landing
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // --- STATS CARDS ---
              Row(
                children: [
                  _buildStatCard(
                    "Total\nAppointments",
                    "2",
                    Colors.blue.shade700,
                  ),
                  const SizedBox(width: 15),
                  _buildStatCard("In\nQueue", "2", Colors.greenAccent.shade700),
                ],
              ),
              const SizedBox(height: 25),

              // --- QUEUE OVERVIEW SECTION ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.groups_outlined,
                          color: Colors.blue.shade600,
                          size: 32,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Queue Overview",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A68FF),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildPatientTile("John Doe", "10:00", "#1"),
                    const SizedBox(height: 12),
                    _buildPatientTile("Jane Wilson", "10:30", "#2"),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5C6BC0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Manage Queue",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // --- BOTTOM NAVIGATION BUTTONS ---
              Row(
                children: [
                  _buildBottomAction(Icons.groups_rounded, "Queue\nManagement"),
                  const SizedBox(width: 15),
                  _buildBottomAction(
                    Icons.assignment_outlined,
                    "Visit\nSummaries",
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to build the Top Stat Cards
  Widget _buildStatCard(String title, String count, Color countColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              count,
              style: TextStyle(
                color: countColor,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build the Patient List Items
  Widget _buildPatientTile(String name, String time, String queueNum) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(time, style: const TextStyle(color: Colors.grey)),
            ],
          ),
          Text(
            queueNum,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A68FF),
            ),
          ),
        ],
      ),
    );
  }

  // Helper for Bottom Actions
  Widget _buildBottomAction(IconData icon, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: const Color(0xFFE0E0E0).withOpacity(0.5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.blue.shade900, size: 30),
            const SizedBox(height: 5),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
