import 'dart:convert';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:demo_1/providers/cache.dart';
import 'package:demo_1/providers/dati_notifica.dart';
import 'package:demo_1/providers/notifications.dart';
import 'package:demo_1/providers/position.dart';
import 'package:demo_1/providers/preferences.dart';
import 'package:demo_1/utils/calcolo_tipo_maggiore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_theme/json_theme.dart';
//import 'package:notification_channel_manager/notification_channel_manager.dart';

import 'screens/app.dart';
import 'package:http/http.dart' as http;

void lavoroInquinamento() async {
  //final DateTime now = DateTime.now();
  //print("inizio alle $now");

  Posizione p = await UltimaPosizione.ottieni();
  //print(p.pos);
  //final int isolateId = Isolate.current.hashCode;
  DatiNotifica? i = DatiNotifica.ottieniInquinamento(
      p, await Tipologia.daPosizione(p, 0), await Tipologia.daPosizione(p, 1));
  if (await PreferencesNotificaInquinamento.ottieni()) {
    if (i != null) {
      NotificaInquinamento.instantNotify(i.stampaNomi, i.stampaLivello);
    } else {
      String urlOra = 'http://worldtimeapi.org/api/timezone/Europe/London';
      //final response = await http.get(Uri.parse(urlMeteo));
      var file = await GiornalieraCacheManager.instance.getSingleFile(urlOra);

      NotificaInquinamento.instantNotify(
          "tutto normale a ${jsonDecode(await file.readAsString())["datetime"]}",
          "confermo tutto normale");
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // disabilita rotazione automatica
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // ottenere il tema
  final themeStr =
      await rootBundle.loadString("assets/theme/appainter_theme.json");
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;

  runApp(MyApp(theme: theme, primaVolta: await PrimaVolta.ottieni()));

  // elimina i canali
  //NotificationChannelManager.deleteAllChannels();

  // pulisce la cache
  //GiornalieraCacheManager.instance.emptyCache;

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
    //const Duration(minutes: 20),
    const Duration(days: 1),
    exact: true,
    allowWhileIdle: true,
    wakeup: true,
    rescheduleOnReboot: true,
    helloAlarmID,
    lavoroInquinamento,
    // inviare una notifica ogni giorno a quell'ora

    startAt: (DateTime.now().isAfter(DateTime(DateTime.now().year,
            DateTime.now().month, DateTime.now().day, 19, 0)))
        ? DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day + 1, 19, 0)
        : DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 19, 0),
  );
}
