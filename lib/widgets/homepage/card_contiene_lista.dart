import 'package:demo_1/widgets/homepage/lista_polline.dart';
import 'package:flutter/material.dart';

class CardContenitore extends StatelessWidget {
  const CardContenitore(
      {super.key, required this.ordinato, required this.totaleParticelle});
  final List<String> ordinato;
  final Map<String, dynamic> totaleParticelle;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          const Text("Indici rilevati:"),
          for (String s in ordinato)
            ListaPolline(
              data: totaleParticelle[s],
              tipo: s,
            )
        ],
      ),
    );
  }
}
