import 'package:flutter/material.dart';
import 'package:flt_umengpush_core/flt_umengpush_core.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    FltUmengpushCore.listen(tokenCallback: (token) {
      print("token:$token");
    }, notificationCallback: (pushData) {
      print("pushData:$pushData");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
