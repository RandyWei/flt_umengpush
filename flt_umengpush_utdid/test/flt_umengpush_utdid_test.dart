import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flt_umengpush_utdid/flt_umengpush_utdid.dart';

void main() {
  const MethodChannel channel = MethodChannel('flt_umengpush_utdid');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FltUmengpushUtdid.platformVersion, '42');
  });
}
