import 'package:demo_1/providers/inquinamento.dart';
import 'package:demo_1/providers/position.dart';
import 'package:demo_1/utils/calcolo_tipo_maggiore.dart';
import 'package:demo_1/utils/format_dati_giornalieri.dart';
import 'package:demo_1/widgets/tipo_schermata/particella.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class TipoSchermata extends StatelessWidget {
  const TipoSchermata(
      {super.key,
      required this.tipologia,
      required this.s,
      required this.formTipo,
      required this.localizzato});
  final Tipologia
      tipologia; // Lista di particella inquinante oppure di map polline-tendenza
  final dynamic s; // posizione oppure stazione
  final FormatTipoGiornaliero formTipo;
  final Posizione localizzato;
  @override
  Widget build(BuildContext context) {
    Posizione posizione;
    if (tipologia.nome == "Inquinamento" && s is Posizione) {
      posizione = s;
    } else {
      posizione = Posizione(s.latitude, s.longitude, s.statenameI);
    }
    Map<String, String> titolo = {
      "Alberi": "Polline degli alberi",
      "Erbe": "Polline delle erbe",
      "Spore": "Spore",
      "Inquinamento": "Inquinamento"
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(titolo[tipologia.nome]!),
        leading: const BackButton(),
      ),
      backgroundColor: const Color(0xFFE8F5E9),
      body: ListView(
        children: [
          const SizedBox(
            height: 80,
          ),
          Card(
            elevation: 10,
            color: const Color(0xFFF1F1F1),
            child: Column(
              children: [
                Row(
                  children: [
                    Transform.translate(
                      offset: const Offset(0.0, -60.0),
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          image: DecorationImage(
                              image: formTipo.img, fit: BoxFit.fill),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0.0, -15.0),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: (tipologia.nome == "Inquinamento")
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Recuperati dalla posizione:",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                  Row(
                                    children: [
                                      Text(localizzato.pos,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                      const Icon(Icons.location_on)
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        "Con una precisione di ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                      Text(
                                        "11km",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Recuperati dalla stazione di:",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                  Row(
                                    children: [
                                      Text(posizione.pos,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                      const Icon(Icons.location_on)
                                    ],
                                  ),
                                  Visibility(
                                    visible: (GeolocatorPlatform.instance
                                            .distanceBetween(
                                                localizzato.lat.toDouble(),
                                                localizzato.lon.toDouble(),
                                                posizione.lat.toDouble(),
                                                posizione.lon.toDouble()) !=
                                        0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.baseline,
                                      textBaseline: TextBaseline.alphabetic,
                                      children: [
                                        Text(
                                          "Distante: ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                        Text(
                                          "${(GeolocatorPlatform.instance.distanceBetween(localizzato.lat.toDouble(), localizzato.lon.toDouble(), posizione.lat.toDouble(), posizione.lon.toDouble()) / 1000).toStringAsFixed(2)}km",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
                for (Map<Particella, ValoreDelGiorno> el in tipologia.lista)
                  Transform.translate(
                    offset: const Offset(0.0, -30.0),
                    child: ItemParticellaDaTipo(
                      data: el,
                      s: s,
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
