import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_file_picker/DataModel/FileResult.dart';
import 'package:flutter_file_picker/flutter_file_picker.dart';
import 'package:uri_to_file/uri_to_file.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _FilePickerPlugin = FlutterFilePickerPlatform.instance;
  List<File> loadedFiles = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  FileResult? result = await _FilePickerPlugin.pickPhoto(mimeType: 'jpg');
                  setState(() {
                    loadedFiles.add(File(result?.path ?? ""));
                  });
                },
                child: Text("PickPhoto"),
              ),
              ElevatedButton(
                onPressed: () async {
                  List<FileResult>? result = await _FilePickerPlugin.pickPhotos(
                    mimeType: "image/*"
                  );
                  print("onpressed multiple ${result?.length}");
                  for (var value in result!) {
                    loadedFiles.add(File(value?.path ?? ""));
                  }
                  setState(() { });
                },
                child: Text("Pick Multiple Photo"),
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    loadedFiles.clear();
                  });
                },
                child: Text("Clear Selected Photos"),
              ),
              if (loadedFiles.isEmpty)
                const CircularProgressIndicator()
              else
                SizedBox(
                  height: 500,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    itemCount: loadedFiles.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: 100,
                        child: Image.file(loadedFiles[index]),
                      );
                    }, 
                  ),
                )
            ],
          )
        ),
      ),
    );
  }


}
