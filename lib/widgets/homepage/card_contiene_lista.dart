import 'package:demo_1/widgets/homepage/lista_particella.dart';
import 'package:flutter/material.dart';

class CardContenitore extends StatelessWidget {
  const CardContenitore({super.key, required this.listaOrdinata});
  final List<Map<String, dynamic>> listaOrdinata;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          const Text("Indici rilevati:"),
          for (Map<String, dynamic> s in listaOrdinata) ListaPolline(data: s)
        ],
      ),
    );
  }
}
