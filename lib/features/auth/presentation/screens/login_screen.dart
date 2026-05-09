import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:med_line/core/constants/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  String _selectedRole = 'Patient';

  void _handleLogin() {
    // Only navigates if the form passes all validation checks
    if (_loginFormKey.currentState!.validate()) {
      if (_selectedRole == 'Patient') {
        context.go('/patient-portal');
      } else {
        context.go('/doctor-portal');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                const Text(
                  "Login",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),

                _buildLabel("Email"),
                TextFormField(
                  decoration: _inputDecoration(
                    "Enter your email",
                    Icons.email_outlined,
                  ),
                  validator: (value) => (value == null || value.isEmpty)
                      ? "Email is required"
                      : null,
                ),

                const SizedBox(height: 20),
                _buildLabel("Password"),
                TextFormField(
                  obscureText: true,
                  decoration: _inputDecoration(
                    "Enter your password",
                    Icons.lock_outline,
                  ),
                  validator: (value) => (value == null || value.length < 6)
                      ? "Password must be 6+ characters"
                      : null,
                ),

                const SizedBox(height: 30),
                const Text(
                  "Select Role",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                _roleSelector(),

                const SizedBox(height: 50),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Login",
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
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) =>
      InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: AppColors.cardGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        errorStyle: const TextStyle(color: AppColors.errorRed),
      );

  Widget _buildLabel(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
  );

  Widget _roleSelector() => Container(
    decoration: BoxDecoration(
      color: AppColors.cardGrey,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
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
    ),
  );
}
