import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:med_line/core/constants/app_colors.dart';

class QueueManagementScreen extends StatefulWidget {
  const QueueManagementScreen({super.key});

  @override
  State<QueueManagementScreen> createState() => _QueueManagementScreenState();
}

class _QueueManagementScreenState extends State<QueueManagementScreen> {
  bool _isPatientInRoom = false;
  final String _currentPatient = "John Doe";

  // Using the ultra-soft coloring 
  final Color _ultraSoftGreenBg = Colors.green.withOpacity(0.12);
  final Color _deepGreenText = Colors.green.shade800;

  void _handleCallIn() {
    setState(() {
      _isPatientInRoom = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Notification sent to $_currentPatient.",
          style: TextStyle(color: _deepGreenText),
        ),
        backgroundColor: _ultraSoftGreenBg,
        duration: const Duration(seconds: 2),
      ),
    );
  }

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
            // --- NEXT PATIENT SECTION ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: Column(
                children: [
                  Text(
                    _isPatientInRoom ? "Currently Serving" : "Next Patient",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _currentPatient,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text("10:00", style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: _isPatientInRoom ? null : _handleCallIn,
                      icon: Icon(
                        Icons.call,
                        color: _isPatientInRoom ? Colors.grey : _deepGreenText,
                      ),
                      label: Text(
                        _isPatientInRoom
                            ? "In Consultation"
                            : "Call In Patient",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _isPatientInRoom
                              ? Colors.grey
                              : _deepGreenText,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isPatientInRoom
                            ? Colors.grey.shade100
                            : _ultraSoftGreenBg,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
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

            _buildQueueItem("John Doe", "10:00", "#1", true),
            const SizedBox(height: 12),
            _buildQueueItem("Jane Wilson", "10:30", "#2", false),
          ],
        ),
      ),
    );
  }

  Widget _buildQueueItem(
    String name,
    String time,
    String queueNum,
    bool isCheckedIn,
  ) {
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      Text(time, style: const TextStyle(color: Colors.grey)),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.circle,
                        size: 8,
                        color: isCheckedIn
                            ? _deepGreenText.withOpacity(0.5)
                            : Colors.orange.withOpacity(0.5),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isCheckedIn ? "Checked In" : "Waiting",
                        style: TextStyle(
                          color: isCheckedIn
                              ? _deepGreenText
                              : Colors.orange.shade800,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                queueNum,
                style: const TextStyle(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              // --- SKIP BUTTON WITH ICON ---
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.skip_next_outlined, size: 20),
                  label: const Text("Skip"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey,
                    side: BorderSide(color: Colors.grey.shade200),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // --- COMPLETE BUTTON WITH ICON ---
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => context.push('/create-summary'),
                  icon: const Icon(Icons.check_circle_outline, size: 20),
                  label: const Text(
                    "Complete",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _ultraSoftGreenBg,
                    foregroundColor: _deepGreenText,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
