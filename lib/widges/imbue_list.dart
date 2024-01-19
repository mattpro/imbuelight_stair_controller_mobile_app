import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:imbuelight_stair_controller_mobile_app/controllers/bluetooth_controller.dart';
import 'package:imbuelight_stair_controller_mobile_app/enums/enums.dart';
import 'package:imbuelight_stair_controller_mobile_app/methods/font_style.dart';
import 'package:imbuelight_stair_controller_mobile_app/widges/device_card.dart';

class ImbueList extends StatelessWidget {
  final List<ScanResult> imbue;
  final BluetoothController bc;
  final TypeOfDevice typeOfDevice;
  final double height;
  const ImbueList({
    super.key,
    required List<ScanResult> this.imbue,
    required BluetoothController this.bc,
    required TypeOfDevice this.typeOfDevice,
    required double this.height,
  });

  @override
  Widget build(BuildContext context) {
    // final FadeController fc = Get.put(FadeController());
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
            BoxConstraints(minHeight: height * 0.40, minWidth: double.infinity),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Column(children: [
            const SizedBox(height: 35),
            imbue.length > 0
                ? SingleChildScrollView(
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: imbue.length,
                        itemBuilder: (context, index) {
                          imbue.sort((a, b) => b.rssi.compareTo(a.rssi));
                          final data = imbue[index];
                          return DeviceCard(data: data, bc: bc);
                        }),
                  )
                : Text(
                    typeOfDevice == TypeOfDevice.sensor
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
}
