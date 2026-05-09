import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:med_line/core/constants/app_colors.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _signupFormKey = GlobalKey<FormState>();
  String _selectedRole = 'Patient';

  void _handleSignup() {
    if (_signupFormKey.currentState!.validate()) {
      context.go(
        _selectedRole == 'Patient' ? '/patient-portal' : '/doctor-portal',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Form(
            key: _signupFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Create Account",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),

                _formField(
                  "Full Name",
                  "Enter your name",
                  Icons.person_outline,
                  (v) => v!.isEmpty ? "Name required" : null,
                ),
                const SizedBox(height: 20),
                _formField(
                  "Email",
                  "Enter email",
                  Icons.email_outlined,
                  (v) => v!.contains('@') ? null : "Enter a valid email",
                ),
                const SizedBox(height: 20),
                _formField(
                  "Password",
                  "Create password",
                  Icons.lock_outline,
                  (v) => v!.length < 6 ? "Minimum 6 characters" : null,
                  isPass: true,
                ),

                const SizedBox(height: 30),
                const Text(
                  "I am a:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                _roleSelector(),

                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _handleSignup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                    ),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _formField(
    String label,
    String hint,
    IconData icon,
    String? Function(String?)? validator, {
    bool isPass = false,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      TextFormField(
        obscureText: isPass,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: AppColors.cardGrey,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    ],
  );

  Widget _roleSelector() => Row(
    children: [
      Expanded(
        child: RadioListTile<String>(
          title: const Text("Patient"),
          value: 'Patient',
          groupValue: _selectedRole,
          onChanged: (v) => setState(() => _selectedRole = v!),
        ),
      ),
      Expanded(
        child: RadioListTile<String>(
          title: const Text("Doctor"),
          value: 'Doctor',
          groupValue: _selectedRole,
          onChanged: (v) => setState(() => _selectedRole = v!),
        ),
      ),
    ],
  );
}
