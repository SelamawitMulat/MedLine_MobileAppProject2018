import 'package:flutter/material.dart';
import 'package:med_line/core/constants/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  // Make these optional with the '?' so the Signup page doesn't break
  final Color? bgColor;
  final Color? textColor;
  final IconData? suffixIcon;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.bgColor,
    this.textColor,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          // Uses the color you pass in, or defaults to primaryBlue
          backgroundColor: bgColor ?? AppColors.primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Only draws the icon if you actually provide one
            if (suffixIcon != null) ...[
              const SizedBox(width: 10),
              Icon(suffixIcon, color: textColor ?? Colors.white, size: 20),
            ],
          ],
        ),
      ),
    );
  }
}
