import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';

class NotificaParticella {
  static Future<bool> instantNotify(String title, String body) async {
    final AwesomeNotifications awesomeNotifications = AwesomeNotifications();
    return awesomeNotifications.createNotification(
      content: NotificationContent(
          id: Random().nextInt(100),
          title: title,
          body: body,
          displayOnBackground: true,
          displayOnForeground: true,
          wakeUpScreen: true,
          channelKey: 'notifica_particella'),
    );
  }
}

class NotificaInquinamento {
  static Future<bool> instantNotify(String title, String body) async {
    final AwesomeNotifications awesomeNotifications = AwesomeNotifications();
    return awesomeNotifications.createNotification(
      content: NotificationContent(
          id: Random().nextInt(100),
          title: title,
          body: body,
          displayOnBackground: true,
          displayOnForeground: true,
          wakeUpScreen: true,
          channelKey: 'notifica_inquinamento'),
    );
  }
}
