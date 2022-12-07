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
    Map<int, double> ottieniAltezza = {0: 10, 1: 30, 20: 70, 30: 100};
    Map<int, Color> ottieniColore = {
      0: Colors.grey,
      1: const Color(0xFFF2EA1D),
      20: const Color(0xFFFBAF55),
      30: const Color(0xFFD74040),
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
      child: Container(
        height: 170,
        width: 120,
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                p.valore.toString(),
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Visibility(
                visible: p.icona != null,
                child: Icon(
                  p.icona,
                  size: 25,
                ),
              )
            ],
          ),
          const Spacer(),
          Container(
            width: 70,
            height: ottieniAltezza[p.valColore],
            decoration: BoxDecoration(
              color: ottieniColore[p.valColore],
              borderRadius: const BorderRadius.all(Radius.circular(3)),
            ),
          ),
          SizedBox(
            height: 40,
            child: Center(
              child: Text(
                p.nome,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
