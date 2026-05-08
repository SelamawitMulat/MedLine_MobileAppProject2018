import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/medline_logo.dart';
import '../../../../core/widgets/primary_button.dart';
import '../widgets/feature_info_card.dart';
import '../widgets/role_benefit_card.dart';

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
                    const MedLineLogo(),
                    const SizedBox(height: 40),
                    const Center(
                      child: Text(
                        "Modern\nHealthcare\nQueue\nManagement",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
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
                    PrimaryButton(text: "Login", onPressed: () {}),
                  ],
                ),
              ),

              // --- FOR PATIENTS CARD ---
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

              // --- FOR DOCTORS CARD ---
              const RoleBenefitCard(
                title: "For Doctors",
                headerIcon: Icons.monitor_heart_outlined,
                iconBgColor: AppColors.heartBeatGreen,
                benefits: [
                  "Manage patient queue efficiently",
                  "Call next patient with one tap",
                  "Create and manage visit summaries",
                  "View appointment overview at a glance",
                ],
              ),

              const SizedBox(height: 40),
              const Text(
                "Everything You Need!",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              const FeatureInfoCard(
                icon: Icons.calendar_today_outlined,
                title: "Smart Scheduling",
                description:
                    "Book appointments with intelligent slot management and conflict prevention",
              ),
              const FeatureInfoCard(
                icon: Icons.access_time,
                title: "Real-Time Queue",
                description:
                    "Live queue updates and automatic position tracking for patients",
              ),
              const FeatureInfoCard(
                icon: Icons.description_outlined,
                title: "Visit Records",
                description:
                    "Complete medical history with diagnoses, prescriptions, and notes",
              ), // --- FOOTER CTA SECTION ---
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
                    PrimaryButton(
                      text: "Create Your Account",
                      onPressed: () {},
                      bgColor: Colors.white,
                      textColor: AppColors.primaryBlue,
                      suffixIcon: Icons.arrow_forward,
                    ),
                  ],
                ),
              ),

              // --- COPYRIGHT FOOTER ---
              // Added based on the small image provided
              const Padding(
                padding: EdgeInsets.only(bottom: 30, left: 20, right: 20),
                child: Text(
                  "© 2026 MedLine. Clinical Appointment and Queue Management System.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textGrey,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
