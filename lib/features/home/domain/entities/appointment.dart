import 'package:equatable/equatable.dart';

class Appointment extends Equatable {
  final String id;
  final String patientName;
  final DateTime date;
  final String timeSlot;
  final String doctorName;
  final String status;
  final String? patientId;
  final String? doctorId;
  final String reason;
  final bool isCheckedIn;

  const Appointment({
    required this.id,
    required this.patientName,
    required this.date,
    required this.timeSlot,
    this.doctorName = "Dr. Selam Mulat",
    this.status = "pending",
    this.patientId,
    this.doctorId,
    this.reason = "",
    this.isCheckedIn = false,
  });

  static const String pending = 'pending';
  static const String checkedIn = 'checked_in';
  static const String completed = 'completed';
  static const String missed = 'missed';
  static const String cancelled = 'cancelled';
  static const String canceled = 'canceled';
  static const String skipped = 'skipped';

  bool get isCompleted => status.toLowerCase() == completed;

  static bool parseCheckedInFlag(dynamic rawIsCheckedIn) {
    return rawIsCheckedIn == true ||
        rawIsCheckedIn == 1 ||
        rawIsCheckedIn == '1';
  }

  static String normalizeStatus(dynamic rawStatus, {bool isCheckedIn = false}) {
    if (isCheckedIn) return checkedIn;

    final low = rawStatus?.toString().trim().toLowerCase() ?? '';
    if (low.isEmpty) return pending;
    if (low == pending) return pending;
    if (low == checkedIn ||
        low == 'check_in' ||
        low == 'checkin' ||
        low == 'check-in' ||
        low == 'checked in') {
      return checkedIn;
    }
    if (low == cancelled || low == canceled) return cancelled;
    if (low == skipped) return skipped;
    return low;
  }

  static bool effectiveCheckedIn(dynamic rawIsCheckedIn, String status) {
    return parseCheckedInFlag(rawIsCheckedIn) || status == checkedIn;
  }

  static String _capitalizeStatus(String input) {
    return input
        .trim()
        .replaceAll('_', ' ')
        .split(RegExp(r'\s+'))
        .map((word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  DateTime? get appointmentDateTime {
    try {
      final parts = timeSlot.split(':').map(int.parse).toList();
      return DateTime(date.year, date.month, date.day, parts[0], parts[1])
          .toLocal();
    } catch (_) {
      return null;
    }
  }

  bool get isOverdue {
    final appointmentDateTime = this.appointmentDateTime;
    if (appointmentDateTime == null) return false;
    return DateTime.now().toLocal().isAfter(appointmentDateTime);
  }

  bool get isMissed {
    final low = status.toLowerCase();
    if (low == cancelled || low == skipped || low == completed) {
      return false;
    }
    return isOverdue;
  }

  static int _statusPriority(String status, {bool isCheckedIn = false}) {
    if (isCheckedIn) return 0;
    final low = status.toLowerCase();
    if (low == checkedIn) return 0;
    if (low == pending) return 1;
    if (low == skipped) return 2;
    return 3;
  }

  static String _normalizeDoctorName(String name) {
    return name
        .replaceFirst(RegExp(r'^dr\.?\s*', caseSensitive: false), '')
        .trim()
        .toLowerCase();
  }

  static bool _matchesDoctor(Appointment app, String? doctorId, String? doctorName) {
    if (doctorId != null && doctorId.isNotEmpty) {
      if (app.doctorId != null && app.doctorId!.isNotEmpty) {
        return app.doctorId == doctorId;
      }
    }
    if (doctorName != null && doctorName.isNotEmpty) {
      return _normalizeDoctorName(app.doctorName) ==
          _normalizeDoctorName(doctorName);
    }
    return true;
  }

  static List<Appointment> queueAppointments(List<Appointment> appointments,
      {String? doctorId, String? doctorName}) {
    final queue = appointments.where((app) {
      final low = app.status.toLowerCase();
      if (low == cancelled || low == completed) return false;
      return _matchesDoctor(app, doctorId, doctorName);
    }).toList();

    queue.sort((a, b) {
      final priorityA = _statusPriority(a.status, isCheckedIn: a.isCheckedIn);
      final priorityB = _statusPriority(b.status, isCheckedIn: b.isCheckedIn);
      if (priorityA != priorityB) return priorityA.compareTo(priorityB);

      final timeA = a.appointmentDateTime;
      final timeB = b.appointmentDateTime;
      if (timeA != null && timeB != null) return timeA.compareTo(timeB);
      if (timeA != null) return -1;
      if (timeB != null) return 1;
      return a.id.compareTo(b.id);
    });

    return queue;
  }

  static int queuePosition(Appointment appointment, List<Appointment> appointments,
      {String? doctorId, String? doctorName}) {
    final queue = queueAppointments(
      appointments,
      doctorId: doctorId,
      doctorName: doctorName,
    );
    final index = queue.indexWhere((app) => app.id == appointment.id);
    return index >= 0 ? index + 1 : -1;
  }

  static int estimateWaitMinutes(int position,
      {int averageConsultationMinutes = 15}) {
    if (position <= 1) return 0;
    return (position - 1) * averageConsultationMinutes;
  }

  static String estimateWaitTimeText(int position,
      {int averageConsultationMinutes = 15}) {
    final minutes = estimateWaitMinutes(position,
        averageConsultationMinutes: averageConsultationMinutes);
    if (minutes <= 0) return 'Now';
    if (minutes < 60) return '$minutes min';
    final hours = minutes ~/ 60;
    final remainder = minutes % 60;
    return remainder == 0 ? '${hours}h' : '${hours}h ${remainder}m';
  }

  String get displayStatus {
    final low = status.toLowerCase();
    if (low == completed) return 'Completed';
    if (low == cancelled) return 'Cancelled';
    if (low == skipped) return 'Skipped';
    if (isMissed) return 'Missed';
    if (low == checkedIn) return 'Checked In';
    if (low == pending) return 'Pending';
    return _capitalizeStatus(status);
  }

  @override
  List<Object?> get props => [
        id,
        patientName,
        date,
        timeSlot,
        doctorName,
        status,
        patientId,
        doctorId,
        reason,
        isCheckedIn,
      ];

  factory Appointment.fromJson(Map<String, dynamic> json) {
    final dateValue = json['date'] ??
        json['dateTime'] ??
        json['appointment_date'] ??
        json['appointmentDate'];
    final parsedDate = dateValue != null
        ? DateTime.parse(dateValue.toString()).toLocal()
        : DateTime.now().toLocal();

    final rawIsCheckedIn =
        json['isCheckedIn'] ?? json['checked_in'] ?? json['is_checked_in'];
    final rawStatus = json['status'] ?? json['state'] ?? json['statusText'];
    final mappedStatus = normalizeStatus(
      rawStatus,
      isCheckedIn: parseCheckedInFlag(rawIsCheckedIn),
    );
    final isCheckedIn = effectiveCheckedIn(rawIsCheckedIn, mappedStatus);

    return Appointment(
      id: json['id']?.toString() ?? '',
      patientName: json['patientName'] ?? json['patient_id']?.toString() ?? '',
      date: parsedDate,
      timeSlot: json['timeSlot'] ?? json['time'] ?? '',
      doctorName: json['doctorName'] ?? "Dr. Selam Mulat",
      status: mappedStatus,
      patientId:
          json['patientId']?.toString() ?? json['patient_id']?.toString(),
      doctorId: json['doctorId']?.toString() ?? json['doctor_id']?.toString(),
      reason: json['reason']?.toString() ?? '',
      isCheckedIn: isCheckedIn,
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
      if (patientId != null) 'patientId': patientId,
      if (doctorId != null) 'doctorId': doctorId,
      'isCheckedIn': isCheckedIn ? 1 : 0,
    };
  }

  Map<String, dynamic> toJson() {
    return toLocalJson();
  }

  Map<String, dynamic> toApiJson() {
    return {
      if (patientId != null) 'patientId': patientId,
      'appointmentDate': date.toIso8601String().split('T')[0],
      'appointmentTime': timeSlot,
      'reason': reason,
    };
  }

  Appointment copyWith({
    String? id,
    String? patientName,
    DateTime? date,
    String? timeSlot,
    String? doctorName,
    String? status,
    String? patientId,
    String? doctorId,
    String? reason,
    bool? isCheckedIn,
  }) {
    return Appointment(
      id: id ?? this.id,
      patientName: patientName ?? this.patientName,
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
      doctorName: doctorName ?? this.doctorName,
      status: status ?? this.status,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      reason: reason ?? this.reason,
      isCheckedIn: isCheckedIn ?? this.isCheckedIn,
    );
  }
}
