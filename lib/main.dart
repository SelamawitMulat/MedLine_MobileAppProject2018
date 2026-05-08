import 'package:flutter/material.dart';
import 'core/routing/app_router.dart';

void main() {
  runApp(const MedLineApp());
}

class MedLineApp extends StatelessWidget {
  const MedLineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'MedLine',
      // Connecting the GoRouter configuration
      routerConfig: AppRouter.router,
    );
  }
}
