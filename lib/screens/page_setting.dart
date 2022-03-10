import 'package:ble_transmitter/manager/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    var settings = context.watch<Settings>();
    return Scaffold(
      appBar: AppBar(title: Text('Settings'),),
      body: ListView(
        children: [
          ListTile(
            title: Text('Begin byte'),
            subtitle: Text(settings.beginByteString),
            onTap: (){
              _displayTextInputDialog(context, 'Begin byte', settings.beginByteString).then((value) => settings.beginByte = value);
            },
          ),
          ListTile(
            title: Text('End byte'),
            subtitle: Text(settings.endByteString),
            onTap: () => _displayTextInputDialog(context, 'End byte', settings.endByteString).then((value) => settings.endByte = value),
          ),
          ListTile(
            title: Text('Start word'),
            subtitle: Text(settings.startWord),
            onTap: () => _displayTextInputDialog(context, 'Start word', settings.startWord).then((value) => settings.startWord = value),
          ),
          ListTile(
            title: Text('End word'),
            subtitle: Text(settings.endWord),
            onTap: () => _displayTextInputDialog(context, 'End word', settings.endWord).then((value) => settings.endWord = value),
          ),
          ListTile(
            title: Text('Data length'),
            subtitle: Text(settings.dataLength.toString()),
            onTap: () => _displayTextInputDialog(context, 'Data length', settings.dataLength.toString()).then((value) => settings.dataLength = value),
          ),
        ],
      ),
    );
  }

  Future<String?> _displayTextInputDialog(BuildContext context, String msg, String value) async {
    String valueText = '';
    var _textFieldController = TextEditingController(text: value);
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: msg),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context, valueText);
                  });
                },
              ),

            ],
          );
        });
  }
}
