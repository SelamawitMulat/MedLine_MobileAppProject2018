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
import 'package:med_line/features/home/presentation/screens/patient_portal/my_appointments.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // --- Initial Landing & Auth ---
      GoRoute(path: '/', builder: (context, state) => const LandingScreen()),
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
      GoRoute(
        path: '/doctor-visit-summary',
        builder: (context, state) => const VisitSummaryPage(),
      ),

      // --- Patient Portal Section ---
      GoRoute(
        path: '/patient-portal',
        builder: (context, state) => const PatientPortalScreen(),
      ),
      GoRoute(
        path: '/visit-summary',
        builder: (context, state) => const VisitHistoryPage(),
      ),
      GoRoute(
        path: '/check-in',
        builder: (context, state) => const CheckInScreen(),
      ),
      // Path is correctly spelled here
      GoRoute(
        path: '/my-appointments',
        builder: (context, state) => const MyAppointmentsScreen(),
      ),
    ],
  );
}
