class Attendance {
  final String id;
  final String studentId;
  final DateTime timestamp;
  final bool isPresent;

  Attendance({
    required this.id,
    required this.studentId,
    required this.timestamp,
    required this.isPresent,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'],
      studentId: json['studentId'],
      timestamp: DateTime.parse(json['timestamp']),
      isPresent: json['isPresent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'timestamp': timestamp.toIso8601String(),
      'isPresent': isPresent,
    };
  }
}
