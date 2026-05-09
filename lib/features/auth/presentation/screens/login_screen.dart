import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:med_line/core/constants/app_colors.dart';
import 'package:med_line/core/widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedRole = "Patient";
  bool _isPasswordVisible = false;

  void _handleLogin() {
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Icon(
                  Icons.stacked_line_chart,
                  color: AppColors.primaryBlue,
                  size: 80,
                ),
                const Text(
                  "MedLine",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Clinical Appointment Management",
                  style: TextStyle(color: AppColors.textGrey),
                ),
                const SizedBox(height: 40),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.cardGrey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Email",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          hintText: "Enter your email",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Enter your email';
                          }

                          if (!v.contains('@')) {
                            return 'Enter a valid email';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Password",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: "Enter your password",
                          filled: true,
                          fillColor: Colors.white,
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Enter your password';
                          }

                          if (v.length < 6) {
                            return 'Password must be at least 6 characters';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Login as:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      Row(
                        children: [
                          Radio<String>(
                            value: "Patient",
                            groupValue: _selectedRole,
                            onChanged: (v) {
                              setState(() {
                                _selectedRole = v!;
                              });
                            },
                          ),

                          const Text("Patient"),

                          Radio<String>(
                            value: "Doctor",
                            groupValue: _selectedRole,
                            onChanged: (v) {
                              setState(() {
                                _selectedRole = v!;
                              });
                            },
                          ),

                          const Text("Doctor"),
                        ],
                      ),

                      const SizedBox(height: 20),

                      PrimaryButton(text: "Login", onPressed: _handleLogin),

                      const SizedBox(height: 15),

                      Center(
                        child: TextButton(
                          onPressed: () => context.push('/signup'),
                          child: const Text("Don't have an account? Sign up"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
