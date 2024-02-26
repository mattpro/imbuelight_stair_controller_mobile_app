import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:imbuelight_stair_controller_mobile_app/controllers/bluetooth_controller.dart';
import 'package:imbuelight_stair_controller_mobile_app/enums/enums.dart';
import 'package:imbuelight_stair_controller_mobile_app/methods/font_style.dart';
import 'package:imbuelight_stair_controller_mobile_app/widges/device_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ImbueList extends StatelessWidget {
  final List<ScanResult> imbue;
  final BluetoothController bc;
  final TypeOfDevice typeOfDevice;
  final double height;
  const ImbueList({
    super.key,
    required this.imbue,
    required this.bc,
    required this.typeOfDevice,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    // final FadeController fc = Get.put(FadeController());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(45, 0, 255, 255),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
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
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(children: [
            const SizedBox(height: 35),
            imbue.isNotEmpty
                ? SingleChildScrollView(
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: imbue.length,
                        itemBuilder: (context, index) {
                          imbue.sort((a, b) => b.rssi.compareTo(a.rssi));
                          final data = imbue[index];
                          return DeviceCard(
                            data: data,
                            bc: bc,
                            typeOfDevice: typeOfDevice,
                          );
                        }),
                  )
                : Text(
                    typeOfDevice == TypeOfDevice.sensor
                        ? AppLocalizations.of(context)!.sensorsNotFound
                        : AppLocalizations.of(context)!.controllersNotFound,
                    style: fontStyle(Weight.bold, 15, Colors.white, true),
                  ),
            const SizedBox(height: 15),
          ]),
        ),
      ),
    );
  }
}
