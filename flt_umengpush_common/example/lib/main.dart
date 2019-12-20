import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flt_umengpush_common/flt_umengpush_common.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    init();
    setLogEnabled(true);
  }

  Future<void> init() async {
    try {
      await FltUmengpushCommon.init("", "");
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> setLogEnabled(bool enabled) async {
    try {
      await FltUmengpushCommon.setLogEnabled(enabled);
    } on PlatformException {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('text'),
        ),
      ),
    );
  }
}
