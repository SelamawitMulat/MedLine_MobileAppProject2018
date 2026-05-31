import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_line/features/auth/presentation/providers/auth_provider.dart';
import 'package:med_line/features/home/domain/entities/appointment.dart';
import 'package:med_line/features/home/domain/entities/visit_summary.dart';

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
import 'package:med_line/features/home/presentation/screens/patient_portal/appointment_booking.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const LandingScreen()),
      GoRoute(
          path: '/signup', builder: (context, state) => const SignupScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

      // --- Doctor Portal ---
      GoRoute(
          path: '/doctor-portal',
          builder: (context, state) => const DoctorPortalScreen()),
      GoRoute(
          path: '/queue-management',
          builder: (context, state) => const QueueManagementScreen()),

      // DOCTOR ONLY PATHS
      GoRoute(
          path: '/doctor-visit-summary',
          builder: (context, state) => const VisitSummaryPage()),
      GoRoute(
          path: '/create-summary',
          builder: (context, state) => VisitSummaryForm(
                appointment: state.extra is Appointment
                    ? state.extra as Appointment
                    : null,
                summary: state.extra is VisitSummary
                    ? state.extra as VisitSummary
                    : null,
              )),

      // --- Patient Portal ---
      GoRoute(
          path: '/patient-portal',
          builder: (context, state) => const PatientPortalScreen()),
      GoRoute(
          path: '/visit-summary',
          builder: (context, state) => const VisitHistoryPage()),
      GoRoute(
          path: '/check-in',
          builder: (context, state) => const CheckInScreen()),
      GoRoute(
          path: '/my-appointments',
          builder: (context, state) => const MyAppointmentsScreen()),
      GoRoute(
          path: '/book-appointment',
          builder: (context, state) => BookAppointmentScreen(
                rescheduleAppointment: state.extra is Appointment
                    ? state.extra as Appointment
                    : null,
              )),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final container = ProviderScope.containerOf(context, listen: false);
      final authState = container.read(authProvider);
      final user = authState.hasValue ? authState.value : null;
      final isLoggedIn = user != null;
      final location = state.uri.path;

      final authPaths = {'/', '/login', '/signup'};
      final doctorPaths = {
        '/doctor-portal',
        '/queue-management',
        '/doctor-visit-summary',
        '/create-summary'
      };
      final patientPaths = {
        '/patient-portal',
        '/visit-summary',
        '/check-in',
        '/my-appointments',
        '/book-appointment'
      };

      if (!isLoggedIn && !authPaths.contains(location)) {
        return '/login';
      }

      if (isLoggedIn) {
        final isDoctor = user.role.toLowerCase() == 'doctor';

        if (authPaths.contains(location)) {
          return isDoctor ? '/doctor-portal' : '/patient-portal';
        }

        if (isDoctor && patientPaths.contains(location)) {
          return '/doctor-portal';
        }

        if (!isDoctor && doctorPaths.contains(location)) {
          return '/patient-portal';
        }
      }

      return null;
    },
  );
}
