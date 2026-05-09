import 'package:flutter/material.dart';
import 'package:med_line/core/routing/app_router.dart';

void main() {
  runApp(const MedLineApp());
}

class MedLineApp extends StatelessWidget {
  const MedLineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MedLine',
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router, // Connects the routing logic
    );
  }
}
