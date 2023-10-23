import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widget/plant_notification.dart';
import 'root_page.dart' show RootPage;

final navigatorKey = GlobalKey<NavigatorState>();

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
      navigatorKey: navigatorKey,
      routes: {
        '/plant_notification': (context) => const PlantNotification(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
