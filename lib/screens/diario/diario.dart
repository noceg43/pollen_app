import 'package:demo_1/providers/inquinamento.dart';
import 'package:demo_1/providers/per_inquinamento.dart';
import 'package:demo_1/providers/per_polline.dart';
import 'package:demo_1/providers/polline.dart';
import 'package:demo_1/providers/position.dart';
import 'package:demo_1/providers/preferences.dart';
import 'package:demo_1/utils/format_dati_giornalieri.dart';
import 'package:demo_1/widgets/diario/slider.dart';
import 'package:demo_1/widgets/particella_pagina/grafo_particella.dart';
import 'package:demo_1/widgets/tipo_schermata/particella.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class DiarioSchermata extends StatefulWidget {
  const DiarioSchermata({super.key, required this.pos});
  final Posizione pos;
  @override
  State<DiarioSchermata> createState() => _DiarioSchermataState();
}

class _DiarioSchermataState extends State<DiarioSchermata> {
  double oraValore = 24;
  double statoFisicoValore = 5;

  double calcolaPeso() {
    return (statoFisicoValore / 10) *
        0.0625 *
        (16 - (oraValore > 16 ? 16 : oraValore) + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text(p.partNameI),
        leading: const BackButton(),
        title: const Text("Diario"),
      ),
      body: ListView(
        children: [
          Slider(
            value: oraValore,
            max: 24,
            divisions: 24,
            label: (oraValore).round().toString(),
            onChanged: (double value) {
              setState(() {
                if (value < 1) value = 1;
                oraValore = value;
              });
            },
          ),
          Slider(
            value: statoFisicoValore,
            max: 10,
            divisions: 10,
            label: (statoFisicoValore).round().toString(),
            onChanged: (double value) {
              setState(() {
                if (value < 1) value = 1;
                statoFisicoValore = value;
              });
            },
          ),
          TextButton(
              onPressed: (() {
                print("${calcolaPeso()} $oraValore $statoFisicoValore ");
                print(widget.pos.pos);
                Peso.aumentaMultipli(widget.pos, calcolaPeso());
              }),
              child: const Text("Conferma"))
        ],
      ),
    );
  }
}