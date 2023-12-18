import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imbuelight_stair_controller_mobile_app/controllers/bluetooth_controller.dart';
import 'package:imbuelight_stair_controller_mobile_app/controllers/timer_controller.dart';
import 'package:imbuelight_stair_controller_mobile_app/enums/enums.dart';
import 'package:imbuelight_stair_controller_mobile_app/methods/font_style.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class SensorPage extends StatelessWidget {
  const SensorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final BluetoothController c = Get.put(BluetoothController());
    final TimerController tc = Get.put(TimerController());
    Rx<int> _value = c.distanceValue.value.obs;
    Rx<int> _lightIntesityValue = c.lightIntensityValue.value.obs;
    Rx<int> _lightIntesityValuePerPercent =
        (c.lightIntensityValue.value * 100 / 4095).round().obs;

    tc.onReady();

    return GetBuilder<BluetoothController>(
        init: BluetoothController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: Color(AppColor.background.value),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: Obx(
                          () => Text(
                            "${c.nameOfDevice}",
                            style:
                                fontStyle(Weight.bold, 25, Colors.white, true),
                          ),
                        )),
                    Obx(() => Text(tc.subscription.toString(),
                        style: fontStyle(Weight.bold, 12, Colors.white, true))),
                    // Obx(() => Text('${c.lightIntensityValue.value}',
                    //     style: fontStyle(Weight.bold, 12, Colors.white, true))),
                    Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(74, 0, 255, 255),
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            )),
                        child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Obx(() => tc.subscription.value.isNotEmpty
                                ? bulpIconDisplay(tc.subscription[0])
                                : Image(
                                    image:
                                        AssetImage('assets/lightbulp_off.png'),
                                    height: 80,
                                  )))),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Odczyt z czujnika: ",
                              style: fontStyle(
                                  Weight.bold, 16, Colors.white, true)),
                          Obx(() => Text(
                              '${tc.currentSensorValue.value}' + " cm",
                              // tc.currentSensorValue <= 200
                              //     ? '${tc.currentSensorValue}' + " cm"
                              //     : "więcej niż 200 cm",
                              style: fontStyle(
                                  Weight.bold, 16, Colors.white, true))),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 15.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color.fromARGB(47, 0, 255, 255),
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            )),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Szerokość schodów : ',
                                      style: fontStyle(
                                          Weight.bold, 22, Colors.white, true),
                                    ),
                                    Obx(() => Text('${_value.round()} cm',
                                        style: fontStyle(Weight.bold, 21,
                                            Colors.white, true)))
                                  ],
                                ),
                                SizedBox(height: 20),
                                Obx(() => SizedBox(
                                      height: 50,
                                      child: Slider(
                                        value: _value.value.toDouble(),
                                        onChanged: (value) => {
                                          _value.value = value.toInt(),
                                        },
                                        onChangeEnd: (double value) async {
                                          await c.changedDistance(value);
                                        },
                                        label: '${c.distanceValue.value}',
                                        min: 10.0,
                                        max: 200.0,
                                      ),
                                    )),
                              ]),
                        ),
                      ),
                    ),
                    Text(
                      'Natężenie światła',
                      style: fontStyle(Weight.bold, 22, Colors.white, true),
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            Text("Odczyt z czujnika: ",
                                style: fontStyle(
                                    Weight.bold, 16, Colors.white, true)),
                            Obx(() => Text("${tc.currentIntensityValue} %",
                                style: fontStyle(
                                    Weight.bold, 16, Colors.white, true)))
                          ],
                        ),
                        Column(
                          children: [
                            Text("Wartość zadana: ",
                                style: fontStyle(
                                    Weight.bold, 16, Colors.white, true)),
                            Obx(() => Text(
                                "${_lightIntesityValuePerPercent.value} %",
                                style: fontStyle(
                                    Weight.bold, 16, Colors.white, true)))
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image(width: 30, image: AssetImage('assets/moon.png')),
                        Container(
                          height: 230,
                          width: 230,
                          child: Obx(() => SleekCircularSlider(
                                initialValue:
                                    _lightIntesityValue.value.toDouble(),
                                min: 0,
                                max: 4095,
                                onChange: (value) async {
                                  _lightIntesityValue.value = value.toInt();
                                },
                                onChangeEnd: (value) async {
                                  await c.changedLightIntesity(value);
                                },
                                appearance: CircularSliderAppearance(
                                    customWidths: CustomSliderWidths(
                                        handlerSize: 16,
                                        trackWidth: 10,
                                        progressBarWidth: 10),
                                    infoProperties: InfoProperties(
                                        mainLabelStyle:
                                            TextStyle(fontSize: 0))),
                              )),
                        ),
                        Image(width: 30, image: AssetImage('assets/sun.png'))
                      ],
                    ),
                    SizedBox(height: 20)

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

Image bulpIconDisplay(int subscription) {
  final String icon;
  if (subscription == 1) {
    icon = 'assets/lightbulp_on.png';
  } else {
    icon = 'assets/lightbulp_off.png';
  }

  return Image(
    image: AssetImage(icon),
    height: 80,
  );
}

Widget_lightIcon(height) {
  String icon = 'assets/lightbulp_on.png';

  return Image(
    image: AssetImage(icon),
    height: height,
  );
}
