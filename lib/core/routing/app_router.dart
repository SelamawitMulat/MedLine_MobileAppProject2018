import 'package:go_router/go_router.dart';

// Landing & Auth Imports
import 'package:med_line/features/home/presentation/screens/landing_page.dart';
import 'package:med_line/features/auth/presentation/screens/signup_screen.dart';
import 'package:med_line/features/auth/presentation/screens/login_screen.dart';

// Doctor Portal Imports
import 'package:med_line/features/home/presentation/screens/doctor_portal/doctor_portal.dart';
import 'package:med_line/features/home/presentation/screens/doctor_portal/queue_management.dart';
import 'package:med_line/features/home/presentation/screens/doctor_portal/visit_summary_page.dart';
import 'package:med_line/features/home/presentation/screens/doctor_portal/visit_summary_form.dart';

// Patient Portal Imports
import 'package:med_line/features/home/presentation/screens/patient_portal/patient_portal.dart';
import 'package:med_line/features/home/presentation/screens/patient_portal/visit_history_page.dart';
import 'package:med_line/features/home/presentation/screens/patient_portal/check_in.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // --- Initial Landing ---
      GoRoute(path: '/', builder: (context, state) => const LandingScreen()),

      // --- Authentication ---
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

      // --- Doctor Portal Section ---
      GoRoute(
        path: '/doctor-portal',
        builder: (context, state) => const DoctorPortalScreen(),
      ),
      GoRoute(
        path: '/queue-management',
        builder: (context, state) => const QueueManagementScreen(),
      ),
      GoRoute(
        path: '/create-summary',
        builder: (context, state) => const VisitSummaryForm(),
      ),
      // Note: This is the Doctor's version of the summary list
      GoRoute(
        path: '/doctor-visit-summary',
        builder: (context, state) => const VisitSummaryPage(),
      ),

      // --- Patient Portal Section ---
      GoRoute(
        path: '/patient-portal',
        builder: (context, state) => const PatientPortalScreen(),
      ),
      // Read-only history for patients (Matches image_912e16.png)
      GoRoute(
        path: '/visit-summary',
        builder: (context, state) => const VisitHistoryPage(),
      ),
      // Check-in status page (Matches image_8fcd3b.png)
      GoRoute(
        path: '/check-in',
        builder: (context, state) => const CheckInScreen(),
      ),
    ],
  );
}
