import 'package:ble_transmitter/manager/ble_mamanger.dart';
import 'package:ble_transmitter/manager/log_manager.dart';
import 'package:ble_transmitter/screens/connection.dart';
import 'package:ble_transmitter/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'manager/connect_state.dart';
import 'manager/settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var granted = false;

  @override
  void initState() {
    super.initState();
    checkPermission().then((value) {
      setState(() {
        granted = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: connectState),
        ChangeNotifierProvider.value(value: scanResults),
        ChangeNotifierProvider.value(value: logManager),
        ChangeNotifierProvider.value(value: settings)
      ],
      child: MaterialApp(
        title: 'BLE Transmitter',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Consumer<ConnectState>(
            builder: (BuildContext context, state, Widget? child) {
              return check(state);
            },
        ),
      ),
    );
  }

  Future<bool> checkPermission() async {
    return await Permission.bluetooth.isGranted &&
        await Permission.bluetoothConnect.isGranted &&
        await Permission.bluetoothScan.isGranted &&
        await Permission.locationAlways.isGranted;
  }

  Widget check(ConnectState state) {
    if (!granted) {
      return PermissionPage(callback: () {
        checkPermission().then((value) => setState(() {
              granted = value;
            }));
      });
    } else if (state.value == AppState.connected) {
      return const HomeScreen();
    } else {
      return const ConnectionScreen();
    }
  }
}

class PermissionPage extends StatelessWidget {
  VoidCallback callback;

  PermissionPage({Key? key, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("需要允許藍芽、位置權限，以運行此APP"),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
                onPressed: () {
                  requestPermission();
                },
                child: const Text("允許權限"))
          ],
        ),
      ),
    );
  }

  void requestPermission() async {
    await [Permission.bluetoothConnect, Permission.bluetooth, Permission.bluetoothScan, Permission.locationAlways]
        .request();
    callback();
  }
}
