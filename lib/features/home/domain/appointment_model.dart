class Appointment {
  final String id;
  final String patientId;
  final String? doctorName;
  final DateTime dateTime;
  final DateTime bookingTimestamp;

  Appointment({
    required this.id,
    required this.patientId,
    this.doctorName,
    required this.dateTime,
    required this.bookingTimestamp,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id']?.toString() ?? '',
      patientId: json['patientId']?.toString() ?? '',
      doctorName: json['doctorName']?.toString(),
      dateTime: DateTime.parse(json['dateTime'] as String),
      bookingTimestamp: DateTime.parse(json['bookingTimestamp'] as String),
    );
  }

  Map<String, dynamic> toApiJson() => {
    'patientId': patientId,
    'doctorName': doctorName ?? 'General Practitioner',
    'dateTime': dateTime.toIso8601String(),
    'bookingTimestamp': bookingTimestamp.toIso8601String(),
  };

  Map<String, dynamic> toLocalJson() => {
    'id': id,
    'patientId': patientId,
    'doctorName': doctorName,
    'dateTime': dateTime.toIso8601String(),
    'bookingTimestamp': bookingTimestamp.toIso8601String(),
  };
}