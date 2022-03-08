import 'package:ble_transmitter/screens/page_file.dart';
import 'package:ble_transmitter/screens/page_setting.dart';
import 'package:ble_transmitter/screens/page_terminal.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _index = 0;
  final _pages = const [TerminalPage(), FilePage(), SettingPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Terminal'),
          BottomNavigationBarItem(icon: Icon(Icons.file_copy), label: 'File'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings')
        ],
        onTap: (i){
          setState(() {
            _index = i;
          });
        },
      ),

    );
  }
}
