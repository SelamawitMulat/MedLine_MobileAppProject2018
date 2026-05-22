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
    this.doctorName = "Dr. Selam Mulat",
    this.status = "Upcoming",
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id']?.toString() ?? '',
      patientName: json['patientName'] ?? json['patientId'] ?? '',
      date: json['date'] != null 
          ? DateTime.parse(json['date']) 
          : (json['dateTime'] != null ? DateTime.parse(json['dateTime']) : DateTime.now()),
      timeSlot: json['timeSlot'] ?? '',
      doctorName: json['doctorName'] ?? "Dr. Selam Mulat",
      status: json['status'] ?? "Upcoming",
    );
  }

  Map<String, dynamic> toLocalJson() {
    return {
      'id': id,
      'patientName': patientName,
      'date': date.toIso8601String(),
      'timeSlot': timeSlot,
      'doctorName': doctorName,
      'status': status,
    };
  }

  Map<String, dynamic> toApiJson() {
    return {
      'patientName': patientName,
      'date': date.toIso8601String(),
      'timeSlot': timeSlot,
      'doctorName': doctorName,
      'status': status,
    };
  }

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
