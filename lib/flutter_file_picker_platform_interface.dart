import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'DataModel/FileResult.dart';
import 'flutter_file_picker_method_channel.dart';

abstract class FlutterFilePickerPlatform extends PlatformInterface {
  /// Constructs a PriceFilePickerPlatform.
  FlutterFilePickerPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterFilePickerPlatform _instance = MethodChannelFlutterFilePicker();

  /// The default instance of [PriceFilePickerPlatform] to use.
  ///
  /// Defaults to [MethodChannelPriceFilePicker].
  static FlutterFilePickerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PriceFilePickerPlatform] when
  /// they register themselves.
  static set instance(FlutterFilePickerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<FileResult?> pickPhoto({required String mimeType}) {
    throw UnimplementedError('pickPhoto() has not been implemented.');
  }

  Future<List<FileResult>?> pickPhotos({required String mimeType}) {
    throw UnimplementedError('pickPhotos() has not been implemented.');
  }

  Future<List<FileResult>?> pickFiles({String mimeType = "image/*", bool allowMultiple = false}) {
    throw UnimplementedError('pickFiles() has not been implemented.');
  }

}
