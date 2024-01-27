import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imbuelight_stair_controller_mobile_app/controllers/bluetooth_controller.dart';
import 'package:imbuelight_stair_controller_mobile_app/enums/enums.dart';

class ControllerPage extends StatelessWidget {
  ControllerPage({super.key});

  // final BluetoothController bc =
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BluetoothController>(
        init: BluetoothController(),
        builder: ((controller) {
          return Scaffold(
            backgroundColor: Color(AppColor.background.value),
            body: SafeArea(child: SingleChildScrollView()),
          );
        }));
  }
}
