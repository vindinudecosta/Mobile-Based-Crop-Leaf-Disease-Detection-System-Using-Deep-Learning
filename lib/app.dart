import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'root_page.dart' show RootPage;

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
      home: const RootPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
