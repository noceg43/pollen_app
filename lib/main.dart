import 'dart:isolate';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:demo_1/providers/dati_notifica.dart';
import 'package:demo_1/providers/notifications.dart';
import 'package:demo_1/providers/position.dart';
import 'package:demo_1/utils/calcolo_tipo_maggiore.dart';
import 'package:flutter/material.dart';
//import 'package:notification_channel_manager/notification_channel_manager.dart';

import 'screens/app.dart';

void lavoroInquinamento() async {
  final DateTime now = DateTime.now();
  Posizione p = await Posizione.localizza();
  final int isolateId = Isolate.current.hashCode;
  DatiNotifica? i = DatiNotifica.ottieniInquinamento(
      await Tipologia.daPosizione(p, 0), await Tipologia.daPosizione(p, 1));
  if (i != null) {
    NotificaInquinamento.instantNotify(i.stampaNomi, i.stampaLivello);
  }
  print("[$now] Hello, world! isolate=$isolateId");
}

Future<void> main() async {
  runApp(const MyApp());
  // elimina i canali
  //NotificationChannelManager.deleteAllChannels();

  // creare i canali

  AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelKey: 'notifica_particella',
        channelName: 'Notifiche per particelle sensibili',
        channelDescription:
            'Avvertono riguardo possibili aumenti nella giornata successiva'),
    NotificationChannel(
        channelKey: 'notifica_inquinamento',
        channelName: 'Notifiche per qualità aria',
        channelDescription:
            'Informano sulla quantità di particelle inquinanti di domani')
  ]);

  // creare l'alarm
  WidgetsFlutterBinding.ensureInitialized();

  await AndroidAlarmManager.initialize();
  int helloAlarmID = 0;
  await AndroidAlarmManager.periodic(
    const Duration(seconds: 10),
    helloAlarmID,
    lavoroInquinamento,
    // inviare una notifica ogni giorno a quell'ora
    /*
    const Duration(days: 1),
    startAt: DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 19, 0),
        */
  );
}
