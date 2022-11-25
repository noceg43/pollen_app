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

// INPUT: FormatMeteo Map<Polline, Tendenza> giornaliera e List<ParticellaInquinante>
// OUTPUT: Listview con meteo e polline
class ListGiornaliera extends StatelessWidget {
  ListGiornaliera(
      {required this.m,
      required this.tend,
      required this.update,
      required this.inq,
      required this.s})
      : super(key: ObjectKey(m));
  final FormatMeteo m;
  final Map<Polline, Tendenza> tend;
  final List<ParticellaInquinante> inq;
  final Stazione s;
  final void Function() update;
  @override
  Widget build(BuildContext context) {
    // divide la tendenza nelle tipologie
    Map<Polline, Tendenza> alberi = Tendenza.getAlberi(tend);
    Map<Polline, Tendenza> erbe = Tendenza.getErbe(tend);
    Map<Polline, Tendenza> spore = Tendenza.getSpore(tend);
    // unisce le tipologie + inquinamento in una lista ordinata
    List<Map<String, dynamic>> maggiore =
        tipoMaggiore(alberi, erbe, spore, inq);

    // prende la prima tipologia e la formatta (ottiene i dati da rappresentare)
    FormatTipoGiornaliero formatTop = FormatTipoGiornaliero(maggiore.first);

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
                  color: formatTop.col,
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
                          image: DecorationImage(
                              image: formatTop.img, fit: BoxFit.fill),
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
                              Text(
                                  "ATTENZIONE \n ${formatTop.tipo} \n ${formatTop.livello}"),
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
                    listaOrdinata: maggiore,
                    staz: s,
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
