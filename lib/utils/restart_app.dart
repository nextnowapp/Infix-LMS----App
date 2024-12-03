import 'package:flutter/material.dart';
import 'package:lms_flutter_app/main.dart';

class RestartApp extends StatelessWidget {
  final Widget myApp;

  const RestartApp({super.key, required this.myApp});

  static void restartApp(BuildContext context) {
    final newKey = UniqueKey();
    runApp(
      MaterialApp(
        key: newKey,
        home: MyApp(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return myApp;
  }
}
