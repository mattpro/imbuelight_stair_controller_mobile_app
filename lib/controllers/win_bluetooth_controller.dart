import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:win_ble/win_ble.dart';
import 'package:win_ble/win_file.dart';
// import 'package:win_ble_example/device_info.dart';

class WinBluetoothController extends GetxController {
  StreamSubscription? scanStream;
  StreamSubscription? connectionStream;
  StreamSubscription? bleStateStream;

  bool isScanning = false;
  BleState bleState = BleState.Unknown;

  void initialize() async {
    await WinBle.initialize(
      serverPath: await WinServer.path,
      enableLog: true,
    );
  }

  void initState() {
    initialize();
    // call winBLe.dispose() when done
    connectionStream = WinBle.connectionStream.listen((event) {
      print("Connection Event : " + event.toString());
    });

    // Listen to Scan Stream , we can cancel in onDispose()
    scanStream = WinBle.scanStream.listen((event) {
      final index =
          devices.indexWhere((element) => element.address == event.address);
      // Updating existing device
      if (index != -1) {
        final name = devices[index].name;
        devices[index] = event;
        // Putting back cached name
        if (event.name.isEmpty || event.name == 'N/A') {
          devices[index].name = name;
        }
      } else {
        devices.add(event);
      }
    });

    // Listen to Ble State Stream
    bleStateStream = WinBle.bleState.listen((BleState state) {
      bleState = state;
    });
  }

  String bleStatus = "";
  String bleError = "";

  List<BleDevice> devices = <BleDevice>[];
}
