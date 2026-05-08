import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class MedLineLogo extends StatelessWidget {
  const MedLineLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.stacked_line_chart, // Closest material icon to the heartbeat
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'MedLine',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }
}
