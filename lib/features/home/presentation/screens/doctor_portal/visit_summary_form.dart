import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:med_line/core/constants/app_colors.dart';
import 'package:med_line/core/widgets/primary_button.dart';

class VisitSummaryForm extends StatelessWidget {
  const VisitSummaryForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text(
          "Create Visit Summary",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(labelText: "Patient Name"),
            ),
            const SizedBox(height: 20),
            const TextField(
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "Diagnosis/Notes",
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(),
            PrimaryButton(
              text: "Save Summary",
              onPressed: () {
                // Logic to save
                context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
