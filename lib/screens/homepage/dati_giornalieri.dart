// contiene listview del giorno, widget meteo e polline

import 'package:demo_1/providers/meteo.dart';
import 'package:demo_1/widgets/homepage/meteo.dart';
import 'package:flutter/material.dart';

class ListGiornaliera extends StatelessWidget {
  const ListGiornaliera({super.key, required this.offset, required this.m});
  final num offset;
  final Meteo m;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [WidgetMeteo(m: m)],
    );
  }
}
