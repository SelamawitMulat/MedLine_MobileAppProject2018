import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:med_line/features/home/domain/appointment_model.dart';
import 'package:med_line/features/home/presentation/providers/appointment_provider.dart';

class BookAppointmentScreen extends ConsumerStatefulWidget {
  final Appointment? rescheduleAppointment;

  const BookAppointmentScreen({super.key, this.rescheduleAppointment});

  @override
  ConsumerState<BookAppointmentScreen> createState() =>
      _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends ConsumerState<BookAppointmentScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _selectedTime;

  final String _soleDoctor = "Dr. Selam Mulat";

  final List<String> _timeSlots = [
    "09:00",
    "09:30",
    "10:00",
    "10:30",
    "11:00",
    "11:30",
    "14:00",
    "14:30",
    "15:00",
    "15:30",
    "16:00",
    "16:30",
  ];

  Future<void> _handleConfirmAppointment() async {
    if (_selectedDay == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select both a date and a time slot."),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      final isReschedule = widget.rescheduleAppointment != null;
      if (isReschedule) {
        await ref.read(appointmentProvider.notifier).rescheduleAppointment(
              widget.rescheduleAppointment!.id,
              _selectedDay!,
              _selectedTime!,
            );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Appointment rescheduled successfully!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        await ref.read(appointmentProvider.notifier).bookAppointment(
              doctorName: _soleDoctor,
              date: _selectedDay!,
              timeSlot: _selectedTime!,
            );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Appointment booked successfully!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
      if (mounted) context.pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.rescheduleAppointment != null) {
      _selectedDay = widget.rescheduleAppointment!.date;
      _focusedDay = widget.rescheduleAppointment!.date;
      _selectedTime = widget.rescheduleAppointment!.timeSlot;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isReschedule = widget.rescheduleAppointment != null;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () => context.pop(),
        ),
        title: Text(
          isReschedule ? "Reschedule Appointment" : "Book Appointment",
          style: const TextStyle(
              color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Select Date",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(12),
                    blurRadius: 10,
                  )
                ],
              ),
              child: TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(const Duration(days: 365)),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                calendarStyle: CalendarStyle(
                  selectedDecoration: const BoxDecoration(
                      color: Color(0xFF2563EB), shape: BoxShape.circle),
                  todayDecoration: BoxDecoration(
                    color: const Color(0xFF2563EB).withAlpha(50),
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: const TextStyle(
                      color: Color(0xFF2563EB), fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 35),
            const Text("Available Time Slots",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _timeSlots.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedTime == _timeSlots[index];
                return InkWell(
                  onTap: () =>
                      setState(() => _selectedTime = _timeSlots[index]),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF2563EB)
                          : const Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _timeSlots[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _handleConfirmAppointment,
                icon: const Icon(Icons.check, color: Colors.white, size: 28),
                label: const Text("Confirm Appointment",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
