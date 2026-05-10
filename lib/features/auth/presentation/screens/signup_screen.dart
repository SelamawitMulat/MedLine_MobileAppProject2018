import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:med_line/core/constants/app_colors.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Form Key for validation 
  final _formKey = GlobalKey<FormState>();

  // Text Controllers to capture user input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Role Selection (Defaults to Patient)
  String _selectedRole = 'Patient';

  void _handleSignUp() {
    // 1. Check if all fields are filled based on validators
    if (_formKey.currentState!.validate()) {
      // 2. Check if Password and Confirm Password match
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Passwords do not match!"),
              backgroundColor: Colors.red),
        );
        return;
      }

      // 3. Success Logic Notification
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Account Created Successfully!"),
            backgroundColor: Colors.green),
      );

      // 4. DYNAMIC NAVIGATION
      // Redirects to specific portal based on selection
      if (_selectedRole == 'Doctor') {
        context.go('/doctor-portal');
      } else {
        context.go('/patient-portal');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar added to provide the Back Arrow
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
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),

                // Logo Section
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.show_chart,
                      color: Colors.white, size: 55),
                ),

                const SizedBox(height: 15),
                const Text(
                  "MedLine",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Clinical Appointment Management",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 35),
                // Gray Form Container
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FB),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _inputLabel("Full Name"),
                      _buildTextField(_nameController, "Enter your name"),
                      const SizedBox(height: 15),
                      _inputLabel("Email"),
                      _buildTextField(_emailController, "Enter your email",
                          isEmail: true),

                      const SizedBox(height: 15),
                      _inputLabel("Password"),
                      _buildTextField(_passwordController, "Create a password",
                          isPass: true),

                      const SizedBox(height: 15),
                      _inputLabel("Confirm Password"),
                      _buildTextField(
                          _confirmPasswordController, "Confirm your password",
                          isPass: true),

                      const SizedBox(height: 20),
                      const Text("I am a",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16)),

                      // Role Selection Radio Buttons
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Patient',
                            groupValue: _selectedRole,
                            activeColor: Colors.black,
                            onChanged: (val) =>
                                setState(() => _selectedRole = val!),
                          ),
                          const Text("Patient", style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Doctor',
                            groupValue: _selectedRole,
                            activeColor: Colors.black,
                            onChanged: (val) =>
                                setState(() => _selectedRole = val!),
                          ),
                          const Text("Doctor", style: TextStyle(fontSize: 16)),
                        ],
                      ),

                      const SizedBox(height: 25),

                      // Sign Up Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleSignUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _inputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {bool isPass = false, bool isEmail = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPass,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFE5E7EB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Please fill out this field";
        }
        if (isEmail && !value.contains('@')) {
          return "Please enter a valid email address";
        }
        if (isPass && value.length < 6) {
          return "Password must be at least 6 characters";
        }
        return null;
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}