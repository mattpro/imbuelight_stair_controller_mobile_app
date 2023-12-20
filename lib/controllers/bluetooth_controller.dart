import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:imbuelight_stair_controller_mobile_app/pages/sensor_page.dart';

class BluetoothController extends GetxController {
  AsciiCodec ascii = AsciiCodec();
  RxString nameOfDevice = ''.obs;
  RxList<int> sub = [1].obs;
  Rx<int> distanceValue = 0.obs;
  RxInt currentDistanceValue = 1.obs;
  Rx<int> lightIntensityValue = 0.obs;
  Rx<int> currentlightIntensityValue = 0.obs;
  Rx<int> isEnableDistance = 0.obs;
  late BluetoothCharacteristic _characteristicToWrite;
  late BluetoothDevice currentDevice;
  Rx<bool> isBluetoothOn = false.obs;

  checkBluetooth() {
    FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      if (state == BluetoothAdapterState.on) {
        isBluetoothOn = true.obs;
      } else {
        isBluetoothOn = false.obs;
      }
    });
  }

  Future<void> scanDevices() async {
    if (FlutterBluePlus.isScanningNow == false) {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 8));
    }
    // listDeviceWidget(200);
  }

  validationSensors(AsyncSnapshot<List<ScanResult>> snapshot) {
    List<ScanResult> imbue = snapshot.data!
        .where((i) => i.device.platformName.isNotEmpty &&
                i.device.platformName.length > 17
            ? i.device.platformName.substring(0, 17).trim() ==
                "Imbue Light Move"
            : false)
        .toList();

    return imbue;
  }

  validationControllers(AsyncSnapshot<List<ScanResult>> snapshot) {
    List<ScanResult> imbue = snapshot.data!
        .where((i) => i.device.platformName.isNotEmpty &&
                i.device.platformName.length > 17
            ? i.device.platformName.substring(0, 17).trim() ==
                "Imbue Light Stair"
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
          if (utf8.decode(value)[0] == "I") {
            nameOfDevice = RxString(utf8.decode(value));
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
            // const Duration(milliseconds: 1000);

            sub.value = Uint8List.fromList(value);

            currentDistanceValue.value = sub[1] * 256 + sub[2];
            currentlightIntensityValue.value =
                sub[3] > 250 ? 0 : sub[3] * 256 + sub[4];
            distanceValue.value = sub[8] * 256 + sub[9];
            int operator = 258;
            Uint8List list = Uint8List.fromList([operator >> 8, operator]);
            print(list[1]);

            lightIntensityValue.value = sub[10] * 256 + sub[11];
            isEnableDistance.value = sub[5];
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
    Get.to(() => SensorPage(),
        transition: Transition.rightToLeftWithFade,
        duration: const Duration(milliseconds: 500));
    // return [sub, name];
  }

  disconnectionWithDevice(BluetoothDevice device) async {
    await device.disconnect();
    scanDevices();
  }

  // quickConnectionWithDevice(BluetoothDevice device, state) async {
  //   await device.connect();
  //   await readDeviceName(device);
  //   currentDevice = device;
  //   await device.disconnect();
  // }

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
