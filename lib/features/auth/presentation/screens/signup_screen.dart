import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:med_line/core/constants/app_colors.dart';
import 'package:med_line/core/widgets/primary_button.dart';
import 'package:med_line/features/auth/presentation/widgets/auth_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // 1. Create a GlobalKey for the form
  final _formKey = GlobalKey<FormState>();

  // 2. Track the selected role
  String _selectedRole = "Patient";

  void _handleSignup() {
    // 3. Trigger validators
    if (_formKey.currentState!.validate()) {
      // 4. Logic based on selection
      if (_selectedRole == "Doctor") {
        context.go('/doctor-portal'); // Ensure this path exists in your router
      } else {
        context.go('/patient-portal'); // Ensure this path exists in your router
      }
    }
  }

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
            child: Form(
              // 5. Wrap everything in a Form
              key: _formKey,
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
                          ),
                        ),
                      ],
                    ),
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
                          // Note: Ensure your AuthTextField has a 'validator' property
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
                          ),
                        ),
                        const SizedBox(height: 8),

                        // --- DYNAMIC RADIO BUTTONS ---
                        Row(
                          children: [
                            Radio<String>(
                              value: "Patient",
                              groupValue: _selectedRole,
                              activeColor: AppColors.primaryBlue,
                              onChanged: (value) {
                                setState(() => _selectedRole = value!);
                              },
                            ),
                            const Text("Patient"),
                            const SizedBox(width: 20),
                            Radio<String>(
                              value: "Doctor",
                              groupValue: _selectedRole,
                              activeColor: AppColors.primaryBlue,
                              onChanged: (value) {
                                setState(() => _selectedRole = value!);
                              },
                            ),
                            const Text("Doctor"),
                          ],
                        ),

                        const SizedBox(height: 30),
                        PrimaryButton(
                          text: "Sign Up",
                          onPressed: _handleSignup,
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
      ),
    );
  }
}
