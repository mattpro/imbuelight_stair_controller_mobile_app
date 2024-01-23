import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:imbuelight_stair_controller_mobile_app/controllers/bluetooth_controller.dart';
import 'package:imbuelight_stair_controller_mobile_app/controllers/timer_controller.dart';
import 'package:imbuelight_stair_controller_mobile_app/enums/enums.dart';
import 'package:imbuelight_stair_controller_mobile_app/methods/font_style.dart';
import 'package:imbuelight_stair_controller_mobile_app/widges/switch_button_widget.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SensorPage extends StatelessWidget {
  const SensorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final BluetoothController bc = Get.put(BluetoothController());
    final TimerController tc = Get.put(TimerController());
    Rx<int> _value = bc.distanceValue.value.obs;
    Rx<int> _lightIntesityValue = bc.lightIntensityValue.value.obs;
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
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        SizedBox(width: 12),
                        Container(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(47, 0, 255, 255),
                              borderRadius: BorderRadius.circular(50)),
                          child: IconButton(
                            onPressed: () async => {
                              await bc
                                  .disconnectionWithDevice(bc.currentDevice),
                              Get.back(),
                            },
                            icon: Icon(Icons.arrow_back),
                            color: Colors.white,
                            iconSize: 30.0,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: Obx(
                          () => Text(
                            "${bc.nameOfDevice}",
                            style:
                                fontStyle(Weight.bold, 25, Colors.white, true),
                          ),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SwitchButtonWidget(
                          typoOfButton: TypeOfButton.ledSignalization,
                        ),
                        SwitchButtonWidget(
                          typoOfButton: TypeOfButton.distance,
                        ),
                        SwitchButtonWidget(
                          typoOfButton: TypeOfButton.lightIntensity,
                        ),
                      ],
                    ),
                    SizedBox(height: 35),

                    // Obx(() => Text(tc.subscription.toString(),
                    //     style: fontStyle(Weight.bold, 12, Colors.white, true))),
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

                            // ignore: invalid_use_of_protected_member
                            child: Obx(() => tc.subscription.value.isNotEmpty
                                ? bulpIconDisplay(tc.subscription[0])
                                : Image(
                                    image:
                                        AssetImage('assets/lightbulp_off.png'),
                                    height: 80,
                                  )))),
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      AppLocalizations.of(context)!.distance,
                      style: fontStyle(Weight.bold, 22, Colors.white, true),
                    ),
                    SizedBox(height: 15),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(AppLocalizations.of(context)!.sensorReading,
                              style: fontStyle(
                                  Weight.bold, 16, Colors.white, true)),
                          Obx(() => Text(
                              tc.currentSensorValue <= 200
                                  ? '${tc.currentSensorValue}' + " cm"
                                  : AppLocalizations.of(context)!.moreThan200,
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
                                      AppLocalizations.of(context)!.stairWidth,
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
                                        onChangeEnd: (double value) async => {
                                          await bc.changeValue(
                                              TypeOfSetValue.distance,
                                              value.toInt())
                                        },
                                        label: '${bc.distanceValue.value}',
                                        min: 10.0,
                                        max: 200.0,
                                      ),
                                    )),
                              ]),
                        ),
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.lightIntensity,
                      style: fontStyle(Weight.bold, 22, Colors.white, true),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(AppLocalizations.of(context)!.sensorReading,
                                style: fontStyle(
                                    Weight.bold, 16, Colors.white, true)),
                            Obx(() => Text("${tc.currentIntensityValue} %",
                                style: fontStyle(
                                    Weight.bold, 16, Colors.white, true)))
                          ],
                        ),
                        Column(
                          children: [
                            Text(AppLocalizations.of(context)!.setpoint,
                                style: fontStyle(
                                    Weight.bold, 16, Colors.white, true)),
                            Obx(() => Text(
                                "${(_lightIntesityValue.value * 100 / 4095).round()} %",
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
                                  await bc.changeValue(
                                      TypeOfSetValue.lightIntensity,
                                      value.toInt());
                                },
                                appearance: CircularSliderAppearance(
                                    customWidths: CustomSliderWidths(
                                        handlerSize: 20,
                                        trackWidth: 16,
                                        progressBarWidth: 18),
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
