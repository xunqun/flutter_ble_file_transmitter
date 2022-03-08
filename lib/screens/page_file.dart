import 'package:ble_transmitter/manager/upload_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FilePage extends StatelessWidget {
  const FilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload file'),),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.music_note),
            title: Text('the_mini_vandals.mp3'),
            subtitle: Text('4.6MB'),
            trailing: IconButton(
              icon: Icon(Icons.file_upload), onPressed: () {
                upload('assets/the_mini_vandals.mp3', 'mp3');
            },
            ),
          ),
          ListTile(
            leading: Icon(Icons.music_note),
            title: Text('levelup.wav'),
            subtitle: Text('136KB'),
            trailing: IconButton(
              icon: Icon(Icons.file_upload), onPressed: () {
              upload('assets/levelup.wav', 'wav');
            },
            ),
          )
        ],
      ),
    );
  }

  void upload(String path, String ext) async{
    ByteData data = await rootBundle.load(path);
    var success = await uploadManager.startTask(data.buffer.asInt8List(), ext);
  }
}
