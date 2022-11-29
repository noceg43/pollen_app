import 'package:demo_1/screens/particella_pagina/scheletro_particella.dart';
import 'package:demo_1/utils/format_particella.dart';
import 'package:flutter/material.dart';

class ItemParticellaDaTipo extends StatelessWidget {
  const ItemParticellaDaTipo({super.key, required this.data, required this.s});
  final dynamic data;
  final dynamic s;
  @override
  Widget build(BuildContext context) {
    FormatParticella p = FormatParticella(data);
    Map<int, Color> ottieniColore = {
      0: Colors.grey,
      1: Colors.yellow,
      2: Colors.orange,
      3: Colors.red
    };

    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: ottieniColore[p.valColore]),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScheletroParticella(
                s: s,
                p: p.data,
              ),
            ),
          );
        },
        child: Container(
          height: 100,
          width: 600,
          child: Row(
            children: [
              Text(p.nome),
              Spacer(),
              Text(p.valore.toString()),
              Spacer(),
              Icon(
                p.icona,
                size: 50,
              )
            ],
          ),
        ));
  }
}
