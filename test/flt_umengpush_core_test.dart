import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flt_umengpush_core/flt_umengpush_core.dart';

void main() {
  const MethodChannel channel = MethodChannel('flt_umengpush_core');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FltUmengpushCore.platformVersion, '42');
  });
}
