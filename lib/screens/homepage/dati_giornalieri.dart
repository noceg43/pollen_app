// contiene listview del giorno, widget meteo e polline

import 'package:demo_1/providers/polline.dart';
import 'package:demo_1/utils/format_meteo.dart';
import 'package:demo_1/utils/format_polline.dart';
import 'package:demo_1/widgets/homepage/meteo.dart';
import 'package:demo_1/widgets/homepage/polline.dart';
import 'package:flutter/material.dart';

// Contiene Listview del giorno con WidgetMeteo e WidgetPolline

// INPUT: FormatMeteo e tendenza giornaliera
// OUTPUT: Listview con meteo e polline
class ListGiornaliera extends StatelessWidget {
  const ListGiornaliera({super.key, required this.m, required this.tend});
  final FormatMeteo m;
  final Map<Polline, String> tend;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tend.length + 1,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, index) {
        if (index == 0) {
          return WidgetMeteo(m: m);
        }
        return ItemPolline(
          p: FormatPolline(
              tend.keys.elementAt(index - 1), tend.values.elementAt(index - 1)),
        );

        /*
        return ItemPolline(
          p: FormatPolline(
              tend.keys.elementAt(index), tend.values.elementAt(index)),
        );
        */
      },
    );
  }
}
