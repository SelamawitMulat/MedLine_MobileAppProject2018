import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:med_line/core/constants/app_colors.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  // In a real app, this would come from your backend/Firebase
  bool isCalledByDoctor = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          "Check In",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5), // Light grey background
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow(
                    Icons.calendar_today_outlined,
                    "Wednesday, April 15, 2026",
                  ),
                  const SizedBox(height: 20),
                  _infoRow(Icons.access_time, "10:00 PM"),
                  const SizedBox(height: 30),

                  // The "Checked In" Status Box from your image
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4E9B2), // Light green from image
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_box,
                          color: Color(0xFF2D5A27),
                          size: 35,
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Checked In",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1B3A1A),
                              ),
                            ),
                            Text(
                              "Queue Position: 1",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // CONNECTION TO DOCTOR PORTAL:
            // This section appears only when the doctor clicks "Call In"
            if (isCalledByDoctor)
              _buildCallInNotification()
            else
              const Text(
                "Please wait in the reception area.\nWe will notify you here when the doctor is ready.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.black54, size: 28),
        const SizedBox(width: 15),
        Text(
          text,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildCallInNotification() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Column(
        children: [
          Icon(Icons.campaign, color: Colors.white, size: 40),
          SizedBox(height: 10),
          Text(
            "IT'S YOUR TURN!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Please proceed to Examination Room 1",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
