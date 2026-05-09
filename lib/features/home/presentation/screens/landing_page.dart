import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// Using package imports to keep the linter happy
import 'package:med_line/core/constants/app_colors.dart';
import 'package:med_line/core/widgets/medline_logo.dart';
import 'package:med_line/core/widgets/primary_button.dart';
import 'package:med_line/features/home/presentation/widgets/role_benefit_card.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // --- HERO SECTION ---
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const MedLineLogo(),
                        // Added text button to navigate to login page
                        TextButton(
                          onPressed: () => context.push('/login'),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    const Center(
                      child: Text(
                        "Modern\nHealthcare\nQueue\nManagement",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Streamline your clinic appointments with smart queue management, real-time updates, and seamless patient-doctor coordination.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: AppColors.textGrey),
                    ),
                    const SizedBox(height: 32),
                    // Navigation to login page as requested
                    PrimaryButton(
                      text: "Login",
                      onPressed: () => context.push('/login'),
                    ),
                  ],
                ),
              ),

              // --- ROLE CARDS ---
              const RoleBenefitCard(
                title: "For Patients",
                headerIcon: Icons.people_outline,
                iconBgColor: AppColors.accentBlue,
                benefits: [
                  "Book appointments with real-time availability",
                  "Track your queue position live",
                  "Get alerts when your turn is near",
                ],
              ),
              const RoleBenefitCard(
                title: "For Doctors",
                headerIcon: Icons.monitor_heart_outlined,
                iconBgColor: AppColors.heartBeatGreen,
                benefits: [
                  "Manage patient queue efficiently",
                  "Call next patient with one tap",
                  "Create and manage visit summaries",
                ],
              ),

              // --- FOOTER CTA SECTION ---
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Ready to Get Started?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Join MedLine today and transform your healthcare experience",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 30),
                    // --- NAVIGATION TRIGGER ---
                    PrimaryButton(
                      text: "Create Your Account",
                      onPressed: () => context.push(
                        '/signup',
                      ), // This triggers the navigation
                      bgColor: Colors.white,
                      textColor: AppColors.primaryBlue,
                      suffixIcon: Icons.arrow_forward,
                    ),
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: Text(
                  "© 2026 MedLine. Clinical Appointment System.",
                  style: TextStyle(fontSize: 12, color: AppColors.textGrey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
