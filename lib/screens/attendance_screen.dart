import 'package:flutter/material.dart';
import '../models/attendance_model.dart';
import '../services/firestore_service.dart';
import 'package:intl/intl.dart';

class AttendanceScreen extends StatefulWidget {
  final String classId;

  const AttendanceScreen({Key? key, required this.classId}) : super(key: key);

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<AttendanceModel> _attendanceRecords = [];

  @override
  void initState() {
    super.initState();
    _fetchAttendanceRecords();
  }

  void _fetchAttendanceRecords() {
    _firestoreService.getClassAttendance(widget.classId).listen((records) {
      setState(() {
        _attendanceRecords = records;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Records'),
      ),
      body: ListView.builder(
        itemCount: _attendanceRecords.length,
        itemBuilder: (context, index) {
          final record = _attendanceRecords[index];
          return ListTile(
            title: Text(record.studentName),
            subtitle: Text(
              'Date: ${DateFormat('yyyy-MM-dd HH:mm').format(record.timestamp)}',
            ),
          );
        },
      ),
    );
  }
}