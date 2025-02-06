import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceModel {
  final String id;
  final String studentUid;
  final String studentName;
  final DateTime timestamp;
  final String classId;

  AttendanceModel({
    required this.id,
    required this.studentUid,
    required this.studentName,
    required this.timestamp,
    required this.classId,
  });

  factory AttendanceModel.fromFirestore(Map<String, dynamic> data) {
    return AttendanceModel(
      id: data['id'],
      studentUid: data['studentUid'],
      studentName: data['studentName'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      classId: data['classId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'studentUid': studentUid,
      'studentName': studentName,
      'timestamp': timestamp,
      'classId': classId,
    };
  }
}