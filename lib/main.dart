import 'package:flutter/material.dart';
import 'features/home/presentation/screens/landing_page.dart';

void main() {
  runApp(const MedLineApp());
}

class MedLineApp extends StatelessWidget {
  const MedLineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MedLine',
      theme: ThemeData(useMaterial3: true, primarySwatch: Colors.blue),
      home: const LandingScreen(),
    );
  }
}
