import 'dart:async';

import 'package:get/get.dart';
import 'package:imbuelight_stair_controller_mobile_app/controllers/bluetooth_controller.dart';

class OnController extends GetxController {
  final BluetoothController bc = Get.put(BluetoothController());
  RxBool isOn = false.obs;
  @override
  void onReady(){
    updateValue();
    super.onReady();
  }

   updateValue(){
    Timer.periodic(const Duration(milliseconds: 500), (Timer timer) {
      bc.checkBluetooth();
      if (bc.isBluetoothOn.value)  {
        isOn.value = true;
      } else {
        isOn.value = false;
      }
      
    });
  }
}