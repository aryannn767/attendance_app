import 'package:flutter/material.dart';
import '../models/attendance.dart';

class AttendanceCard extends StatelessWidget {
  final Attendance attendance;

  const AttendanceCard({
    super.key,
    required this.attendance,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text('Student ID: ${attendance.studentId}'),
        subtitle: Text(
          'Time: ${attendance.timestamp.toString().split('.')[0]}',
        ),
        trailing: Icon(
          attendance.isPresent ? Icons.check_circle : Icons.cancel,
          color: attendance.isPresent ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
