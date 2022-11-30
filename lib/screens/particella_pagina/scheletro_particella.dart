import 'package:demo_1/providers/inquinamento.dart';
import 'package:demo_1/providers/per_inquinamento.dart';
import 'package:demo_1/providers/per_polline.dart';
import 'package:demo_1/providers/polline.dart';
import 'package:demo_1/providers/position.dart';
import 'package:demo_1/widgets/particella_pagina/grafo_particella.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ScheletroParticella extends StatelessWidget {
  const ScheletroParticella({super.key, required this.p, required this.s});
  final dynamic p;
  final dynamic s;
  @override
  Widget build(BuildContext context) {
    Future<Map<DateTime, num>> futura;

    if (p is ParticellaInquinante && s is Posizione) {
      futura = PerInquinamento.fetch(s.lat, s.lon, p);
    } else {
      futura = PerPolline.fetch(s, p);
    }

    return Scaffold(
      appBar: AppBar(
        //title: Text(p.partNameI),
        leading: const BackButton(),
      ),
      body: FutureBuilder<Map<DateTime, num>>(
          future: futura,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return LineChartSample2(
                p: p,
                listVal: snapshot.data!,
              );
            } else {
              if (snapshot.hasError) {
                print(snapshot.error);
              }
              return Container();
            }
          }),
    );
  }
}
