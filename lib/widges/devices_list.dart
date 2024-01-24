import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:imbuelight_stair_controller_mobile_app/controllers/bluetooth_controller.dart';
import 'package:imbuelight_stair_controller_mobile_app/enums/enums.dart';
import 'package:imbuelight_stair_controller_mobile_app/widges/imbue_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../methods/font_style.dart';

class DevicesList extends StatelessWidget {
  final BluetoothController? controller;
  const DevicesList({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

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
                  deviceTitle(TypeOfDevice.sensor, context),
                  const SizedBox(height: 15),
                  ImbueList(
                      imbue: imbueSensors,
                      bc: bc,
                      typeOfDevice: TypeOfDevice.sensor,
                      height: height),
                  const SizedBox(
                    height: 40,
                  ),
                  deviceTitle(TypeOfDevice.controller, context),
                  const SizedBox(height: 15),
                  ImbueList(
                    imbue: imbueControllers,
                    bc: bc,
                    typeOfDevice: TypeOfDevice.controller,
                    height: height,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ]);
          } else {
            return Text(AppLocalizations.of(context)!.devicesWereNotDetected);
          }
        });
  }
}

Row deviceTitle(TypeOfDevice typeofDevice, context) {
  return Row(children: [
    const SizedBox(width: 20),
    Text(
      typeofDevice == TypeOfDevice.sensor
          ? AppLocalizations.of(context)!.sensors
          : AppLocalizations.of(context)!.controllers,
      style: fontStyle(Weight.bold, 25, Colors.white, true),
    ),
  ]);
}
