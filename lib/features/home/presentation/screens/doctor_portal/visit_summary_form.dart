import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:med_line/core/constants/app_colors.dart';

class VisitSummaryForm extends StatefulWidget {
  const VisitSummaryForm({super.key});

  @override
  State<VisitSummaryForm> createState() => _VisitSummaryFormState();
}

class _VisitSummaryFormState extends State<VisitSummaryForm> {
  // Key to manage the form validation state
  final _formKey = GlobalKey<FormState>();

  String? _selectedPatient;
  final List<String> _patients = ["John Doe", "Jane Smith", "Alice Wilson"];

  // Controllers to clear text or handle logic if needed
  final _diagnosisController = TextEditingController();
  final _prescriptionController = TextEditingController();
  final _notesController = TextEditingController();

  void _submitForm() {
    // Check if all fields (except notes) are valid
    if (_formKey.currentState!.validate()) {
      // Logic for when the form is valid
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Summary Created Successfully!")),
      );
      context.pop(); // Returns to Visit History
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.8),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey, // Assigning the key here
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with Back Arrow
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => context.pop(),
                      ),
                      const Text(
                        "Create Visit Summary",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _label("Select Patient"),
                  DropdownButtonFormField<String>(
                    value: _selectedPatient,
                    hint: const Text("Choose a patient"),
                    decoration: _inputDecoration(),
                    items: _patients
                        .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                        .toList(),
                    onChanged: (val) => setState(() => _selectedPatient = val),
                    // Validation for Dropdown
                    validator: (value) =>
                        value == null ? "Please select a patient" : null,
                  ),

                  const SizedBox(height: 15),
                  _label("Diagnosis"),
                  TextFormField(
                    controller: _diagnosisController,
                    decoration: _inputDecoration(hint: "Enter Diagnosis"),
                    validator: (value) =>
                        (value == null || value.isEmpty)
                            ? "Diagnosis is required"
                            : null,
                  ),

                  TextFormField(
                    controller: _prescriptionController,
                    decoration: _inputDecoration(hint: "Enter prescription"),
                    validator: (value) =>
                        (value == null || value.isEmpty)
                            ? "Prescription is required"
                            : null,
                  ),
                    const SizedBox(height: 15),
                  _label("Notes (Optional)"),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 2,
                    decoration: _inputDecoration(hint: "Additional notes"),
                    // No validator here because it is optional
                  ),

                  const SizedBox(height: 30),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _submitForm, // Call the validation logic
                      icon: const Icon(Icons.check, color: Colors.white),
                      label: const Text(
                        "Create Summary",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5C6BC0),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      );

  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF8F9FB),
      errorStyle:
          const TextStyle(height: 0.8), // Keeps the card from jumping too much
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
    );
  }

  @override
  void dispose() {
    _diagnosisController.dispose();
    _prescriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}