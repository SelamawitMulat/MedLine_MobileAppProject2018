import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../features/home/presentation/screens/landing_page.dart';
import '../../../features/auth/presentation/screens/signup_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // Landing Page Route
      GoRoute(path: '/', builder: (context, state) => const LandingScreen()),
      // Signup Page Route
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
    ],
  );
}
