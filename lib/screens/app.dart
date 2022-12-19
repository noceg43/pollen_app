import 'package:demo_1/providers/preferences.dart';
import 'package:demo_1/screens/intro/schermata_intro.dart';
import 'package:flutter/material.dart';

import 'homepage/home.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.theme, required this.primaVolta});
  final ThemeData theme;
  final bool primaVolta;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Alpha',
      theme: theme,
      home: (primaVolta) ? const SchermataIntro() : const MyHomePage(),
    );
  }
}
