import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_line/core/constants/app_colors.dart';
import 'package:med_line/features/auth/presentation/providers/auth_provider.dart';
import 'package:uuid/uuid.dart';

class SignupScreen extends ConsumerStatefulWidget {
const SignupScreen({super.key});

@override
ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
final _formKey = GlobalKey<FormState>();
final _nameController = TextEditingController();
final _emailController = TextEditingController();
final _passwordController = TextEditingController();
final _confirmPasswordController = TextEditingController();

String _selectedRole = 'Patient';
bool _isPasswordVisible = false;
bool _isConfirmPasswordVisible = false;

void _handleSignUp() async {
if (_formKey.currentState!.validate()) {
if (_passwordController.text != _confirmPasswordController.text) {
ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Passwords do not match!"), backgroundColor: Colors.red));
return;
}

await ref.read(authProvider.notifier).signup(
username: _emailController.text,
password: _passwordController.text,
role: _selectedRole,
name: _nameController.text,
email: _emailController.text,
);

final authState = ref.read(authProvider);
if (authState.hasValue && authState.value != null) {
ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Account Created!"), backgroundColor: Colors.green));
if (_selectedRole == 'Doctor') {
context.go('/doctor-portal');
} else {
context.go('/patient-portal');
}
}
}
}

@override
Widget build(BuildContext context) {
final authState = ref.watch(authProvider);

return Scaffold(
backgroundColor: Colors.white,
appBar: AppBar(
backgroundColor: Colors.white,
elevation: 0,
leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => context.pop()),
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
decoration: BoxDecoration(color: AppColors.primaryBlue, borderRadius: BorderRadius.circular(20)),
child: const Icon(Icons.show_chart, color: Colors.white, size: 55),
),
const Text("MedLine", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
const Text("Clinical Appointment Management", style: TextStyle(color: Colors.grey, fontSize: 14)),
const SizedBox(height: 35),
Container(
padding: const EdgeInsets.all(20),
decoration: BoxDecoration(color: const Color(0xFFF8F9FB), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200)),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
_inputLabel("Full Name"),
_buildTextField(_nameController, "Enter your name"),
_inputLabel("Email"),
_buildTextField(_emailController, "Enter your email", isEmail: true),
_inputLabel("Password"),
_buildPassField(_passwordController, "Create a password", _isPasswordVisible, (v) => setState(() => _isPasswordVisible = v)),
 _inputLabel("Confirm Password"),
_buildPassField(_confirmPasswordController, "Confirm your password", _isConfirmPasswordVisible, (v) => setState(() => _isConfirmPasswordVisible = v)),
const SizedBox(height: 20),
Row(children: [Radio(value: 'Patient', groupValue: _selectedRole, onChanged: (v) => setState(() => _selectedRole = v!)), const Text("Patient")]),
Row(children: [Radio(value: 'Doctor', groupValue: _selectedRole, onChanged: (v) => setState(() => _selectedRole = v!)), const Text("Doctor")]),
const SizedBox(height: 25),
authState.isLoading
? const Center(child: CircularProgressIndicator())
    : SizedBox(
width: double.infinity,
child: ElevatedButton(onPressed: _handleSignUp, style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue), child: const Text("Sign Up", style: TextStyle(color: Colors.white))),
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

Widget _inputLabel(String label) => Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)));

Widget _buildTextField(TextEditingController c, String h, {bool isEmail = false}) => TextFormField(
controller: c,
decoration: InputDecoration(hintText: h, filled: true, fillColor: const Color(0xFFE5E7EB), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)),
validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
);

Widget _buildPassField(TextEditingController c, String h, bool visible, Function(bool) toggle) => TextFormField(
controller: c,
obscureText: !visible,
decoration: InputDecoration(
hintText: h,
filled: true,
fillColor: const Color(0xFFE5E7EB),
suffixIcon: IconButton(icon: Icon(visible ? Icons.visibility : Icons.visibility_off), onPressed: () => toggle(!visible)),
border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
),
validator: (v) => (v == null || v.length < 6) ? "Min 6 chars" : null,
);

@override
void dispose() {
_nameController.dispose();
_emailController.dispose();
_passwordController.dispose();
_confirmPasswordController.dispose();
super.dispose();
}
}