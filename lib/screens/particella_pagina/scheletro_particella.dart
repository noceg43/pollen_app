import 'package:demo_1/utils/calcolo_tipo_maggiore.dart';
import 'package:demo_1/widgets/particella_pagina/grafo_particella.dart';
import 'package:flutter/material.dart';

class ScheletroParticella extends StatelessWidget {
  const ScheletroParticella({super.key, required this.p, required this.s});
  final Particella p;
  final dynamic s;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text(p.partNameI),
        leading: const BackButton(),
      ),
      body: FutureBuilder<Map<DateTime, num>>(
          future: Tipologia.daParticella(s, p),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return LineChartSample2(
                p: p,
                listVal: snapshot.data!,
              );
            } else {
              if (snapshot.hasError) {
                //print(snapshot.error);
                const Text("errore");
              }
              return Container();
            }
          }),
    );
  }
}
