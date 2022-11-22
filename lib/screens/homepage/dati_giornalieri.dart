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
        child: SingleChildScrollView(
          key: PageStorageKey(key),
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 250,
                    color: Colors.green,
                    child: Row(
                      children: [
                        const Spacer(),
                        Material(
                          elevation: 10,
                          child: Container(
                            height: 150,
                            width: 150,
                            color: Colors.amber,
                          ),
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            Material(
                              elevation: 10,
                              child: Container(
                                height: 100,
                                width: 225,
                                color: Colors.red,
                              ),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                Container(
                                  height: 100,
                                  width: 225,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                            const Spacer()
                          ],
                        )
                      ],
                    ),
                  ),
                  for (int i = 0; i < 10; i++)
                    Container(
                      height: 100,
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          border: Border.all(color: Colors.blueAccent)),
                    ),
                ],
              ),
            ],
          ),
        ));
  }
}

/*

Stack(
        children: [
          ListView.builder(
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
          Container(
            height: 100,
            width: 100,
            color: Colors.green,
          ),
        ],
      ),

*/