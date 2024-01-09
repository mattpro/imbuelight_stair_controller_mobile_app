import 'package:get/get.dart';
import 'package:imbuelight_stair_controller_mobile_app/enums/enums.dart';

class ButtonController extends GetxController {
  Rx<int> buttonLedSignalizationColor = AppColor.background.value.obs;
  Rx<int> buttonDistance = AppColor.background.value.obs;
  Rx<int> buttonLightIntencity = AppColor.background.value.obs;

  changeColor(int turnOnOff, TypeOfButton typeOfButton) {
    if (turnOnOff == 0) {
      if (typeOfButton == TypeOfButton.ledSignalization) {
        buttonLedSignalizationColor.value = AppColor.background.value;
      } else if (typeOfButton == TypeOfButton.distance) {
        buttonDistance.value = AppColor.background.value;
      } else {
        buttonLightIntencity.value = AppColor.background.value;
      }
    } else {
      if (typeOfButton == TypeOfButton.ledSignalization) {
        buttonLedSignalizationColor.value = AppColor.white.value;
      } else if (typeOfButton == TypeOfButton.distance) {
        buttonDistance.value = AppColor.white.value;
      } else {
        buttonLightIntencity.value = AppColor.white.value;
      }
    }
  }
}
