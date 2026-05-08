import 'package:go_router/go_router.dart';
import 'package:med_line/features/home/presentation/screens/landing_page.dart';
// Standardized path for your Signup Screen
import 'package:med_line/features/auth/presentation/screens/signup_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // Landing Route
      GoRoute(path: '/', builder: (context, state) => const LandingScreen()),

      // Signup Route - Fixed the class name to 'SignupScreen'
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
    ],
  );
}
