import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imbuelight_stair_controller_mobile_app/controllers/bluetooth_controller.dart';
import 'package:imbuelight_stair_controller_mobile_app/controllers/timer_controller.dart';
import 'package:imbuelight_stair_controller_mobile_app/enums/enums.dart';
import 'package:imbuelight_stair_controller_mobile_app/methods/font_style.dart';

class ControllerPage extends StatelessWidget {
  ControllerPage({super.key});

  // final BluetoothController bc =
  final TimerController tc = Get.put(TimerController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BluetoothController>(
        init: BluetoothController(),
        builder: ((controller) {
          return Scaffold(
            backgroundColor: Color(AppColor.background.value),
            body: SafeArea(
                child: SingleChildScrollView(
              child: Column(children: [
                Row(
                  children: [
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(47, 0, 255, 255),
                          borderRadius: BorderRadius.circular(50)),
                      child: IconButton(
                        onPressed: () async => {
                          await controller.disconnectionWithDevice(
                              controller.currentDevice),
                          Get.back(),
                        },
                        icon: const Icon(Icons.arrow_back),
                        color: Colors.white,
                        iconSize: 30.0,
                      ),
                    ),
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Obx(
                      () => Text(
                        "${controller.nameOfDevice}",
                        style: fontStyle(Weight.bold, 23, Colors.white, true),
                      ),
                    )),
                Obx(() => Text(
                      controller.sub.toString(),
                      style: fontStyle(Weight.bold, 21, Colors.white, true),
                    )),
                Obx(() => Text(tc.subscription.toString(),
                    style: fontStyle(Weight.bold, 21, Colors.white, true))),
                //     style: fontStyle(Weight.bold, 12, Colors.white, true))),
                ElevatedButton(
                    onPressed: () => controller.sendValueToSensor(),
                    child: Text('Send',
                        style: fontStyle(Weight.bold, 41, Colors.white, true)))
              ]),
            )),
          );
        }));
  }
}
