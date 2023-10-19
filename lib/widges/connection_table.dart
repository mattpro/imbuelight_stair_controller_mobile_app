import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imbuelight_stair_controller_mobile_app/controllers/bluetooth_controller.dart';

class ConnectionTable extends GetView<BluetoothController> {
  ConnectionTable({super.key});
  final BluetoothController c = Get.put(BluetoothController());

  @override
  Widget build(BuildContext context) {
    // c.refreshValue();
    return refreshWidget();
  }
}

refreshWidget() {
  while (true) {
    final BluetoothController c = Get.put(BluetoothController());
    const Duration(seconds: 1);
    c.refreshValue();
    return Obx(() =>
        ListTile(title: Text("${c.nameOfDevice}"), subtitle: Text("${c.sub}")));
  }
}
