import 'package:ble_transmitter/manager/upload_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
var busy = false;
class FilePage extends StatefulWidget {
  const FilePage({Key? key}) : super(key: key);

  @override
  State<FilePage> createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload file'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.music_note),
            title: Text('the_mini_vandals.mp3'),
            subtitle: Text('4.6MB'),
            trailing: busy
                ? CircularProgressIndicator()
                : IconButton(
                    icon: Icon(Icons.send_to_mobile),
                    onPressed: () {
                      setState(() {
                        busy = true;
                      });
                      upload('assets/the_mini_vandals.mp3', 'mp3');
                    },
                  ),
          ),
          ListTile(
            leading: Icon(Icons.music_note),
            title: Text('levelup.wav'),
            subtitle: Text('136KB'),
            trailing: busy
                ? CircularProgressIndicator()
                : IconButton(
                    icon: Icon(Icons.send_to_mobile),
                    onPressed: () {
                      setState(() {
                        busy = true;
                      });

                      upload('assets/levelup.wav', 'wav');
                    },
                  ),
          ),
          ListTile(
            leading: Icon(Icons.photo),
            title: Text('android.png'),
            subtitle: Text('2KB'),
            trailing: busy
                ? CircularProgressIndicator()
                : IconButton(
              icon: Icon(Icons.send_to_mobile),
              onPressed: () {
                setState(() {
                  busy = true;
                });
                upload('assets/android.png', 'png');
              },
            ),
          ),
        ],
      ),
    );
  }

  void upload(String path, String ext) async {
    ByteData data = await rootBundle.load(path);
    var success = await uploadManager.startTask(data.buffer.asInt8List(), ext);
    setState(() {
      busy = false;
    });

  }
}
