import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imbuelight_stair_controller_mobile_app/controllers/bluetooth_controller.dart';
import 'package:imbuelight_stair_controller_mobile_app/enums/enums.dart';
import 'package:imbuelight_stair_controller_mobile_app/widges/devices_list.dart';
import 'package:imbuelight_stair_controller_mobile_app/widges/font_style.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BluetoothController>(
        init: BluetoothController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: Color(AppColor.background.value),
            body: SafeArea(
              child: RefreshIndicator(
                onRefresh: () => _onFresh(controller),
                child: SingleChildScrollView(
                  child: Column(children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 50),
                      child: Text(
                        'Szukaj urządzenia',
                        style: fontStyle(Weight.bold, 27, Colors.white, true),
                      ),
                    ),
                    // Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    //   ElevatedButton(
                    //       onPressed: () => {
                    //             controller.scanDevices(),
                    //           },
                    //       child: Icon(Icons.refresh)),
                    // ]),
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
