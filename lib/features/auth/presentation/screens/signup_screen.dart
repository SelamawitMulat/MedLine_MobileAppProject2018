import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/medline_logo.dart';
import '../../../../core/widgets/primary_button.dart';
import '../widgets/auth_text_field.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const Center(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.stacked_line_chart,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "MedLine",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Clinical Appointment Management",
                  style: TextStyle(color: AppColors.textGrey, fontSize: 14),
                ),
                const SizedBox(height: 40),

                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.scaffoldBg.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AuthTextField(
                        label: "Full Name",
                        hint: "Enter your name",
                      ),
                      const AuthTextField(
                        label: "Email",
                        hint: "Enter your email",
                      ),
                      const AuthTextField(
                        label: "Password",
                        hint: "Create a password",
                        isPassword: true,
                      ),

                      const Text("I am a", style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),

                      // Radio Selection - Matches Screenshot 2026-05-09 12.29.14 AM.png
                      Theme(
                        data: ThemeData(unselectedWidgetColor: Colors.black),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Radio<String>(
                                  value: "Patient",
                                  groupValue: "Patient", // Selected by default
                                  activeColor: Colors.black,
                                  onChanged: (val) {},
                                ),
                                const Text(
                                  "Patient",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Radio<String>(
                                  value: "Doctor",
                                  groupValue: "Patient", // Unselected
                                  activeColor: Colors.black,
                                  onChanged: (val) {},
                                ),
                                const Text(
                                  "Doctor",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),
                      PrimaryButton(
                        text: "Sign Up",
                        onPressed: () {
                          // Perform logic
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
