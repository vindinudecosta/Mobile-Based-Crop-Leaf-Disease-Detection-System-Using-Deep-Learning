import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class DiseaseNotification {
  final _diseaseNotification = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _diseaseNotification.requestPermission();
    final fCMToken = await _diseaseNotification.getToken();
    debugPrint('Token: $fCMToken');
  }
}
