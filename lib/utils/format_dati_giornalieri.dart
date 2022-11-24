import 'package:demo_1/providers/inquinamento.dart';
import 'package:demo_1/utils/calcolo_tipo_maggiore.dart';
import 'package:flutter/material.dart';

import '../providers/polline.dart';

// INPUT: una tipologia Map{String,dynamic}
// OUTPUT tipo, livello, colore, icona AssetImage

class FormatTipoGiornaliero {
  String tipo = "Alberi";
  String livello = "Basso";
  Color col = Colors.yellow;
  AssetImage img = const AssetImage('assets/images/alberi.png');
  FormatTipoGiornaliero(Map<String, dynamic> data) {
    Map<int, String> livelli = {
      0: "Assente",
      1: "Basso",
      2: "Medio",
      3: "Alto"
    };

    Map<int, Color> livColori = {
      0: Colors.white,
      1: Colors.yellow,
      2: Colors.orange,
      3: Colors.red
    };
    tipo = data.keys.first;
    int valoreMedio = mediaTipologia(data.values.first);
    livello = livelli[valoreMedio]!;
    col = livColori[valoreMedio]!;
    img = AssetImage('assets/images/${tipo.toLowerCase()}.png');
  }
}
