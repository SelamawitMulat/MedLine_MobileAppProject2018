import 'package:go_router/go_router.dart';
import 'package:med_line/features/home/presentation/screens/landing_page.dart';
import 'package:med_line/features/auth/presentation/screens/signup_screen.dart';
import 'package:med_line/features/auth/presentation/screens/login_screen.dart';
import 'package:med_line/features/home/presentation/screens/doctor_portal/doctor_portal.dart';
import 'package:med_line/features/home/presentation/screens/doctor_portal/queue_management.dart';
import 'package:med_line/features/home/presentation/screens/doctor_portal/visit_summary_page.dart';
import 'package:med_line/features/home/presentation/screens/doctor_portal/visit_summary_form.dart';
import 'package:med_line/features/home/presentation/screens/patient_portal/patient_portal.dart';
import 'package:med_line/features/home/presentation/screens/patient_portal/visit_history_page.dart';
// Important Import
import 'package:med_line/features/home/presentation/screens/patient_portal/check_in.dart';
import 'package:med_line/features/home/presentation/screens/patient_portal/my_appointments.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
<<<<<<< HEAD
=======
      // --- Initial Landing & Auth ---
>>>>>>> 51198e1ef6e111a6fe6ff0b02a51d392a83eb63d
      GoRoute(path: '/', builder: (context, state) => const LandingScreen()),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
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
      GoRoute(
        path: '/patient-portal',
        builder: (context, state) => const PatientPortalScreen(),
      ),
      GoRoute(
        path: '/visit-summary',
        builder: (context, state) => const VisitHistoryPage(),
      ),
<<<<<<< HEAD

      // Patient Check-In Route
=======
>>>>>>> 51198e1ef6e111a6fe6ff0b02a51d392a83eb63d
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
