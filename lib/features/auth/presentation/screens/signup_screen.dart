import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_line/core/constants/app_colors.dart';
import 'package:med_line/features/auth/presentation/providers/auth_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String _selectedRole = 'Patient';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  String _generateUsername() {
    final email = _emailController.text.trim();
    if (email.contains('@')) {
      return email.split('@').first;
    }
    return _nameController.text
        .trim()
        .replaceAll(RegExp(r'\s+'), '')
        .toLowerCase();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords do not match"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(authProvider.notifier).signup(
            username: _usernameController.text.trim().isNotEmpty
                ? _usernameController.text.trim().toLowerCase()
                : _generateUsername(),
            password: _passwordController.text.trim(),
            role: _selectedRole.toLowerCase(),
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
          );

      final authState = ref.read(authProvider);
      if (authState.hasValue && authState.value != null) {
        final role = authState.value!.role.toLowerCase();
        if (role == 'doctor') {
          context.go('/doctor-portal');
        } else {
          context.go('/patient-portal');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Account Created Successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        return;
      }

      throw Exception('Failed to create account');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
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
                const Text("MedLine",
                    style:
                        TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const Text("Clinical Appointment Management",
                    style: TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(height: 30),
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
                      _inputLabel("Username"),
                      _buildTextField(
                        _usernameController,
                        "Optional: enter a username",
                        allowEmpty: true,
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Username is optional. If left blank, it will be generated from your email.",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 15),
                      _inputLabel("Email"),
                      _buildTextField(_emailController, "Enter your email",
                          isEmail: true),
                      const SizedBox(height: 15),
                      _inputLabel("Password"),
                      _buildPasswordField(
                        controller: _passwordController,
                        hint: "Create a password",
                        isObscured: _obscurePassword,
                        onToggle: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                      ),
                      const SizedBox(height: 15),
                      _inputLabel("Confirm Password"),
                      _buildPasswordField(
                        controller: _confirmPasswordController,
                        hint: "Confirm your password",
                        isObscured: _obscureConfirmPassword,
                        onToggle: () => setState(() =>
                            _obscureConfirmPassword = !_obscureConfirmPassword),
                      ),
                      const SizedBox(height: 20),
                      const Text("I am a",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Patient',
                            groupValue: _selectedRole,
                            activeColor: Colors.black,
                            onChanged: (val) =>
                                setState(() => _selectedRole = val!),
                          ),
                          const Text("Patient"),
                          const SizedBox(width: 20),
                          Radio<String>(
                            value: 'Doctor',
                            groupValue: _selectedRole,
                            activeColor: Colors.black,
                            onChanged: (val) =>
                                setState(() => _selectedRole = val!),
                          ),
                          const Text("Doctor"),
                        ],
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleSignUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text("Sign Up",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
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
      {bool isEmail = false, bool allowEmpty = false}) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(hint),
      validator: (value) {
        if (!allowEmpty && (value == null || value.trim().isEmpty)) {
          return "Field required";
        }
        if (isEmail && (value == null || !value.contains('@'))) {
          return "Invalid email address";
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool isObscured,
    required VoidCallback onToggle,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscured,
      decoration: _inputDecoration(hint).copyWith(
        suffixIcon: IconButton(
          icon: Icon(isObscured ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey),
          onPressed: onToggle,
        ),
      ),
      validator: (value) =>
          (value == null || value.isEmpty) ? "Field required" : null,
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFE5E7EB),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
