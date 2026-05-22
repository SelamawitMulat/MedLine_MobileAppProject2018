import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:med_line/core/constants/app_colors.dart';
import 'package:med_line/features/home/presentation/providers/appointment_provider.dart';
import 'package:med_line/features/home/domain/appointment_model.dart';
import 'package:med_line/features/auth/presentation/providers/auth_provider.dart';
import 'package:uuid/uuid.dart';

class BookAppointmentScreen extends ConsumerStatefulWidget {
const BookAppointmentScreen({super.key});

@override
ConsumerState<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends ConsumerState<BookAppointmentScreen> {
DateTime _focusedDay = DateTime.now();
DateTime? _selectedDay;
String? _selectedTime;

final List<String> _timeSlots = [
"09:00", "09:30", "10:00", "10:30", "11:00", "11:30",
"14:00", "14:30", "15:00", "15:30", "16:00", "16:30"
];

Future<void> _handleConfirmAppointment() async {
final user = ref.read(authProvider).value;
if (_selectedDay == null || _selectedTime == null || user == null) return;

final timeParts = _selectedTime!.split(':');
final appointmentDateTime = DateTime(
_selectedDay!.year, _selectedDay!.month, _selectedDay!.day,
int.parse(timeParts[0]), int.parse(timeParts[1]),
);

final newAppointment = Appointment(
id: const Uuid().v4(),
patientId: user.id!,
doctorName: 'General Practitioner',
dateTime: appointmentDateTime,
bookingTimestamp: DateTime.now(),
);

await ref.read(appointmentProvider.notifier).addAppointment(newAppointment);

if (mounted) {
ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
content: Text("Appointment Booked Successfully!"),
backgroundColor: Colors.green,
));
context.pop();
}
}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Colors.white,
appBar: AppBar(
backgroundColor: Colors.white,
elevation: 0,
leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28), onPressed: () => context.pop()),
title: const Text("Book Appointment", style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
),
body: SingleChildScrollView(
padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text("Select Date", style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
Container(
padding: const EdgeInsets.only(bottom: 10),
decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
child: TableCalendar(
firstDay: DateTime.now(), lastDay: DateTime.now().add(const Duration(days: 365)), focusedDay: _focusedDay,
selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
onDaySelected: (selectedDay, focusedDay) => setState(() { _selectedDay = selectedDay; _focusedDay = focusedDay; }),
headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
calendarStyle: CalendarStyle(selectedDecoration: const BoxDecoration(color: AppColors.primaryBlue, shape: BoxShape.circle), todayDecoration: BoxDecoration(color: AppColors.primaryBlue.withValues(alpha: 0.2), shape: BoxShape.circle)),
),
),
const SizedBox(height: 35),
const Text("Available Time Slots", style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
GridView.builder(
shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 2.4, crossAxisSpacing: 10, mainAxisSpacing: 10),
itemCount: _timeSlots.length,
itemBuilder: (context, index) {
bool isSelected = _selectedTime == _timeSlots[index];
return InkWell(onTap: () => setState(() => _selectedTime = _timeSlots[index]), child: Container(decoration: BoxDecoration(color: isSelected ? AppColors.primaryBlue : const Color(0xFFF2F2F2), borderRadius: BorderRadius.circular(10)), alignment: Alignment.center, child: Text(_timeSlots[index], style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold))));
},
),
const SizedBox(height: 40),
SizedBox(
width: double.infinity,
child: ElevatedButton.icon(onPressed: _handleConfirmAppointment, icon: const Icon(Icons.check, color: Colors.white), label: const Text("Confirm Appointment", style: TextStyle(color: Colors.white)), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, padding: const EdgeInsets.symmetric(vertical: 16))),
),
],
),
),
);
}
}