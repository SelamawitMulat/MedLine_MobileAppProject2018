import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:med_line/core/constants/app_colors.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  // UI State Toggle: false = Green/Waiting, true = Blue/Called In
  bool isCalledIn = false;

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
                color: const Color(0xFFF5F5F5),
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

                  // Status Box - Transitions color and content based on state
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: isCalledIn
                          ? AppColors.primaryBlue
                          : const Color(0xFFD4E9B2),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isCalledIn ? Icons.campaign : Icons.check_box,
                          color: isCalledIn
                              ? Colors.white
                              : const Color(0xFF2D5A27),
                          size: 35,
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isCalledIn ? "It's Your Turn!" : "Checked In",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isCalledIn
                                    ? Colors.white
                                    : const Color(0xFF1B3A1A),
                              ),
                            ),
                            Text(
                              isCalledIn
                                  ? "Proceed to Room 1"
                                  : "Queue Position: 1",
                              style: TextStyle(
                                fontSize: 16,
                                color: isCalledIn
                                    ? Colors.white70
                                    : Colors.grey.shade800,
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
            Text(
              isCalledIn
                  ? "The doctor is waiting for you."
                  : "Please wait in the reception area.\nWe will notify you here when the doctor is ready.",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const Spacer(),
            // UI Test Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => setState(() => isCalledIn = !isCalledIn),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  isCalledIn ? "RESET TO WAITING" : "SIMULATE DOCTOR CALL",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
}
