import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_line/core/constants/app_colors.dart';
import 'package:med_line/features/home/presentation/providers/doctor_provider.dart';
import 'package:med_line/features/home/presentation/providers/visit_summary_provider.dart';

class VisitSummaryPage extends ConsumerWidget {
  const VisitSummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDoctorName = ref.watch(doctorNameProvider);
    final summaries = ref
        .watch(visitSummaryProvider)
        .where((s) => s.doctorName == currentDoctorName)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.black, size: 28),
                        onPressed: () => context.pop(),
                      ),
                      Text(
                        "$currentDoctorName's Visit Summaries",
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => context.push('/create-summary'),
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:
                          const Icon(Icons.add, color: Colors.white, size: 30),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              if (summaries.isEmpty)
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.description_outlined,
                            color: Colors.grey, size: 55),
                        const SizedBox(height: 10),
                        Text("No visit summaries for $currentDoctorName yet",
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 16)),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: summaries.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 15),
                    itemBuilder: (context, index) {
                      final summary = summaries[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 1,
                        child: ExpansionTile(
                          title: Text(summary.patientName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                          subtitle: Text(summary.doctorName),
                          childrenPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          children: [
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  summary.date
                                      .toLocal()
                                      .toString()
                                      .split(' ')
                                      .first,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                Text(summary.timeSlot,
                                    style: const TextStyle(color: Colors.grey)),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF7F9FC),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Diagnosis",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  const SizedBox(height: 8),
                                  Text(summary.diagnosis),
                                  const SizedBox(height: 16),
                                  const Text("Prescription",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  const SizedBox(height: 8),
                                  Text(summary.prescription),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
