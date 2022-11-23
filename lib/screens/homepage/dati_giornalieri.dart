// contiene listview del giorno, widget meteo e polline

import 'package:demo_1/providers/inquinamento.dart';
import 'package:demo_1/providers/polline.dart';
import 'package:demo_1/utils/calcolo_tipo_maggiore.dart';
import 'package:demo_1/utils/format_dati_giornalieri.dart';
import 'package:demo_1/utils/format_inquinamento.dart';
import 'package:demo_1/utils/format_meteo.dart';
import 'package:demo_1/utils/format_polline.dart';
import 'package:demo_1/widgets/homepage/card_contiene_lista.dart';
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
    Map<String, dynamic> totaleParticelle = {
      "Alberi": alberi,
      "Erbe": erbe,
      "Spore": spore,
      "Inquinamento": inq
    };
    List<dynamic> data = formatDatiGiornalieri(maggiore, totaleParticelle);

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
                // Back della schermata
                Container(
                  height: 300,
                  color: data[2],
                  child: Row(
                    children: [
                      const Spacer(),
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(5, 5),
                            ),
                          ],
                          image:
                              DecorationImage(image: data[3], fit: BoxFit.fill),
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
                              Text("ATTENZIONE \n ${data[0]} \n ${data[1]}"),
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
                  child: CardContenitore(
                    ordinato: maggiore,
                    totaleParticelle: totaleParticelle,
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
