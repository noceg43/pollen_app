import 'package:demo_1/providers/polline.dart';
import 'package:demo_1/providers/position.dart';
import 'package:demo_1/utils/calcolo_tipo_maggiore.dart';
import 'package:demo_1/widgets/homepage/lista_particella.dart';
import 'package:flutter/material.dart';

// INPUT: List<<Map<String,dynamic>> ordinata
// OUTPUT: Card che genera con un for una ListaPolline per ogni tipologia
class CardContenitore extends StatelessWidget {
  const CardContenitore(
      {super.key,
      required this.listaOrdinata,
      required this.staz,
      required this.p});
  final List<Tipologia> listaOrdinata;
  final Stazione staz;
  final Posizione p;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFE8F5E9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
            child: Text(
              "Particles detected:",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          for (Tipologia s in listaOrdinata)
            ListaParticella(
              data: s,
              s: staz,
              p: p,
            )
        ],
      ),
    );
  }
}
