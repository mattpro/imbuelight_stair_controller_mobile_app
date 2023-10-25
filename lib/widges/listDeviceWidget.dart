import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:imbuelight_stair_controller_mobile_app/controllers/bluetooth_controller.dart';
import 'package:imbuelight_stair_controller_mobile_app/enums/enums.dart';
import 'package:imbuelight_stair_controller_mobile_app/widges/font_style.dart';

Widget listDeviceWidget() {
  final BluetoothController bc = Get.put(BluetoothController());
  return StreamBuilder(
      stream: FlutterBluePlus.scanResults,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<ScanResult> imbueSensors = bc.validationSensors(snapshot);
          List<ScanResult> imbueControllers =
              bc.validationControllers(snapshot);
          return Column(children: [
            imbueList(imbueSensors, bc, TypeOfDevice.sensor),
            imbueList(imbueControllers, bc, TypeOfDevice.controller),
            // sensorsList(imbueSensors, bc),
            // controllerList(imbueControllers, bc),
          ]);
        } else {
          return const Text("No devices found");
        }
      });
}

Widget imbueList(
    List<ScanResult> imbue, BluetoothController bc, TypeOfDevice typeofDevice) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 15),
    child: Column(children: [
      Row(children: [
        const SizedBox(width: 20),
        Text(
          typeofDevice == TypeOfDevice.sensor ? 'Czujniki' : 'Kontrolery',
          style: fontStyle(Weight.bold, 25, Colors.white),
        ),
      ]),
      imbue.length > 0
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: imbue.length,
              itemBuilder: (context, index) {
                final data = imbue[index];
                return Card(
                  elevation: 2,
                  child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      title: Text(data.device.platformName,
                          style: fontStyle(Weight.bold, 15, Colors.black)),
                      trailing: Text(data.rssi.toString()),
                      onTap: () async => {
                            await bc.connectionWithDevice(
                                data.device, data.device.connectionState),
                          },
                      tileColor: Color(AppColor.third.value)),
                );
              })
          : Text(
              typeofDevice == TypeOfDevice.sensor
                  ? 'Nie wykryto czujników'
                  : 'Nie wykryto kontrolerów',
              style: fontStyle(Weight.bold, 15, Colors.white),
            ),
    ]),
  );
}
