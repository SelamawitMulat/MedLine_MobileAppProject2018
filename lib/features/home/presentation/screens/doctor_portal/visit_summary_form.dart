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
  final _diagnosisController = TextEditingController();
  final _prescriptionController = TextEditingController();
  Appointment? _selectedAppointment;

  @override
  void initState() {
    super.initState();
    if (widget.appointment != null) {
      _selectedAppointment = widget.appointment;
    }
    _diagnosisController.text = widget.summary?.diagnosis ?? '';
    _prescriptionController.text = widget.summary?.prescription ?? '';
  }

  @override
  void dispose() {
    _diagnosisController.dispose();
    _prescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentDoctorName = ref.watch(doctorNameProvider);
    final appointments = ref.watch(appointmentProvider);

    String normalize(String n) => n
        .replaceFirst(RegExp(r'^dr\.?\s*', caseSensitive: false), '')
        .trim()
        .toLowerCase();
    final normDoctor = normalize(currentDoctorName);

    // Filter checked-in appointments for this doctor
    final checkedInAppointments = appointments
        .where((app) =>
            app.status.toLowerCase() == 'checked_in' &&
            normalize(app.doctorName) == normDoctor)
        .toList();

    // Ensure dropdown items are unique by appointment id and keep the selected
    // appointment if it is not currently in the checked-in list.
    final appointmentsById = <String, Appointment>{};
    for (final app in checkedInAppointments) {
      appointmentsById[app.id] = app;
    }
    if (_selectedAppointment != null) {
      appointmentsById.putIfAbsent(
          _selectedAppointment!.id, () => _selectedAppointment!);
    }
    final dropdownAppointments = appointmentsById.values.toList();

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
              const Text("Select Patient",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              DropdownButtonFormField<Appointment>(
                initialValue: _selectedAppointment,
                items: dropdownAppointments.map((app) {
                  return DropdownMenuItem<Appointment>(
                    value: app,
                    child: Text(
                      '${app.patientName} - ${app.date.toLocal().toString().split(' ').first} ${app.timeSlot}',
                    ),
                  );
                }).toList(),
                onChanged: (appointment) {
                  setState(() {
                    _selectedAppointment = appointment;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Select a checked-in patient...",
                  fillColor: const Color(0xFFF8F9FB),
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a patient';
                  }
                  return null;
                },
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
                      borderSide: BorderSide.none),
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
                    final appointment = _selectedAppointment;

                    if (appointment == null) {
                      messenger.showSnackBar(
                        const SnackBar(
                          content: Text("Please select a patient appointment."),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    final summary = VisitSummary(
                      appointmentId: appointment.id,
                      patientId: appointment.patientId ?? '',
                      doctorId: appointment.doctorId ?? '',
                      patientName: appointment.patientName,
                      doctorName: currentDoctorName,
                      date: appointment.date,
                      timeSlot: appointment.timeSlot,
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

                    await ref
                        .read(appointmentProvider.notifier)
                        .updateAppointmentStatus(
                          appointment.id,
                          'completed',
                        );

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
