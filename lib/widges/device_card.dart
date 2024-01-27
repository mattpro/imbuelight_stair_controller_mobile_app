import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:imbuelight_stair_controller_mobile_app/controllers/bluetooth_controller.dart';
import 'package:imbuelight_stair_controller_mobile_app/enums/enums.dart';
import 'package:imbuelight_stair_controller_mobile_app/methods/font_style.dart';

class DeviceCard extends StatelessWidget {
  const DeviceCard({
    super.key,
    required this.data,
    required this.bc,
    required this.typeOfDevice,
  });

  final ScanResult data;
  final BluetoothController bc;
  final TypeOfDevice typeOfDevice;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text(
              data.device.platformName.isEmpty
                  ? data.device.remoteId.toString()
                  : data.device.platformName
                      .substring(0, data.device.platformName.length - 6)
                      .trim(),
              style: fontStyle(Weight.bold, 15, Colors.black, false)),
          subtitle: Text(
              data.device.platformName
                  .substring(data.device.platformName.length - 6,
                      data.device.platformName.length)
                  .trim(),
              style: fontStyle(Weight.bold, 11, Colors.black, false)),
          trailing: bluetoothImage(data),

          // Text(data.rssi.toString()),
          onTap: () async => {
                await bc.connectionWithDevice(
                    data.device, data.device.connectionState, typeOfDevice),
              },
          tileColor: Color(AppColor.third.value)),
    );
  }
}

Image bluetoothImage(data) {
  int range = data.rssi;
  final String image;
  if (range > -50) {
    image = 'assets/bluetooth_1.png';
  } else if (range <= -50 && range > -70) {
    image = 'assets/bluetooth_2.png';
  } else if (range <= -70 && range > -90) {
    image = 'assets/bluetooth_3.png';
  } else {
    image = 'assets/bluetooth_4.png';
  }
  return Image(
    image: AssetImage(image),
    height: 30,
  );
}
