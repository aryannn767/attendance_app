import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/bluetooth_service.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  final BluetoothService _bluetoothService = Get.put(BluetoothService()); // Use GetX for state management
  String _status = 'Ready';

  Future<void> _toggleAdvertising() async {
    try {
      if (_bluetoothService.isAdvertising.value) {
        await _bluetoothService.stopAdvertising();
      } else {
        String uuid = "12345678-1234-5678-1234-567812345678"; // Replace with your UUID
        await _bluetoothService.startAdvertising(uuid);
      }
    } catch (e) {
      setState(() => _status = 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Attendance')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() { // Observe the advertising state
              bool isAdvertising = _bluetoothService.isAdvertising.value;
              _status = isAdvertising ? "Broadcasting UUID" : "Stopped Broadcasting";
              return Text(_status, style: const TextStyle(fontSize: 16));
            }),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleAdvertising,
              child: Obx(() => Text(_bluetoothService.isAdvertising.value ? 'Stop Broadcasting' : 'Start Broadcasting')),
            ),
          ],
        ),
      ),
    );
  }
}
