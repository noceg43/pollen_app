import 'package:demo_1/providers/inquinamento.dart';
import 'package:demo_1/providers/per_inquinamento.dart';
import 'package:demo_1/providers/per_polline.dart';
import 'package:demo_1/providers/polline.dart';
import 'package:demo_1/providers/position.dart';
import 'package:demo_1/utils/format_dati_giornalieri.dart';
import 'package:demo_1/widgets/diario/slider.dart';
import 'package:demo_1/widgets/particella_pagina/grafo_particella.dart';
import 'package:demo_1/widgets/tipo_schermata/particella.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class DiarioSchermata extends StatefulWidget {
  const DiarioSchermata({super.key});

  @override
  State<DiarioSchermata> createState() => _DiarioSchermataState();
}

class _DiarioSchermataState extends State<DiarioSchermata> {
  double _oraValore = 24;
  double _statoFisicoValore = 50;
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
            value: _oraValore,
            max: 240,
            divisions: 24,
            label: (_oraValore / 10).round().toString(),
            onChanged: (double value) {
              setState(() {
                _oraValore = value;
              });
            },
          ),
          Slider(
            value: _statoFisicoValore < 10 ? 10 : _statoFisicoValore,
            max: 100,
            divisions: 10,
            label: (_statoFisicoValore / 10).round().toString(),
            onChanged: (double value) {
              setState(() {
                if (value < 10) {
                  print("soottoto");
                }
                _statoFisicoValore = value;
              });
            },
          ),
          TextButton(
              onPressed: (() {
                print("premuto");
              }),
              child: const Text("Conferma"))
        ],
      ),
    );
  }
}
