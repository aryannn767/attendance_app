import '../models/attendance.dart';
import '../models/student.dart';

class AttendanceService {
  List<Attendance> _attendanceList = [];
  List<Student> _students = [];

  Future<List<Attendance>> getAttendanceList() async {
    // In a real app, this would fetch data from an API or database
    return _attendanceList;
  }

  Future<void> markAttendance(String rfidUid, String bluetoothUuid) async {
    // Validate both RFID and Bluetooth UUID
    final student = _students.firstWhere(
          (s) => s.rfidUid == rfidUid && s.bluetoothUuid == bluetoothUuid,
      orElse: () => throw Exception('Student not found'),
    );

    final attendance = Attendance(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      studentId: student.id,
      timestamp: DateTime.now(),
      isPresent: true,
    );

    _attendanceList.add(attendance);
    // Add API call to save attendance
  }

  List<Attendance> getAttendanceByDate(DateTime date) {
    return _attendanceList.where((a) {
      return a.timestamp.year == date.year &&
          a.timestamp.month == date.month &&
          a.timestamp.day == date.day;
    }).toList();
  }
}