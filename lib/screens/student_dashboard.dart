import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/bluetooth_service.dart';
import '../services/firestore_service.dart';
import '../models/attendance_model.dart';

class StudentDashboard extends StatefulWidget {
  final UserModel user;

  const StudentDashboard({Key? key, required this.user}) : super(key: key);

  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final BluetoothService _bluetoothService = BluetoothService();
  final FirestoreService _firestoreService = FirestoreService();
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _initializeBluetooth();
  }

  Future<void> _initializeBluetooth() async {
    await _bluetoothService.initializeBluetooth();
  }

  void _startAttendanceScanning() async {
    setState(() {
      _isScanning = true;
    });

    // Generate and broadcast UUID
    String uuid = _bluetoothService.generateUuid();

    try {
      // Start scanning for attendance
      await _bluetoothService.startScanning(widget.user.uid);

      // Optional: Show success dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Attendance scanning started')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error starting attendance: $e')),
      );
    } finally {
      setState(() {
        _isScanning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Implement logout functionality
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, ${widget.user.name}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isScanning ? null : _startAttendanceScanning,
              child: Text(_isScanning ? 'Scanning...' : 'Mark Attendance'),
            ),
          ],
        ),
      ),
    );
  }
}