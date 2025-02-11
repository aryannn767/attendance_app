import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';
import 'package:get/get.dart';

class BluetoothService extends GetxController {
  final FlutterBlePeripheral blePeripheral = FlutterBlePeripheral();
  var isAdvertising = false.obs; // Observable advertising state

  Future<void> startAdvertising(String uuid) async {
    var advertisementData = AdvertiseData(
      includeDeviceName: true,
      serviceUuid: uuid,
    );

    await blePeripheral.start(advertiseData: advertisementData);
    isAdvertising.value = true; // Update state
  }

  Future<void> stopAdvertising() async {
    await blePeripheral.stop();
    isAdvertising.value = false; // Update state
  }
}
