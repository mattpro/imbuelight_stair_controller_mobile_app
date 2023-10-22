import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:imbuelight_stair_controller_mobile_app/pages/device_page.dart';

class BluetoothController extends GetxController {
  RxString nameOfDevice = ''.obs;
  RxString sub = ''.obs;
  Future scanDevices() async {
    if (FlutterBluePlus.isScanningNow == false) {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
    }
    listDeviceWidget();
  }

  refreshDevices(AsyncSnapshot<List<ScanResult>> snapshot) {
    List<ScanResult> imbue = snapshot.data!
        .where((i) => i.device.platformName.isNotEmpty
            ? i.device.platformName.substring(0, 5) == "Imbue"
            : false)
        .toList();

    return imbue;
  }

  listDeviceWidget() {
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
                        title: Text(data.device.platformName),
                        subtitle: Text(data.device.remoteId.str),
                        trailing: Text(data.rssi.toString()),
                        onTap: () async => {
                              await connectionWithDevice(
                                  data.device, data.device.connectionState),
                            },
                        tileColor: connectionState(
                                data.device, data.device.connectionState)
                            ? Colors.cyan
                            : Colors.yellow),
                  );
                });
          } else {
            return const Text("No devices found");
          }
        });
  }

  connectionState(device, state) {
    bool isConnect =
        device.connectionState == BluetoothConnectionState.connected;
    return isConnect;
  }

  // subsciptionWidget() {
  //   final BluetoothController c = Get.put(BluetoothController());
  //   return Obx(() => StreamBuilder(
  //       stream: c.sub,
  //       builder: (context, snapshot) {
  //         if (snapshot.hasData) {
  //           return ListTile(
  //             title: Text(c.name),
  //             subtitle: Text(snapshot.data.toString()),
  //           );
  //         } else {
  //           return const Text("No devices found");
  //         }
  //       }));
  // }

  readDeviceName(device) async {
    List<BluetoothService> services = await device.discoverServices();
    for (var service in services) {
      var characteristics = service.characteristics;
      for (BluetoothCharacteristic c in characteristics) {
        // if (c.isNotifying) {
        //   await c.setNotifyValue(true);
        // }
        if (c.properties.read) {
          List<int> value = await c.read();
          if (String.fromCharCodes(value)[0] == "I") {
            // Iterable<int> name = value;
            nameOfDevice = RxString(String.fromCharCodes(value));
          }
        }
      }
    }
  }

  readDeviceValue(device) async {
    List<BluetoothService> services = await device.discoverServices();
    for (var service in services) {
      var characteristics = service.characteristics;
      for (BluetoothCharacteristic c in characteristics) {
        // if (c.isNotifying) {
        //   await c.setNotifyValue(true);
        // }
        if (c.properties.notify) {
          await c.setNotifyValue(true);
          final subscription = c.onValueReceived.listen((value) {
            const Duration(milliseconds: 1000);
            String.fromCharCodes(value);
            sub = RxString(String.fromCharCodes(value));
          });
          device.connectionState.listen((BluetoothConnectionState state) {
            if (state == BluetoothConnectionState.disconnected) {
              // stop listening to characteristic
              subscription.cancel();
            }
          });
        }
      }
    }
  }

  refreshValue() {
    sub.refresh();
    nameOfDevice.refresh();
  }

  BluetoothDevice? deviceItem;
  // var sub = await readDeviceValue(device).obs;
  // var name = await readDeviceName(device).obs
  connectionWithDevice(BluetoothDevice device, state) async {
    await device.connect();
    await readDeviceValue(device);
    await readDeviceName(device);
    Get.to(() => const DevicePage());
    // return [sub, name];
  }
}
