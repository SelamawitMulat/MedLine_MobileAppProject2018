import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VisitSummaryForm extends StatefulWidget {
  const VisitSummaryForm({super.key});

  @override
  State<VisitSummaryForm> createState() => _VisitSummaryFormState();
}

class _VisitSummaryFormState extends State<VisitSummaryForm> {
  final _formKey = GlobalKey<FormState>();
  final _diagnosisController = TextEditingController();
  final _prescriptionController = TextEditingController();

  @override
  void dispose() {
    _diagnosisController.dispose();
    _prescriptionController.dispose();
    super.dispose();
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
        title: const Text("Create Visit Summary",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Diagnosis Details",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextFormField(
                controller: _diagnosisController,
                decoration: InputDecoration(
                  hintText: "Enter patient diagnosis...",
                  fillColor: const Color(0xFFF8F9FB),
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 25),
              const Text("Prescription / Treatment Plan",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextFormField(
                controller: _prescriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "List prescribed medications...",
                  fillColor: const Color(0xFFF8F9FB),
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide.none), // Fixed deprecated values line 40
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Visit Summary Saved Successfully!"),
                          backgroundColor: Colors.green),
                    );
                    context.pop(true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Save Summary",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
