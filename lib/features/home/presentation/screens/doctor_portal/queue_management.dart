import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:med_line/core/constants/app_colors.dart';

class QueueManagementScreen extends StatelessWidget {
  const QueueManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          "Queue Management",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Next Patient Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  const Text(
                    "Next Patient",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const Text(
                    "John Doe",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text("10:00", style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 15),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.call),
                    label: const Text("Call In Patient"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent.shade400,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Queue ( 2 Patients )",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 15),
            // Example Queue Item
            _buildQueueItem("John Doe", "10:00", "#1"),
            const SizedBox(height: 10),
            _buildQueueItem("Jane Wilson", "10:30", "#2"),
          ],
        ),
      ),
    );
  }

  Widget _buildQueueItem(String name, String time, String queueNum) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(time, style: const TextStyle(color: Colors.grey)),
                ],
              ),
              Text(
                queueNum,
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text("Skip"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                  ),
                  child: const Text("Complete"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
