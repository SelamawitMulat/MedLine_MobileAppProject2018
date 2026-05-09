import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:med_line/core/constants/app_colors.dart';
import 'package:med_line/core/widgets/primary_button.dart';

class VisitSummaryForm extends StatefulWidget {
  const VisitSummaryForm({super.key});

  @override
  State<VisitSummaryForm> createState() => _VisitSummaryFormState();
}

class _VisitSummaryFormState extends State<VisitSummaryForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers to capture the data
  final _patientController = TextEditingController();
  final _diagnosisController = TextEditingController();
  final _prescriptionController = TextEditingController();
  final _notesController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Process data here
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- HEADER WITH CLOSE ICON ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Create Visit Summary",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 30,
                        color: Colors.black,
                      ),
                      onPressed: () => context.pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                // --- SELECT PATIENT ---
                const Text(
                  "Select Patient",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                _buildInputField(
                  controller: _patientController,
                  hintText: "Choose a patient",
                  validator: (v) =>
                      v!.isEmpty ? "Please select a patient" : null,
                ),
                const SizedBox(height: 20),

                // --- DIAGNOSIS ---
                const Text(
                  "Diagnosis",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                _buildInputField(
                  controller: _diagnosisController,
                  hintText: "Enter Diagnosis",
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 20),

                // --- PRESCRIPTION ---
                const Text(
                  "Prescription",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                _buildInputField(
                  controller: _prescriptionController,
                  hintText: "Enter prescription",
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 20),

                // --- NOTES (OPTIONAL) ---
                const Text(
                  "Notes (Optional)",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                _buildInputField(
                  controller: _notesController,
                  hintText:
                      "Additionl notes", // Kept typo from image per request
                  maxLines: 3,
                ),
                const SizedBox(height: 40),

                // --- CREATE SUMMARY BUTTON ---
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: _submitForm,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check, color: Colors.white, size: 28),
                        SizedBox(width: 10),
                        Text(
                          "Create Summary",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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

  // Custom Input Field to match image style
  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: AppColors.cardGrey,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
