import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imbuelight_stair_controller_mobile_app/controllers/button_controller.dart';
import 'package:imbuelight_stair_controller_mobile_app/controllers/bluetooth_controller.dart';
import 'package:imbuelight_stair_controller_mobile_app/enums/enums.dart';
import 'package:imbuelight_stair_controller_mobile_app/methods/font_style.dart';

// ignore: must_be_immutable
class SwitchButtonWidget extends StatelessWidget {
  TypeOfButton typoOfButton;

  SwitchButtonWidget({super.key, required this.typoOfButton});

  late IconData icon;

  late String info;

  late int turnOnOff;

  late TypeOfValue typeOfValue;

  @override
  Widget build(BuildContext context) {
    final BluetoothController bc = Get.put(BluetoothController());
    final ButtonController btnc = Get.put(ButtonController());
    switch (typoOfButton) {
      case TypeOfButton.ledSignalization:
        icon = Icons.lightbulb;
        info = 'Sygnalizacja\nLed';
        turnOnOff = bc.isEnableLedSignalization.value;
        typeOfValue = TypeOfValue.enableLedSignalization;
        break;
      case TypeOfButton.distance:
        icon = Icons.toggle_off_rounded;
        info = 'Mierzenie\ndystansu';
        turnOnOff = bc.isEnableDistance.value;
        typeOfValue = TypeOfValue.enableDistance;
        break;
      case TypeOfButton.lightIntesity:
        icon = Icons.light_mode_outlined;
        info = 'Natężenie\nświatła';
        turnOnOff = bc.isEnableLightIntensity.value;
        typeOfValue = TypeOfValue.enablelightIntesity;
      default:
        icon = Icons.light_mode_outlined;
    }
    btnc.changeColor(turnOnOff, typoOfButton);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          info,
          textAlign: TextAlign.center,
          style: fontStyle(Weight.bold, 14, Colors.white, true),
        ),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
              color: Color.fromARGB(47, 0, 255, 255),
              borderRadius: BorderRadius.circular(50)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Obx(() => IconButton(
                  onPressed: () => {
                    turnOnOff == 0 ? turnOnOff = 1 : turnOnOff = 0,
                    btnc.changeColor(turnOnOff, typoOfButton),
                    bc.changeValue(typeOfValue, turnOnOff)
                  },
                  icon: Icon(icon),
                  color: Color(typoOfButton == TypeOfButton.ledSignalization
                      ? btnc.buttonLedSignalizationColor.value
                      : typoOfButton == TypeOfButton.distance
                          ? btnc.buttonDistance.value
                          : btnc.buttonLightIntencity.value),
                  iconSize: 50.0,
                )),
          ),
        ),
      ],
    );
  }
}
