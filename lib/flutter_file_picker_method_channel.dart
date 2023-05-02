import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mime/mime.dart';
import 'package:flutter_file_picker/DataModel/FileResult.dart';
import 'package:uri_to_file/uri_to_file.dart';

import 'flutter_file_picker_platform_interface.dart';

/// An implementation of [FlutterFilePickerPlatform] that uses method channels.
class MethodChannelFlutterFilePicker extends FlutterFilePickerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_file_picker');

  @override
  Future<FileResult?> pickPhoto({String mimeType = "image/*"}) async {
    try {
      dynamic result = await methodChannel.invokeMethod("pickPhoto", {
        "mimeType": mimeType
      });
      if (result == null) {
        return null;
      }
      
      if (result["uri"] != null) {
        File loadedFile = await toFile(result["uri"]!);
        FileResult pickedFile = FileResult(
          uri: Uri.parse(result["uri"]), 
          path: loadedFile.path,
          mimeType: mimeType, 
        );
        return pickedFile;
      }
      
    } on Exception catch (_, e){
      throw PlatformException(code: "not supported");
    }
    
  }

  @override
  Future<List<FileResult>?> pickPhotos({String mimeType = "image/*"}) async {
   try {
      List<String>? result = await methodChannel.invokeListMethod("pickPhotos", {
        "mimeType": mimeType
      });
      print("pickPhotos result $result is type of ${result.runtimeType}");
      List<FileResult> fileList = [];
      if (result != null) {
        for (var uri in result) {
          File file = await toFile(uri ?? "");
          String? mime = lookupMimeType(file.path ?? "");
          FileResult pickedFile = FileResult(uri: Uri.parse(uri), path: file.path, mimeType: mime ?? "");
          fileList.add(pickedFile);
        }
      } 
      return fileList;
    } on Exception catch (_, e){
      throw PlatformException(code: "not supported");
    }

  }

  @override
  Future<List<FileResult>?> pickFiles ({String mimeType = "image/*", bool allowMultiple = false}) async {
    if (!allowMultiple) {
      FileResult? pickedFile = await pickPhoto(mimeType: mimeType);
      if (pickedFile != null) {
        return [pickedFile];
      } else {
        return null;
      }
    } else {
      return pickPhotos(mimeType: mimeType);
    }
  }

}
