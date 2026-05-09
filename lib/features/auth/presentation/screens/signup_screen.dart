import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:med_line/core/constants/app_colors.dart';
import 'package:med_line/core/widgets/primary_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Key to manage the form state and trigger validation
  final _formKey = GlobalKey<FormState>();

  // Controllers to capture user input
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _selectedRole = "Patient";
  bool _isPasswordVisible = false;
  bool _isConfirmVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignup() {
    // currentState!.validate() calls every 'validator' function in the TextFormFields
    if (_formKey.currentState!.validate()) {
      if (_selectedRole == "Doctor") {
        context.go('/doctor-portal');
      } else {
        context.go('/patient-portal');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textBlack),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // --- LOGO & TITLE ---
                const Icon(
                  Icons.stacked_line_chart,
                  color: AppColors.primaryBlue,
                  size: 60,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
                const SizedBox(height: 30),

                // --- FULL NAME ---
                _buildFieldLabel("Full Name"),
                TextFormField(
                  controller: _nameController,
                  decoration: _inputDecoration("John Doe"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Name is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // --- EMAIL ---
                _buildFieldLabel("Email Address"),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration("example@mail.com"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Email is required";
                    }
                    if (!value.contains('@')) {
                      return "Enter a valid email with @";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // --- PASSWORD ---
                _buildFieldLabel("Password"),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: _inputDecoration("Min. 6 characters").copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () => setState(
                        () => _isPasswordVisible = !_isPasswordVisible,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }
                    if (value.length < 6) {
                      return "Must be at least 6 characters";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // --- CONFIRM PASSWORD ---
                _buildFieldLabel("Confirm Password"),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmVisible,
                  decoration: _inputDecoration("Repeat password").copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () => setState(
                        () => _isConfirmVisible = !_isConfirmVisible,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Confirmation is required";
                    }
                    if (value != _passwordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),

                // --- ROLE SELECTION ---
                Align(
                  alignment: Alignment.centerLeft,
                  child: _buildFieldLabel("I am a:"),
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: "Patient",
                      groupValue: _selectedRole,
                      activeColor: AppColors.primaryBlue,
                      onChanged: (val) {
                        setState(() {
                          _selectedRole = val!;
                        });
                      },
                    ),
                    const Text("Patient"),
                    const SizedBox(width: 20),
                    Radio<String>(
                      value: "Doctor",
                      groupValue: _selectedRole,
                      activeColor: AppColors.primaryBlue,
                      onChanged: (val) {
                        setState(() {
                          _selectedRole = val!;
                        });
                      },
                    ),
                    const Text("Doctor"),
                  ],
                ),
                const SizedBox(height: 35),

                // --- SIGNUP BUTTON ---
                PrimaryButton(text: "Sign Up", onPressed: _handleSignup),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- UI HELPERS ---
  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppColors.cardGrey,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      errorStyle: const TextStyle(color: AppColors.errorRed),
    );
  }
}
