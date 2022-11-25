import 'package:demo_1/providers/polline.dart';
import 'package:demo_1/widgets/homepage/lista_particella.dart';
import 'package:flutter/material.dart';

// INPUT: List<<Map<String,dynamic>> ordinata
// OUTPUT: Card che genera con un for una ListaPolline per ogni tipologia
class CardContenitore extends StatelessWidget {
  const CardContenitore(
      {super.key, required this.listaOrdinata, required this.staz});
  final List<Map<String, dynamic>> listaOrdinata;
  final Stazione staz;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          const Text("Indici rilevati:"),
          for (Map<String, dynamic> s in listaOrdinata)
            ListaParticella(
              data: s,
              s: staz,
            )
        ],
      ),
    );
  }
}
