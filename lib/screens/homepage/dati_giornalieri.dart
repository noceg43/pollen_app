// contiene listview del giorno, widget meteo e polline

import 'package:demo_1/providers/inquinamento.dart';
import 'package:demo_1/providers/polline.dart';
import 'package:demo_1/utils/calcolo_tipo_maggiore.dart';
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
    //non devono stare qua
    Map<Polline, Tendenza> alberi = Tendenza.getAlberi(tend);
    Map<Polline, Tendenza> erbe = Tendenza.getErbe(tend);
    Map<Polline, Tendenza> spore = Tendenza.getSpore(tend);
    List<String> maggiore = tipoMaggiore(alberi, erbe, spore, inq);
    print(maggiore);
    String livello = "Basso";
    Map<int, String> livelli = {
      0: "Assente",
      1: "Basso",
      2: "Medio",
      3: "Alto"
    };
    if (maggiore[0] == "Alberi") {
      livello = livelli[valoreMassimoRaggiunto(alberi)]!;
    }
    if (maggiore[0] == "Erbe") {
      livello = livelli[valoreMassimoRaggiunto(erbe)]!;
    }
    if (maggiore[0] == "Spore") {
      livello = livelli[valoreMassimoRaggiunto(spore)]!;
    }
    if (maggiore[0] == "Inquinamento") {
      livello = livelli[valoreMassimoRaggiunto(inq)]!;
    }
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
                  height: 300,
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
                              child: WidgetMeteo(
                                m: m,
                              )),
                          const Spacer(),
                          Row(
                            children: [
                              Container(
                                child: Text(
                                    "ATTENZIONE \n ${maggiore[0]} \n $livello"),
                              ),
                            ],
                          ),
                          const Spacer()
                        ],
                      )
                    ],
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0.0, -40.0),
                  child: Card(
                    child: Column(
                      children: [
                        for (int i = 0; i < 10; i++)
                          Container(
                            height: 100,
                            margin: const EdgeInsets.all(15.0),
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                border: Border.all(color: Colors.blueAccent)),
                          )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/*

            Container(
              height: 300,
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
            Positioned(
              top: 275,
              left: 0,
              right: 0,
              child: Card(
                child: Column(
                  children: [
                    for (int i = 0; i < 10; i++)
                      Container(
                        height: 100,
                        margin: const EdgeInsets.all(15.0),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            border: Border.all(color: Colors.blueAccent)),
                      )
                  ],
                ),
              ),
            ),

*/