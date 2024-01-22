import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imbuelight_stair_controller_mobile_app/controllers/bluetooth_controller.dart';
import 'package:imbuelight_stair_controller_mobile_app/controllers/on_controller.dart';
import 'package:imbuelight_stair_controller_mobile_app/enums/enums.dart';
import 'package:imbuelight_stair_controller_mobile_app/widges/devices_list.dart';
import 'package:imbuelight_stair_controller_mobile_app/methods/font_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final BluetoothController bc = Get.put(BluetoothController());
  final OnController oc = Get.put(OnController());
  @override
  Widget build(BuildContext context) {
    oc.onReady();

    return GetBuilder<BluetoothController>(
        init: BluetoothController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: Color(AppColor.background.value),
            body: SafeArea(
              child: Platform.isMacOS
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          IconButton(
                              onPressed: () async => await _onFresh(controller),
                              icon: Icon(Icons.refresh)),
                          SingleChildScrollView(
                            child: Column(children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 50),
                                child: Text(
                                  AppLocalizations.of(context)!.searchDevice,
                                  style: fontStyle(
                                      Weight.bold, 27, Colors.white, true),
                                ),
                              ),
                              Obx(() => Text('${oc.isOn.value}',
                                  style: fontStyle(
                                      Weight.bold, 27, Colors.white, true))),
                              Obx(() => oc.isOn.value
                                  ? const DevicesList()
                                  : Text(
                                      AppLocalizations.of(context)!
                                          .bluetoothTurnedOff,
                                      style: fontStyle(Weight.bold, 27,
                                          Colors.white, true))),
                            ]),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () => _onFresh(controller),
                      child: SingleChildScrollView(
                        child: Column(children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 50),
                            child: Text(
                              AppLocalizations.of(context)!.searchDevice,
                              style: fontStyle(
                                  Weight.bold, 27, Colors.white, true),
                            ),
                          ),
                          const DevicesList(),
                        ]),
                      ),
                    ),
            ),
          );
        });
  }
}

Future<void> _onFresh(BluetoothController controller) {
  return controller.scanDevices();
}
