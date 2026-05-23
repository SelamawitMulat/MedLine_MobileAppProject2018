class VisitSummary {
  final String appointmentId;
  final String patientName;
  final String doctorName;
  final DateTime date;
  final String timeSlot;
  final String diagnosis;
  final String prescription;

  VisitSummary({
    required this.appointmentId,
    required this.patientName,
    required this.doctorName,
    required this.date,
    required this.timeSlot,
    required this.diagnosis,
    required this.prescription,
  });

  factory VisitSummary.fromJson(Map<String, dynamic> json) {
    return VisitSummary(
      appointmentId: json['appointmentId']?.toString() ?? '',
      patientName: json['patientName']?.toString() ?? '',
      doctorName: json['doctorName']?.toString() ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'].toString())
          : DateTime.now(),
      timeSlot: json['timeSlot']?.toString() ?? '',
      diagnosis: json['diagnosis']?.toString() ?? '',
      prescription: json['prescription']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointmentId': appointmentId,
      'patientName': patientName,
      'doctorName': doctorName,
      'date': date.toIso8601String(),
      'timeSlot': timeSlot,
      'diagnosis': diagnosis,
      'prescription': prescription,
    };
  }
}
