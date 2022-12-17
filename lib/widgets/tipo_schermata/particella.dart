import 'package:demo_1/screens/particella_pagina/scheletro_particella.dart';
import 'package:demo_1/utils/calcolo_tipo_maggiore.dart';
import 'package:demo_1/utils/format_particella.dart';
import 'package:flutter/material.dart';

class ItemParticellaDaTipo extends StatelessWidget {
  const ItemParticellaDaTipo({super.key, required this.data, required this.s});
  final Map<Particella, ValoreDelGiorno> data;
  final dynamic s;
  @override
  Widget build(BuildContext context) {
    FormatParticella p = FormatParticella(data);
    Map<int, Color> ottieniColore = {
      0: const Color(0xFFD2D7DF),
      1: const Color(0xFFFFF275),
      20: const Color(0xFFFBAF55),
      30: const Color(0xFFD33C3C),
    };
    Map<int, Color> fontColore = {
      0: Colors.black,
      1: Colors.black,
      20: Colors.white,
      30: Colors.white,
    };
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: ottieniColore[p.valColore]),
          onPressed: () {
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
            height: 100,
            width: 600,
            child: Row(
              children: [
                SizedBox(
                  width: 150,
                  child: Text(
                    p.nome,
                    style: TextStyle(color: fontColore[p.valColore]),
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
                Text(
                  p.valore.toString(),
                  style: TextStyle(color: fontColore[p.valColore]),
                  textAlign: TextAlign.end,
                ),
                const Spacer(),
                Icon(
                  p.icona,
                  size: 50,
                  color: fontColore[p.valColore],
                )
              ],
            ),
          )),
    );
  }
}
