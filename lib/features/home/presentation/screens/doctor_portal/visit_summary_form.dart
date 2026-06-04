import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_line/features/home/domain/entities/appointment.dart';
import 'package:med_line/features/home/domain/entities/visit_summary.dart';
import 'package:med_line/features/home/presentation/providers/doctor_provider.dart';
import 'package:med_line/features/home/presentation/providers/visit_summary_provider.dart';
import 'package:med_line/features/home/presentation/providers/appointment_provider.dart';

class VisitSummaryForm extends ConsumerStatefulWidget {
  final Appointment? appointment;
  final VisitSummary? summary;

  const VisitSummaryForm({super.key, this.appointment, this.summary});

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
    _patientNameController.text =
        widget.summary?.patientName ?? widget.appointment?.patientName ?? '';
    _timeSlotController.text =
        widget.summary?.timeSlot ?? widget.appointment?.timeSlot ?? '';
    _diagnosisController.text = widget.summary?.diagnosis ?? '';
    _prescriptionController.text = widget.summary?.prescription ?? '';
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

    String normalize(String n) => n
        .replaceFirst(RegExp(r'^dr\.?\s*', caseSensitive: false), '')
        .trim()
        .toLowerCase();
    final normDoctor = normalize(currentDoctorName);

    final pageTitle =
        widget.summary != null ? 'Edit Visit Summary' : 'Create Visit Summary';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(pageTitle,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold)),
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

                    final messenger = ScaffoldMessenger.of(context);
                    final router = GoRouter.of(context);
                    final isEditing = widget.summary != null;
                    final appointment = widget.appointment;
                    Appointment? resolvedAppointment = appointment;

                    if (!isEditing && resolvedAppointment == null) {
                      final patientName = _patientNameController.text.trim();
                      final appointments = ref.read(appointmentProvider);
                      try {
                        resolvedAppointment = appointments.firstWhere((app) =>
                            app.patientName.toLowerCase() ==
                                patientName.toLowerCase() &&
                            normalize(app.doctorName) == normDoctor);
                      } catch (_) {
                        resolvedAppointment = null;
                      }

                      if (resolvedAppointment == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Patient must already have an appointment.",
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                    }

                    final timeSlot =
                        resolvedAppointment?.timeSlot.isNotEmpty == true
                            ? resolvedAppointment!.timeSlot
                            : _timeSlotController.text.trim().isNotEmpty
                                ? _timeSlotController.text.trim()
                                : 'Now';

                    final summary = VisitSummary(
                      appointmentId: widget.summary?.appointmentId ??
                          resolvedAppointment?.id ??
                          DateTime.now().millisecondsSinceEpoch.toString(),
                      patientId: resolvedAppointment?.patientId ??
                          widget.summary?.patientId ??
                          '',
                      doctorId: resolvedAppointment?.doctorId ??
                          widget.summary?.doctorId ??
                          '',
                      patientName: _patientNameController.text.trim(),
                      doctorName: currentDoctorName,
                      date: resolvedAppointment?.date ?? DateTime.now(),
                      timeSlot: timeSlot,
                      diagnosis: _diagnosisController.text.trim(),
                      prescription: _prescriptionController.text.trim(),
                    );

                    if (isEditing) {
                      await ref
                          .read(visitSummaryProvider.notifier)
                          .updateVisitSummary(summary);
                    } else {
                      await ref
                          .read(visitSummaryProvider.notifier)
                          .addVisitSummary(summary);
                    }

                    if (resolvedAppointment != null) {
                      await ref
                          .read(appointmentProvider.notifier)
                          .updateAppointmentStatus(
                            resolvedAppointment.id,
                            'completed',
                          );
                    }

                    if (!mounted) return;

                    messenger.showSnackBar(
                      const SnackBar(
                          content: Text("Visit Summary Saved Successfully!"),
                          backgroundColor: Colors.green),
                    );
                    router.pop(true);
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
