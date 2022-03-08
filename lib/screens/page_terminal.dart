import 'package:ble_transmitter/manager/ble_mamanger.dart';
import 'package:ble_transmitter/manager/log_manager.dart';
import 'package:ble_transmitter/model/log.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';
import 'package:convert/convert.dart';

class TerminalPage extends StatefulWidget {
  const TerminalPage({Key? key}) : super(key: key);

  @override
  _TerminalPageState createState() => _TerminalPageState();
}

class _TerminalPageState extends State<TerminalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terminal'),
        actions: [
          IconButton(
            icon: Icon(Icons.bluetooth_disabled),
            onPressed: () {
              bleManager.disconnect();
            },
          ),
          IconButton(
            icon: Icon(Icons.restore_from_trash),
            onPressed: () {
              logManager.clear();
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          children: const [
            Expanded(child: LogList()),
            TextField(
              textInputAction: TextInputAction.send,
              decoration: InputDecoration(border: OutlineInputBorder()),
            )
          ],
        ),
      ),
    );
  }
}

class LogList extends StatefulWidget {
  const LogList({Key? key}) : super(key: key);

  @override
  _LogListState createState() => _LogListState();
}

class _LogListState extends State<LogList> {
  final DateFormat dateFormatter = DateFormat('hh:mm:ss.SSS');

  @override
  Widget build(BuildContext context) {
    var logMgr = context.watch<LogManager>();
    return ListView.builder(
        itemCount: logMgr.count,
        itemBuilder: (c, index) {
          var log = logMgr.list[index];
          final String time = dateFormatter.format(log.time);
          return ExpansionTile(
            title: ListTile(
              leading: Text(time),
              title: getTitle(log),
              subtitle: Text(log.description ?? ''),
            ),
            children: [getSubtitle(log)],
          );
        });
  }

  Widget getSubtitle(Log log) {
    if (log.type == LogType.sendraw) {
      return Text(
        log.raw == null ? '' : log.raw!.map((e) => e.toRadixString(16).toUpperCase()).toList().toString(),
        style: TextStyle(color: Colors.blue, fontSize: 14),
      );
    } else if (log.type == LogType.receiveraw) {
      return Text(
        log.raw == null ? '' : log.raw!.map((e) => e.toRadixString(16)).toList().toString(),
        style: TextStyle(color: Colors.green, fontSize: 14),
      );
    } else {
      return Text('', style: TextStyle(fontSize: 14));
    }
  }

  Widget getTitle(Log log) {
    if (log.type == LogType.sendraw) {
      return Text(
        log.title ?? '',
        style: TextStyle(fontSize: 14),
      );
    } else if (log.type == LogType.receiveraw) {
      return Text(
        log.title ?? '',
        style: TextStyle(fontSize: 14),
      );
    } else {
      return Text(log.title ?? '', style: TextStyle(fontSize: 14));
    }
  }
}
