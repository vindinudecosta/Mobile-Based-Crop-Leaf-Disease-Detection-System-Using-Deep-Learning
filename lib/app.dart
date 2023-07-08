

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home.dart' show Dashboard;

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    return MaterialApp(
      title: 'Plant Recognizer',
      theme: ThemeData.light(),
      home: const Dashboard(),
      debugShowCheckedModeBanner: false,
    );
  }
}
