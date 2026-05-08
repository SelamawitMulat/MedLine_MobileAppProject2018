import 'package:go_router/go_router.dart';
// Ensure this points to where your LandingScreen actually is
import 'package:med_line/features/home/presentation/screens/landing_page.dart';

class AppRouter {
  // This is the 'router' variable that main.dart is looking for
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const LandingScreen()),
    ],
  );
}
