import 'package:demo_1/screens/particella_pagina/scheletro_particella.dart';
import 'package:demo_1/utils/calcolo_tipo_maggiore.dart';
import 'package:demo_1/utils/format_particella.dart';
import 'package:flutter/material.dart';

// INPUT: ParticellaInquinante o Map<Polline,Tendenza>
// OUTPUT: sized box con colore, grafico, valore, tendenza prese da FormatParticella
class ItemParticella extends StatelessWidget {
  const ItemParticella({super.key, required this.data, required this.s});
  final Map<Particella, ValoreDelGiorno> data;
  final dynamic s;
  @override
  Widget build(BuildContext context) {
    FormatParticella p = FormatParticella(data);
    Map<int, double> ottieniAltezza = {0: 10, 1: 30, 20: 50, 30: 80};
    Map<int, Color> ottieniColore = {
      0: Colors.grey,
      1: Colors.yellow,
      20: Colors.orange,
      30: Colors.red
    };

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScheletroParticella(
              s: s,
              p: data.keys.first,
            ),
          ),
        );
      },
      child: SizedBox(
        height: 150,
        width: 100,
        child: Column(children: [
          Row(
            children: [
              Text(p.valore.toString()),
              Icon(
                p.icona,
                size: 25,
              )
            ],
          ),
          const Spacer(),
          Container(
            width: 50,
            height: ottieniAltezza[p.valColore],
            color: ottieniColore[p.valColore],
          ),
          Text(p.nome),
        ]),
      ),
    );
  }
}
