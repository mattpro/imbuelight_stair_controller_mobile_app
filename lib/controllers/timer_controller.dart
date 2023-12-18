import 'dart:async';
import 'package:get/get.dart';
import 'package:imbuelight_stair_controller_mobile_app/controllers/bluetooth_controller.dart';

class TimerController extends GetxController {
  final BluetoothController bc = Get.put(BluetoothController());
  final RxList subscription = [].obs;
  final RxInt distanceValue = 0.obs;
  RxInt currentSensorValue = 0.obs;
  final RxInt currentIntensityValue = 0.obs;
  final RxString currentIntensityValuePercent = ''.obs;
  final RxInt lightIntensityValue = 0.obs;

  @override
  void onReady() {
    updateValue();
    super.onReady();
  }

  updateValue() {
    Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
      Obx(() => bc.refreshValue());
      subscription.value = bc.sub;
      // distanceValue.value = bc.sub[11];
      currentSensorValue.value = bc.currentDistanceValue.value;
      currentIntensityValue.value =
          (bc.currentlightIntensityValue.value * 100 / 4095).round();
      distanceValue.value = bc.distanceValue.value;
      lightIntensityValue.value =
          (bc.lightIntensityValue.value * 100 / 4095).round();
    });
  }
}
