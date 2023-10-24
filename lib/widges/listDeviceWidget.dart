import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:imbuelight_stair_controller_mobile_app/controllers/bluetooth_controller.dart';
import 'package:imbuelight_stair_controller_mobile_app/enums/enums.dart';
import 'package:imbuelight_stair_controller_mobile_app/widges/font_style.dart';

listDeviceWidget() {
  final BluetoothController bc = Get.put(BluetoothController());
  return StreamBuilder(
      stream: FlutterBluePlus.scanResults,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<ScanResult> imbueSensors = bc.refreshSensors(snapshot);
          List<ScanResult> imbueControllers = bc.refreshControllers(snapshot);
          return Column(children: [
            ListView.builder(
                shrinkWrap: true,
                itemCount: imbueSensors.length,
                itemBuilder: (context, index) {
                  final data = imbueSensors[index];
                  return Card(
                    elevation: 2,
                    child: ListTile(
                        title: Text(data.device.platformName,
                            style: fontStyle(Weight.bold, 15, Colors.black)),
                        trailing: Text(data.rssi.toString()),
                        onTap: () async => {
                              await bc.connectionWithDevice(
                                  data.device, data.device.connectionState),
                            },
                        tileColor: bc.connectionState(
                                data.device, data.device.connectionState)
                            ? Colors.cyan
                            : Colors.yellow),
                  );
                }),
            ListView.builder(
                shrinkWrap: true,
                itemCount: imbueControllers.length,
                itemBuilder: (context, index) {
                  final data = imbueControllers[index];
                  return Card(
                    elevation: 2,
                    child: ListTile(
                        title: Text(data.device.platformName,
                            style: fontStyle(Weight.bold, 15, Colors.black)),
                        trailing: Text(data.rssi.toString()),
                        onTap: () async => {
                              await bc.connectionWithDevice(
                                  data.device, data.device.connectionState),
                            },
                        tileColor: bc.connectionState(
                                data.device, data.device.connectionState)
                            ? Colors.cyan
                            : Colors.yellow),
                  );
                }),
          ]);
        } else {
          return const Text("No devices found");
        }
      });
}
