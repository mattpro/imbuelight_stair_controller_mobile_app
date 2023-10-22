import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imbuelight_stair_controller_mobile_app/controllers/bluetooth_controller.dart';
import 'package:imbuelight_stair_controller_mobile_app/controllers/timer_controller.dart';

class ConnectionTable extends GetView<TimerController> {
  ConnectionTable({super.key});
  final BluetoothController c = Get.put(BluetoothController());
  @override
  Widget build(BuildContext context) {
    return refreshWidget();
  }
}

refreshWidget() {
  while (true) {
    final BluetoothController c = Get.put(BluetoothController());
    final TimerController tc = Get.put(TimerController());
    tc.onReady();
    return Obx(() => ListTile(
        title: Text("${c.nameOfDevice}"),
        subtitle: Text(tc.subscription.value)));
  }
}
