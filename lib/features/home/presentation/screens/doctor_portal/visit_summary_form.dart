import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_line/features/home/domain/appointment_model.dart';
import 'package:med_line/features/home/domain/visit_summary_model.dart';
import 'package:med_line/features/home/presentation/providers/doctor_provider.dart';
import 'package:med_line/features/home/presentation/providers/visit_summary_provider.dart';

class VisitSummaryForm extends ConsumerStatefulWidget {
  final Appointment? appointment;

  const VisitSummaryForm({super.key, this.appointment});

  @override
  ConsumerState<VisitSummaryForm> createState() => _VisitSummaryFormState();
}

class _VisitSummaryFormState extends ConsumerState<VisitSummaryForm> {
  final _formKey = GlobalKey<FormState>();
  final _patientNameController = TextEditingController();
  final _timeSlotController = TextEditingController();
  final _diagnosisController = TextEditingController();
  final _prescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _patientNameController.text = widget.appointment?.patientName ?? '';
    _timeSlotController.text = widget.appointment?.timeSlot ?? '';
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _timeSlotController.dispose();
    _diagnosisController.dispose();
    _prescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentDoctorName = ref.watch(doctorNameProvider);

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
              TextFormField(
                controller: _patientNameController,
                decoration: InputDecoration(
                  hintText: "Enter patient name...",
                  labelText: "Patient Name",
                  fillColor: const Color(0xFFF8F9FB),
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a patient name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _timeSlotController,
                decoration: InputDecoration(
                  hintText: "Enter visit time slot...",
                  labelText: "Time Slot",
                  fillColor: const Color(0xFFF8F9FB),
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 25),
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
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    final appointment = widget.appointment;
                    final timeSlot = (appointment?.timeSlot.isNotEmpty == true)
                        ? appointment!.timeSlot
                        : _timeSlotController.text.trim().isNotEmpty
                            ? _timeSlotController.text.trim()
                            : 'Now';

                    final summary = VisitSummary(
                      appointmentId: appointment?.id ??
                          DateTime.now().millisecondsSinceEpoch.toString(),
                      patientName: _patientNameController.text.trim(),
                      doctorName: appointment?.doctorName ?? currentDoctorName,
                      date: appointment?.date ?? DateTime.now(),
                      timeSlot: timeSlot,
                      diagnosis: _diagnosisController.text.trim(),
                      prescription: _prescriptionController.text.trim(),
                    );

                    await ref
                        .read(visitSummaryProvider.notifier)
                        .addVisitSummary(summary);
                    if (!mounted) return;

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
