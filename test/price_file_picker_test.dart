import 'package:flutter_test/flutter_test.dart';
import 'package:price_file_picker/price_file_picker.dart';
import 'package:price_file_picker/price_file_picker_platform_interface.dart';
import 'package:price_file_picker/price_file_picker_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPriceFilePickerPlatform
    with MockPlatformInterfaceMixin
    implements PriceFilePickerPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final PriceFilePickerPlatform initialPlatform = PriceFilePickerPlatform.instance;

  test('$MethodChannelPriceFilePicker is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPriceFilePicker>());
  });

  test('getPlatformVersion', () async {
    PriceFilePicker priceFilePickerPlugin = PriceFilePicker();
    MockPriceFilePickerPlatform fakePlatform = MockPriceFilePickerPlatform();
    PriceFilePickerPlatform.instance = fakePlatform;

    expect(await priceFilePickerPlugin.getPlatformVersion(), '42');
  });
}
