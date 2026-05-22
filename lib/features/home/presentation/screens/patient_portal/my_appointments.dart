import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:med_line/features/home/presentation/providers/appointment_provider.dart';
import 'package:med_line/features/auth/presentation/providers/auth_provider.dart';

class MyAppointmentsScreen extends ConsumerWidget {
  const MyAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appointmentProvider);
    final userId = ref.watch(authProvider).value?.id;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => context.pop()),
          title: const Text("My Appointments", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text("Error: $e")),
        data: (appointments) {
          final userApps = appointments.where((a) => a.patientId == userId).toList();
          if (userApps.isEmpty) return const Center(child: Text("You have no created appointments yet"));
          return SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: userApps.map((a) => _buildAppointmentItem(context, a)).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppointmentItem(BuildContext context, dynamic a) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFFF8F9FB), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade100)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: const Text("Upcoming", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))),
              const Row(children: [Icon(Icons.people_outline, color: Colors.grey, size: 20), SizedBox(width: 5), Text("Queue Active", style: TextStyle(fontWeight: FontWeight.bold))]),
            ],
          ),
          const SizedBox(height: 20),
          Row(children: [const Icon(Icons.calendar_today, color: Colors.black, size: 20), SizedBox(width: 10), Text(DateFormat('EEEE, MMMM d, yyyy').format(a.dateTime), style: const TextStyle(fontWeight: FontWeight.w500))]),
          const SizedBox(height: 10),
          Row(children: [const Icon(Icons.access_time, color: Colors.black, size: 20), SizedBox(width: 10), Text(DateFormat('h:mm a').format(a.dateTime))]),
        ],
      ),
    );
  }
}