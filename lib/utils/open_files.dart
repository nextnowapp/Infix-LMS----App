import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

Future<void> openAppFile(String path) async {
  final filePath = path;

  try {
    final result = await OpenFile.open(filePath);
    if (result.type == ResultType.done) {
      print('File opened successfully!');
    } else {
      print('Failed to open file with installed apps: ${result.message}');
      // Attempt to open in browser if no suitable app is available
      _openInBrowser(filePath);
    }
  } on PlatformException catch (error) {
    print('Error opening file: ${error.message}');
    // Attempt to open in browser if there is a platform exception
    _openInBrowser(filePath);
  }
}

Future<void> _openInBrowser(String filePath) async {
  final fileUri = Uri.file(filePath);
  final fileUrl = fileUri.toString();

  try {
    if (await canLaunch(fileUrl)) {
      await launch(fileUrl);
    } else {
      _showErrorSnackbar('No application available to open this file.');
    }
  } catch (e) {
    _showErrorSnackbar('Failed to open file in the browser.');
  }
}

void _showErrorSnackbar(String message) {
  Get.snackbar(
    'Error',
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.red,
    colorText: Colors.white,
    margin: EdgeInsets.all(10),
    duration: Duration(seconds: 3),
  );
}
