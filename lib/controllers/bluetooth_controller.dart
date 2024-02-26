import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:imbuelight_stair_controller_mobile_app/enums/enums.dart';
import 'package:imbuelight_stair_controller_mobile_app/pages/controller_page.dart';
import 'package:imbuelight_stair_controller_mobile_app/pages/sensor_page.dart';

class BluetoothController extends GetxController {
  RxString nameOfDevice = ''.obs;
  RxList<int> sub = [1].obs;
  Rx<int> distanceValue = 0.obs;
  RxInt currentDistanceValue = 1.obs;
  Rx<int> lightIntensityValue = 0.obs;
  Rx<int> currentlightIntensityValue = 0.obs;
  Rx<int> isEnableDistance = 0.obs;
  Rx<int> isEnableLightIntensity = 0.obs;
  Rx<int> isEnableLedSignalization = 0.obs;
  late BluetoothCharacteristic _characteristicToWrite;
  late BluetoothDevice currentDevice;
  Rx<bool> isBluetoothOn = false.obs;
  List<int> reciveValueList = [];

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
            // print(value.toString());
            sub.value = Uint8List.fromList(value);
            // print("List ${sub}");

            currentDistanceValue.value =
                convertValueTo16Int(TypeOfGetValue.distance, value);
            currentlightIntensityValue.value =
                convertValueTo16Int(TypeOfGetValue.lightIntensity, value);
            distanceValue.value =
                convertValueTo16Int(TypeOfGetValue.thresholdDistanse, value);
            lightIntensityValue.value = convertValueTo16Int(
                TypeOfGetValue.thresholdlightIntensity, value);
            isEnableDistance.value = sub[5];
            isEnableLightIntensity.value = sub[6];
            isEnableLedSignalization.value = sub[7];
            reciveValueList = [
              sub[5],
              sub[6],
              sub[7],
              sub[8],
              sub[9],
              sub[10],
              sub[11],
            ];
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

  connectionWithDevice(
      BluetoothDevice device, state, TypeOfDevice typeOfDevice) async {
    await device.connect();
    await readDeviceValue(device);
    await readDeviceName(device);
    currentDevice = device;
    Get.to(
        () => typeOfDevice == TypeOfDevice.sensor
            ? const SensorPage()
            : ControllerPage(),
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

  changeValue(TypeOfSetValue typeOfValue, int value) async {
    Uint8List convertToUint8 = Uint8List.fromList([value >> 8, value]);
    List<int> sendList = reciveValueList;
    switch (typeOfValue) {
      case TypeOfSetValue.enableDistance:
        sendList[0] = value;
        break;
      case TypeOfSetValue.enablelightIntesity:
        sendList[1] = value;
        break;
      case TypeOfSetValue.enableLedSignalization:
        sendList[2] = value;
        break;
      case TypeOfSetValue.distance:
        sendList[3] = convertToUint8[0];
        sendList[4] = convertToUint8[1];
        break;
      case TypeOfSetValue.lightIntensity:
        sendList[5] = convertToUint8[0];
        sendList[6] = convertToUint8[1];
        break;
      default:
    }

    await _characteristicToWrite.write(sendList);
  }

  List<String> toHex(List<int> value) {
    List<String> hexList = [];

    for (int i = 0; i < value.length; i++) {
      hexList.add(value[i].toRadixString(16));
    }
    return hexList;
  }

  int convertValueTo16Int(TypeOfGetValue typeofValue, List<int> value) {
    final List<int> list;
    switch (typeofValue) {
      case TypeOfGetValue.distance:
        list = [value[2], value[1]];
        break;
      case TypeOfGetValue.lightIntensity:
        list = [value[4], value[3]];
        break;
      case TypeOfGetValue.thresholdDistanse:
        list = [value[9], value[8]];
        break;
      case TypeOfGetValue.thresholdlightIntensity:
        list = [value[11], value[10]];
        break;
      default:
        list = [value[2], value[1]];
    }
    ByteData byteData = ByteData.sublistView(
      Uint8List.fromList(list),
    );

    int valueInInt16 = byteData.getInt16(0, Endian.little);

    return valueInInt16;
  }

  sendValueToSensor() async {
    await _characteristicToWrite.write([0xDE, 0x01, 8]);

    await _characteristicToWrite.write([0xAA, 0x02]);
  }
}
