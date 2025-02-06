import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/attendance_model.dart';
import '../services/firestore_service.dart';

class TeacherDashboard extends StatefulWidget {
  final UserModel user;

  const TeacherDashboard({Key? key, required this.user}) : super(key: key);

  @override
  _TeacherDashboardState createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  final FirestoreService _firestoreService = FirestoreService();
  String? _selectedClassId;
  List<UserModel> _students = [];
  List<AttendanceModel> _attendanceRecords = [];

  @override
  void initState() {
    super.initState();
    // You might want to fetch available classes here
  }

  void _fetchClassAttendance() async {
    if (_selectedClassId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a class')),
      );
      return;
    }

    try {
      // Fetch students for the selected class
      final students = await _firestoreService.getStudentsForClass(_selectedClassId!);

      // Fetch attendance records
      final attendanceStream = _firestoreService.getClassAttendance(_selectedClassId!);

      attendanceStream.listen((records) {
        setState(() {
          _students = students;
          _attendanceRecords = records;
        });
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching attendance: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              hint: Text('Select Class'),
              value: _selectedClassId,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedClassId = newValue;
                });
                _fetchClassAttendance();
              },
              items: [
                // Populate with actual class IDs
                DropdownMenuItem(child: Text('Class A'), value: 'classA'),
                DropdownMenuItem(child: Text('Class B'), value: 'classB'),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: _buildAttendanceList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceList() {
    if (_selectedClassId == null) {
      return Center(child: Text('Select a class to view attendance'));
    }

    if (_attendanceRecords.isEmpty) {
      return Center(child: Text('No attendance records'));
    }

    return ListView.builder(
      itemCount: _students.length,
      itemBuilder: (context, index) {
        final student = _students[index];
        final attendance = _attendanceRecords.firstWhere(
              (record) => record.studentUid == student.uid,
          orElse: () => AttendanceModel(
            id: '',
            studentUid: student.uid,
            studentName: student.name,
            timestamp: DateTime.now(),
            classId: _selectedClassId!,
          ),
        );

        return ListTile(
          title: Text(student.name),
          trailing: Text(
            attendance.id.isNotEmpty
                ? 'Present (${attendance.timestamp.toString().split(' ')[0]})'
                : 'Absent',
            style: TextStyle(
              color: attendance.id.isNotEmpty ? Colors.green : Colors.red,
            ),
          ),
        );
      },
    );
  }
}