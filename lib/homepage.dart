import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey _widgetKey = GlobalKey();

  Future<void> captureAndShareScreenshot() async {
    try {
      RenderRepaintBoundary boundary = _widgetKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        Uint8List bytes = byteData.buffer.asUint8List();
        final tempDir = await getTemporaryDirectory();
        final file = await File('${tempDir.path}/screenshot.png').create();
        await file.writeAsBytes(bytes);
        await Share.shareFiles([file.path], text: 'Check out this screenshot!');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screenshot and Share'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: RepaintBoundary(
              key: _widgetKey,
              child: Container(
                color: const Color.fromARGB(255, 247, 239, 214),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Wrapped Widget',
                        style: TextStyle(fontSize: 24),
                      ),
                      Icon(
                        Icons.catching_pokemon,
                        size: 60,
                      ),
                      Text(
                        'You\'ll get a screenshot of this widget wrapped in a RepaintBoundary.',
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: ElevatedButton(
              onPressed: captureAndShareScreenshot,
              child: const Text('Capture and Share'),
            ),
          ),
        ],
      ),
    );
  }
}
