// contiene listview del giorno, widget meteo e polline

import 'package:demo_1/providers/inquinamento.dart';
import 'package:demo_1/providers/polline.dart';
import 'package:demo_1/utils/format_inquinamento.dart';
import 'package:demo_1/utils/format_meteo.dart';
import 'package:demo_1/utils/format_polline.dart';
import 'package:demo_1/widgets/homepage/inquinamento.dart';
import 'package:demo_1/widgets/homepage/meteo.dart';
import 'package:demo_1/widgets/homepage/polline.dart';
import 'package:flutter/material.dart';

// Contiene Listview del giorno con WidgetMeteo e WidgetPolline

// INPUT: FormatMeteo e tendenza giornaliera
// OUTPUT: Listview con meteo e polline
class ListGiornaliera extends StatelessWidget {
  ListGiornaliera(
      {required this.m,
      required this.tend,
      required this.update,
      required this.inq})
      : super(key: ObjectKey(m));
  final FormatMeteo m;
  final Map<Polline, Tendenza> tend;
  final List<ParticellaInquinante> inq;
  final void Function() update;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        update();
      },
      child: ListView.builder(
        key: PageStorageKey(key),
        itemCount: tend.length + 2 + inq.length,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, index) {
          // primo elemento sarà il meteo
          if (index == 0) {
            return WidgetMeteo(m: m);
          }
          if (index == 1) {
            return const SizedBox(
              height: 20,
            );
          }
          if (index >= (tend.length + 2)) {
            return ItemInquinamento(
                p: FormatInquinamento(inq[index - (tend.length + 2)]));
          }
          return ItemPolline(
            p: FormatPolline(tend.keys.elementAt(index - 2),
                tend.values.elementAt(index - 2)),
          );
        },
      ),
    );
  }
}
