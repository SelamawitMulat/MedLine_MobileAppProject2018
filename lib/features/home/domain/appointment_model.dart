class Appointment {
  final String id;
  final String patientName;
  final DateTime date;
  final String timeSlot;
  final String doctorName;
  final String status; // 'Upcoming', 'Completed', 'Cancelled', 'Checked In'

  Appointment({
    required this.id,
    required this.patientName,
    required this.date,
    required this.timeSlot,
    this.doctorName = "Dr. Selam Mulat", // Corrected default parameter syntax
    this.status = "Upcoming",
  });

  // Fully implemented copyWith to let both patient and doctor update fields smoothly
  Appointment copyWith({
    String? id,
    String? patientName,
    DateTime? date,
    String? timeSlot,
    String? doctorName,
    String? status,
  }) {
    return Appointment(
      id: id ?? this.id,
      patientName: patientName ?? this.patientName,
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
      doctorName: doctorName ?? this.doctorName,
      status: status ?? this.status,
    );
  }
}
