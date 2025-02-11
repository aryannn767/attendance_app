import 'package:flutter/material.dart';
import '../../services/attendance_service.dart';
import '../../models/attendance.dart';
import '../../widgets/attendance_card.dart';

class TeacherHomeScreen extends StatefulWidget {
  const TeacherHomeScreen({super.key});

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  final AttendanceService _attendanceService = AttendanceService();
  List<Attendance> _attendanceList = [];

  @override
  void initState() {
    super.initState();
    // Load initial attendance data
    _loadAttendanceData();
  }

  Future<void> _loadAttendanceData() async {
    // Get attendance data from service
    final attendanceData = await _attendanceService.getAttendanceList();
    setState(() {
      _attendanceList = attendanceData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Management'),
        actions: [
          // Add refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAttendanceData,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _attendanceList.length,
        itemBuilder: (context, index) {
          final attendance = _attendanceList[index];
          return AttendanceCard(attendance: attendance);
        },
      ),
    );
  }
}