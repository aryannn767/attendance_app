import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:uuid/uuid.dart';
import 'firestore_service.dart';

class BluetoothService {
  final FirestoreService _firestoreService = FirestoreService();
  String? generatedUuid;

  Future<void> initializeBluetooth() async {
    // Check Bluetooth support
    if (!await FlutterBluePlus.isAvailable) {
      print("Bluetooth not supported");
      return;
    }

    // Request Bluetooth permissions
    await FlutterBluePlus.turnOn();
  }

  String generateUuid() {
    generatedUuid = Uuid().v4();
    return generatedUuid!;
  }

  Future<void> startScanning(String userUid) async {
    if (generatedUuid == null) {
      generateUuid();
    }

    // Update user's UUID in Firestore
    await _firestoreService.updateUserUuid(userUid, generatedUuid!);

    // Start scanning for nearby devices
    FlutterBluePlus.onScanResults.listen((results) {
      for (ScanResult result in results) {
        // Check if scanned device matches expected criteria
        _processScannedDevice(result);
      }
    });

    await FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 30),
    );
  }

  void _processScannedDevice(ScanResult result) {
    // Implement logic to verify device/UUID
    // This is a placeholder - you'll need to customize based on your specific beacon protocol
    if (result.advertisementData.manufacturerData.isNotEmpty) {
      // Extract and process UUID from advertisement data
      print('Found device: ${result.device.name}');
    }
  }

  Future<void> stopScanning() async {
    await FlutterBluePlus.stopScan();
  }

  Future<bool> checkUuidMatch(String rfidUid) async {
    return await _firestoreService.validateUuidForRfid(rfidUid);
  }
}