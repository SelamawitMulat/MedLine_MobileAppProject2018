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
          padding: const EdgeInsets.all(20.0),
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
                      Text("Doctor Portal",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      Text("Dr. Sarah Smith",
                          style: TextStyle(color: Colors.black54)),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.delete_outline,
                          color: Colors.red.shade400, size: 28),
                      const SizedBox(width: 15),
                      const Icon(Icons.logout, color: Colors.black, size: 28),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 25),

              // Stats Row
              Row(
                children: [
                  _buildStatCard("Total\nAppointments", "2", Colors.blue),
                  const SizedBox(width: 15),
                  _buildStatCard("In\nQueue", "2", Colors.greenAccent),
                ],
              ),
              const SizedBox(height: 25),

              // Queue Overview Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FB),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.groups_outlined,
                            color: Colors.blue, size: 30),
                        SizedBox(width: 10),
                        Text("Queue Overview",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildQueueItem("John Doe", "10:00", "#1"),
                    const SizedBox(height: 10),
                    _buildQueueItem("Jane Wilson", "10:30", "#2"),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => context.push('/queue-management'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5C6BC0),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Manage Queue",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Bottom Navigation Cards
              Row(
                children: [
                  _buildSmallMenuCard(
                    icon: Icons.groups_outlined,
                    label: "Queue\nManagement",
                    onTap: () => context.push('/queue-management'),
                  ),
                  const SizedBox(width: 15),
                  _buildSmallMenuCard(
                    icon: Icons.description_outlined,
                    label: "Visit\nSummaries",
                    // UPDATED ROUTE TO MATCH DOCTOR HISTORY
                    onTap: () => context.push('/doctor-visit-summary'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color valueColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FB),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 12, color: Colors.black54)),
            Text(value,
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: valueColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildQueueItem(String name, String time, String rank) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(time,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          Text(rank,
              style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildSmallMenuCard(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: const Color(0xFFE0E0E0).withOpacity(0.5),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.blue.shade900),
              const SizedBox(height: 5),
              Text(label,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}