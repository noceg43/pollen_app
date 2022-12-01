import 'package:demo_1/main.dart';
import 'package:demo_1/providers/notifications.dart';
import 'package:flutter/material.dart';

import 'homepage/home.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Noti.initialize(flutterLocalNotificationsPlugin);
    Noti.showBigTextNotification(
        title: "New message title",
        body: "Your long body",
        fln: flutterLocalNotificationsPlugin);
    return MaterialApp(
      title: 'Flutter Alpha',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}
