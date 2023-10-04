import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class BluetoothController extends GetxController {
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
                        onTap: () => connectionWithDevice(
                            data.device, data.device.connectionState),
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
        device.connectionState == BluetoothConnectionState.disconnected;
    return isConnect;
  }

  connectionWithDevice(device, state) async {
    await device.connect();
    List<BluetoothService> services = await device.discoverServices();
    for (var service in services) {
      print(service.serviceUuid);
      //6e400001-b5a3-f393-e0a9-e50e24dcca9e
      var characteristics = service.characteristics;
      for (BluetoothCharacteristic c in characteristics) {
        // if (c.isNotifying) {
        //   await c.setNotifyValue(true);
        // }
        if (c.properties.read) {
          List<int> value = await c.read();
          print("VALUE");
          print(String.fromCharCodes(value));
        } else {
          if (c.properties.notify) {
            print("TX");
            print(c.descriptors[0].lastValue);
            var descriptors = c.descriptors;
            for (BluetoothDescriptor d in descriptors) {
              List<int> value = await d.read();
              print(value);
            }
            await c.setNotifyValue(true);
            final subscription = c.onValueReceived.listen((value) {
              print(String.fromCharCodes(value));
            });
            device.connectionState.listen((BluetoothConnectionState state) {
              if (state == BluetoothConnectionState.disconnected) {
                // stop listening to characteristic
                subscription.cancel();
              }
              subscription.printInfo();
            });
          }
        }
      }
    }
    // var characteristics = services.last.characteristics;
    // for (BluetoothCharacteristic c in characteristics) {
    //   List<int> value = await c.read();
    //   print(value);
    // }
  }
}
