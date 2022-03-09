import 'package:ble_transmitter/constant/constant.dart';
import 'package:ble_transmitter/manager/ble_mamanger.dart';
import 'package:ble_transmitter/manager/connect_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/src/provider.dart';

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({Key? key}) : super(key: key);

  @override
  _ConnectionScreenState createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  @override
  Widget build(BuildContext context) {
    List<ScanResult> results = context.watch<ScanResults>().list;
    AppState state = context.watch<ConnectState>().value;
    return Scaffold(
      appBar: AppBar(title: Text('Connect to device')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(itemBuilder: (c, i){
              var name = results[i].advertisementData.localName;
              var address = results[i].device.id.id;
              if(name.isEmpty){
                name = '---';
              }
              return ListTile(
                leading: const Icon(Icons.bluetooth),
                title: Text(name),
                subtitle: Text(address),
                onTap: (){
                  results[i].device.connect().then((value){
                    connectState.value = AppState.connected;
                    bleManager.device = results[i].device;
                  });
                  
                },
              );
            }, itemCount: results.length,),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: state == AppState.scanning ? null :() {
                    bleManager.scan();
                  },
                  child: const Text('Scan')
              ),
            ),
          ),

        ],
      ),
    );
  }
}
