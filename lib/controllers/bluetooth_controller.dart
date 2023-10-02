import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class BluetoothController extends GetxController {
  Future scanDevices() async {
    if (FlutterBluePlus.isScanningNow == false) {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
    }
    listDevice();
  }

  refreshDevices(AsyncSnapshot<List<ScanResult>> snapshot) {
    List<ScanResult> imbue = snapshot.data!
        .where((i) => i.device.localName.isNotEmpty
            ? i.device.localName.substring(0, 5) == "Imbue"
            : false)
        .toList();

    return imbue;
  }

  listDevice() {
    return StreamBuilder(
        stream: FlutterBluePlus.scanResults,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ScanResult> imbue = refreshDevices(snapshot);
            return ListView.builder(
                shrinkWrap: true,
                itemCount: imbue.length,
                itemBuilder: (context, index) {
                  final data = imbue[index];
                  return Card(
                    elevation: 2,
                    child: ListTile(
                      title: Text(data.device.localName),
                      subtitle: Text(data.device.remoteId.str),
                      trailing: Text(data.rssi.toString()),
                    ),
                  );
                });
          } else {
            return const Text("No devices found");
          }
        });
  }
}
