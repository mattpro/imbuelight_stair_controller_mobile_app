import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:imbuelight_stair_controller_mobile_app/pages/sensor_page.dart';

class BluetoothController extends GetxController {
  AsciiCodec ascii = AsciiCodec();
  RxString nameOfDevice = ''.obs;
  RxString sub = ''.obs;
  Rx<double> distanceValue = 0.0.obs;
  Rx<double> lightIntensityValue = 0.0.obs;
  late BluetoothCharacteristic _characteristicToWrite;
  late BluetoothDevice currentDevice;

  Future<void> scanDevices() async {
    if (FlutterBluePlus.isScanningNow == false) {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 8));
    }
    // listDeviceWidget(200);
  }

  validationSensors(AsyncSnapshot<List<ScanResult>> snapshot) {
    List<ScanResult> imbue = snapshot.data!
        .where((i) => i.device.platformName.isNotEmpty
            ? i.device.platformName.substring(0, 16) == "Imbue Light Move"
            : false)
        .toList();

    return imbue;
  }

  validationControllers(AsyncSnapshot<List<ScanResult>> snapshot) {
    List<ScanResult> imbue = snapshot.data!
        .where((i) => i.device.platformName.isNotEmpty
            ? i.device.platformName.substring(0, 17) == "Imbue Light Stair"
            : false)
        .toList();

    return imbue;
  }

  connectionState(device, state) {
    bool isConnect =
        device.connectionState == BluetoothConnectionState.connected;
    return isConnect;
  }

  readDeviceName(device) async {
    List<BluetoothService> services = await device.discoverServices();
    for (var service in services) {
      var characteristics = service.characteristics;
      for (BluetoothCharacteristic c in characteristics) {
        if (c.isNotifying) {
          await c.setNotifyValue(true);
        }
        if (c.properties.read) {
          List<int> value = await c.read();
          if (String.fromCharCodes(value)[0] == "I") {
            // Iterable<int> name = value;
            nameOfDevice = RxString(String.fromCharCodes(value));
          }
        }
        if (c.properties.write) {
          _characteristicToWrite = c;
        }
      }
    }
  }

  readDeviceValue(device) async {
    List<BluetoothService> services = await device.discoverServices();
    for (var service in services) {
      var characteristics = service.characteristics;
      for (BluetoothCharacteristic c in characteristics) {
        if (c.isNotifying) {
          await c.setNotifyValue(true);
        }
        if (c.properties.notify) {
          await c.setNotifyValue(true);
          final subscription = c.onValueReceived.listen((value) {
            const Duration(milliseconds: 1000);
            sub = RxString(String.fromCharCodes(value));
            distanceValue = RxDouble(
                double.parse(String.fromCharCodes(value.sublist(6, 9)).trim()));
            lightIntensityValue = RxDouble(double.parse(
                String.fromCharCodes(value.sublist(15, 19)).trim()));
          });

          device.connectionState.listen((BluetoothConnectionState state) {
            if (state == BluetoothConnectionState.disconnected) {
              // stop listening to characteristic
              subscription.cancel();
            }
          });
        }
      }
    }
  }

  refreshValue() {
    sub.refresh();
    nameOfDevice.refresh();
    // distanceValue.refresh();
  }

  connectionWithDevice(BluetoothDevice device, state) async {
    await device.connect();
    await readDeviceValue(device);
    await readDeviceName(device);
    currentDevice = device;
    Get.to(() => SensorPage());
    // return [sub, name];
  }

  changedDistance(double value) async {
    var dataToSend = ascii.encode(value < 100.00
        ? 'd0' + value.round().toString()
        : 'd' + value.round().toString());

    await _characteristicToWrite.write(dataToSend);
  }

  changedLightIntesity(double value) async {
    String formatData = 'l0200';
    if (value < 100.00) {
      formatData = 'l00' + value.round().toString();
    } else if (value >= 100 && value < 1000) {
      formatData = 'l0' + value.round().toString();
    } else {
      'l' + value.round().toString();
    }

    var dataToSend = ascii.encode(formatData);
    await _characteristicToWrite.write(dataToSend);
  }
}
