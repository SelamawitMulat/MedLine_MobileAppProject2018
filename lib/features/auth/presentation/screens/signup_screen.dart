import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// Standardizing to package imports to fix "yellow light" warnings
import 'package:med_line/core/constants/app_colors.dart';
import 'package:med_line/core/widgets/primary_button.dart';
import 'package:med_line/features/auth/presentation/widgets/auth_text_field.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // GoRouter back button logic
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
                // --- LOGO SECTION ---
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.stacked_line_chart,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "MedLine",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Clinical Appointment Management",
                  style: TextStyle(color: AppColors.textGrey, fontSize: 14),
                ),
                const SizedBox(height: 40),

                // --- SIGNUP FORM BOX ---
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

                      const Text(
                        "I am a",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Radio Selection (Visual Only)
                      Column(
                        children: [
                          Row(
                            children: [
                              Radio<String>(
                                value: "Patient",
                                groupValue: "Patient", // Hardcoded selection
                                activeColor: Colors.black,
                                onChanged: (val) {},
                              ),
                              const Text(
                                "Patient",
                                style: TextStyle(color: Colors.black),
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
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),
                      PrimaryButton(
                        text: "Sign Up",
                        onPressed: () {
                          // TODO: Implement Auth Logic
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
