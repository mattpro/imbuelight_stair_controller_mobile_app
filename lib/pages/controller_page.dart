import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imbuelight_stair_controller_mobile_app/cards/stairs_card.dart';
import 'package:imbuelight_stair_controller_mobile_app/controllers/bluetooth_controller.dart';
import 'package:imbuelight_stair_controller_mobile_app/controllers/timer_controller.dart';
import 'package:imbuelight_stair_controller_mobile_app/enums/enums.dart';
import 'package:imbuelight_stair_controller_mobile_app/methods/font_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.numberOfStairs,
                        style: fontStyle(Weight.bold, 20, Colors.white, true)),
                    SizedBox(
                      height: 80,
                      width: 50,
                      child: ListWheelScrollView.useDelegate(
                        itemExtent: 30,
                        childDelegate: ListWheelChildBuilderDelegate(
                            childCount: 23,
                            builder: (context, index) =>
                                StairsCard(index: index + 1)),
                        //     controller: FixedExtentScrollController(
                        // initialItem: currentItem),
                        physics: const FixedExtentScrollPhysics(),
                        overAndUnderCenterOpacity: 0.5,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                    onPressed: () => controller.sendValueToSensor(),
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Color(0xFF131f6f))),
                    child: Text('Save',
                        style: fontStyle(Weight.bold, 25, Colors.white, true)))
              ]),
            )),
          );
        }));
  }
}
