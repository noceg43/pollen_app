import 'package:flutter/material.dart';

import 'homepage/home.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.theme});
  final ThemeData theme;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Alpha',
      theme: theme,
      home: const MyHomePage(),
    );
  }
}
