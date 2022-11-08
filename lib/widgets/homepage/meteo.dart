import 'package:demo_1/providers/meteo.dart';
import 'package:flutter/material.dart';

class WidgetMeteo extends StatelessWidget {
  const WidgetMeteo({super.key, required this.m, this.offset = 0});
  final Meteo m;
  final int offset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 250,
      padding: const EdgeInsets.all(8.0),
      child: const Text("Widget meteo"),
    );
  }
}
