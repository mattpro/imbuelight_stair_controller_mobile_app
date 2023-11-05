import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imbuelight_stair_controller_mobile_app/controllers/bluetooth_controller.dart';
import 'package:imbuelight_stair_controller_mobile_app/controllers/timer_controller.dart';
import 'package:imbuelight_stair_controller_mobile_app/enums/enums.dart';
import 'package:imbuelight_stair_controller_mobile_app/methods/font_style.dart';

class SensorPage extends StatelessWidget {
  const SensorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final BluetoothController c = Get.put(BluetoothController());
    final TimerController tc = Get.put(TimerController());
    Rx<double> _value = c.distanceValue.value.obs;

    tc.onReady();

    return GetBuilder<BluetoothController>(
        init: BluetoothController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: Color(AppColor.background.value),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 50),
                        child: Obx(
                          () => Text(
                            "${c.nameOfDevice}",
                            style:
                                fontStyle(Weight.bold, 25, Colors.white, true),
                          ),
                        )),
                    Obx(() => Text(tc.subscription.value,
                        style: fontStyle(Weight.bold, 12, Colors.white, true))),
                    Obx(() => bulpIconDisplay(tc.subscription.value)),
                    Obx(() => Text('${_value.round()} cm',
                        style: fontStyle(Weight.bold, 12, Colors.white, true))),
                    Obx(() => SizedBox(
                          height: 50,
                          child: Slider(
                            value: _value.value,
                            onChanged: (value) => {
                              _value.value = value,
                            },
                            onChangeEnd: (double value) async {
                              await c.changedDistance(value);
                            },
                            label: '${c.distanceValue.value}',
                            min: 10.0,
                            max: 200.0,
                          ),
                        )),
                    // (IconButton(
                    //     onPressed: () async => await c.changedDistance(),
                    //     icon: const Icon(
                    //       Icons.favorite,
                    //       size: 50,
                    //     ))),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

Image bulpIconDisplay(String subscription) {
  String sensor = subscription.substring(0, 1);
  final String icon;
  if (sensor == "1") {
    icon = 'assets/lightbulp_on.png';
  } else {
    icon = 'assets/lightbulp_off.png';
  }

  return Image(
    image: AssetImage(icon),
    height: 50,
  );
}
