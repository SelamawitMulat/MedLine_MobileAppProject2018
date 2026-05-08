import 'package:go_router/go_router.dart';
// Feature Imports
import 'package:med_line/features/home/presentation/screens/landing_page.dart';
import 'package:med_line/features/auth/presentation/screens/signup_screen.dart';

// Updated Portal Imports based on your specific file paths
import 'package:med_line/features/home/presentation/screens/doctor_portal/doctor_portal.dart';
import 'package:med_line/features/home/presentation/screens/patient_portal/patient_portal.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // 1. Landing Route
      GoRoute(path: '/', builder: (context, state) => const LandingScreen()),

      // 2. Signup Route
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),

      // 3. Doctor Portal Route
      GoRoute(
        path: '/doctor-portal',
        builder: (context, state) => const DoctorPortalScreen(),
      ),

      // 4. Patient Portal Route
      GoRoute(
        path: '/patient-portal',
        builder: (context, state) => const PatientPortalScreen(),
      ),
    ],
  );
}
