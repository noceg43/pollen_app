import 'package:demo_1/providers/inquinamento.dart';
import 'package:demo_1/utils/calcolo_tipo_maggiore.dart';
import 'package:flutter/material.dart';

import '../providers/polline.dart';

// INPUT: alberi, erbe, spore, inq
// OUTPUT massimo, il suo valore ed icona AssetImage
/*
List<dynamic> formatDatiGiornalieri(List<Map<String, dynamic>> maggiore) {
  String livello = "Basso";
  Map<int, String> livelli = {0: "Assente", 1: "Basso", 2: "Medio", 3: "Alto"};
  Map<int, Color> livColori = {
    0: Colors.white,
    1: Colors.yellow,
    2: Colors.orange,
    3: Colors.red
  };
  String mag = maggiore[0];
  Color col = Colors.yellow;
  AssetImage img = const AssetImage('assets/images/alberi.png');
  if (mag == "Alberi") {
    livello = livelli[valoreMassimoRaggiunto(totaleParticelle["Alberi"])]!;
    col = livColori[valoreMassimoRaggiunto(totaleParticelle["Alberi"])]!;
  }
  if (mag == "Erbe") {
    livello = livelli[valoreMassimoRaggiunto(totaleParticelle["Erbe"])]!;
    col = livColori[valoreMassimoRaggiunto(totaleParticelle["Erbe"])]!;

    img = const AssetImage('assets/images/erbe.png');
  }
  if (mag == "Spore") {
    livello = livelli[valoreMassimoRaggiunto(totaleParticelle["Spore"])]!;
    col = livColori[valoreMassimoRaggiunto(totaleParticelle["Spore"])]!;

    img = const AssetImage('assets/images/spore.png');
  }
  if (mag == "Inquinamento") {
    livello =
        livelli[valoreMassimoRaggiunto(totaleParticelle["Inquinamento"])]!;
    col = livColori[valoreMassimoRaggiunto(totaleParticelle["Inquinamento"])]!;

    img = const AssetImage('assets/images/inquinamento.png');
  }
  return [mag, livello, col, img];
}
*/

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
