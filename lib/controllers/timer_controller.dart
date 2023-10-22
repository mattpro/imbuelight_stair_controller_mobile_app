import 'dart:async';
import 'package:get/get.dart';
import 'package:imbuelight_stair_controller_mobile_app/controllers/bluetooth_controller.dart';

class TimerController extends GetxController {
  final BluetoothController bc = Get.put(BluetoothController());
  final RxString subscription = ''.obs;
  @override
  void onReady() {
    updateValue();
    super.onReady();
  }

  updateValue() {
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      Obx(() => bc.refreshValue());
      subscription.value = bc.sub.toString();
    });
  }
}
