import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:imbuelight_stair_controller_mobile_app/controllers/bluetooth_controller.dart';
import 'package:imbuelight_stair_controller_mobile_app/enums/enums.dart';
import 'package:imbuelight_stair_controller_mobile_app/widges/font_style.dart';

Widget listDeviceWidget(double height) {
  final BluetoothController bc = Get.put(BluetoothController());
  return StreamBuilder(
      stream: FlutterBluePlus.scanResults,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<ScanResult> imbueSensors = bc.validationSensors(snapshot);
          List<ScanResult> imbueControllers =
              bc.validationControllers(snapshot);
          return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                deviceTitle(TypeOfDevice.sensor),
                const SizedBox(height: 15),
                imbueList(imbueSensors, bc, TypeOfDevice.sensor, height),
                const SizedBox(
                  height: 40,
                ),
                deviceTitle(TypeOfDevice.controller),
                const SizedBox(height: 15),
                imbueList(
                    imbueControllers, bc, TypeOfDevice.controller, height),
                const SizedBox(
                  height: 40,
                ),
              ]);
        } else {
          return const Text("No devices found");
        }
      });
}

Widget imbueList(List<ScanResult> imbue, BluetoothController bc,
    TypeOfDevice typeofDevice, double height) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(45, 0, 255, 255),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(45, 0, 255, 255),
            blurRadius: 4,
            offset: Offset(4, 4), // Shadow position
          )
        ],
      ),
      constraints:
          BoxConstraints(maxHeight: height * 0.40, minWidth: double.infinity),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Column(children: [
          const SizedBox(height: 35),
          imbue.length > 0
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: imbue.length,
                  itemBuilder: (context, index) {
                    final data = imbue[index];
                    return Card(
                      elevation: 4,
                      child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          title: Text(data.device.platformName,
                              style: fontStyle(
                                  Weight.bold, 15, Colors.black, false)),
                          subtitle: Text(
                              data.device.platformName
                                  .substring(
                                    17,
                                  )
                                  .trim(),
                              style: fontStyle(
                                  Weight.bold, 11, Colors.black, false)),
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
                  style: fontStyle(Weight.bold, 15, Colors.white, true),
                ),
          const SizedBox(height: 15),
        ]),
      ),
    ),
  );
}

Row deviceTitle(TypeOfDevice typeofDevice) {
  return Row(children: [
    const SizedBox(width: 20),
    Text(
      typeofDevice == TypeOfDevice.sensor ? 'Czujniki' : 'Kontrolery',
      style: fontStyle(Weight.bold, 25, Colors.white, true),
    ),
  ]);
}
