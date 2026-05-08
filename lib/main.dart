import 'package:flutter/material.dart';
// Replace 'med_line' with your actual project name from pubspec.yaml
import 'package:med_line/core/routing/app_router.dart';
import 'package:med_line/core/constants/app_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MedLineApp());
}

class MedLineApp extends StatelessWidget {
  const MedLineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MedLine',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryBlue),
      ),
      routerConfig: AppRouter.router,
    );
  }
}
