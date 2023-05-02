import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:price_file_picker/price_file_picker_method_channel.dart';

void main() {
  MethodChannelPriceFilePicker platform = MethodChannelPriceFilePicker();
  const MethodChannel channel = MethodChannel('price_file_picker');

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
    expect(await platform.getPlatformVersion(), '42');
  });
}
