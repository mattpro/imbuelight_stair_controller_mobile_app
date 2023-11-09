import 'dart:async';
import 'package:get/get.dart';
import 'package:imbuelight_stair_controller_mobile_app/controllers/bluetooth_controller.dart';

class TimerController extends GetxController {
  final BluetoothController bc = Get.put(BluetoothController());
  final RxString subscription = ''.obs;
  final RxDouble distanceValue = 0.0.obs;
  final RxString currentSensorValue = ''.obs;
  final RxInt currentIntensityValue = 0.obs;
  final RxString currentIntensityValuePercent = ''.obs;

  @override
  void onReady() {
    updateValue();
    super.onReady();
  }

  updateValue() {
    Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
      Obx(() => bc.refreshValue());
      subscription.value = bc.sub.toString();
      distanceValue.value = bc.distanceValue.value;
      currentSensorValue.value = bc.sub.toString().substring(2, 5);
      currentIntensityValue.value =
          (double.parse(bc.sub.toString().substring(10, 14)) * 100 / 4095)
              .round();
    });
  }
}
