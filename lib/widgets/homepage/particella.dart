import 'package:demo_1/providers/inquinamento.dart';
import 'package:demo_1/providers/polline.dart';
import 'package:demo_1/utils/format_particella.dart';
import 'package:demo_1/utils/format_polline.dart';
import 'package:demo_1/utils/format_inquinamento.dart';
import 'package:flutter/material.dart';

// INPUT: ParticellaInquinante o Map<Polline,Tendenza>
// OUTPUT: sized box con colore, grafico, valore, tendenza prese da FormatParticella
class ItemParticella extends StatelessWidget {
  const ItemParticella({super.key, required this.data});
  final dynamic data;

  @override
  Widget build(BuildContext context) {
    FormatParticella p = FormatParticella(data);
    Map<int, double> ottieniAltezza = {0: 10, 1: 30, 2: 50, 3: 80};
    Map<int, Color> ottieniColore = {
      0: Colors.grey,
      1: Colors.yellow,
      2: Colors.orange,
      3: Colors.red
    };

    return SizedBox(
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
    );
  }
}
