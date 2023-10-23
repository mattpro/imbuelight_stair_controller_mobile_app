import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imbuelight_stair_controller_mobile_app/controllers/bluetooth_controller.dart';
import 'package:imbuelight_stair_controller_mobile_app/enums/enums.dart';
import 'package:imbuelight_stair_controller_mobile_app/widges/devices_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BluetoothController>(
        init: BluetoothController(),
        builder: (controller) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const DevicesList(),
                    ElevatedButton(
                        onPressed: () => {
                              controller.scanDevices(),
                            },
                        child: const Text("Scan")),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
