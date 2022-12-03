import 'package:demo_1/utils/calcolo_tipo_maggiore.dart';
import 'package:flutter/material.dart';

// INPUT: una tipologia Map{String,dynamic}
// OUTPUT tipo, livello, colore, icona AssetImage

class FormatTipoGiornaliero {
  String tipo = "Alberi";
  String livello = "Basso";
  Color col = Colors.yellow;
  AssetImage img = const AssetImage('assets/images/alberi.png');

  FormatTipoGiornaliero(Tipologia data) {
    Map<int, String> livelli = {
      0: "Molto Basso",
      1: "Basso",
      20: "Medio",
      30: "Alto"
    };

    Map<int, Color> livColori = {
      0: Colors.white,
      1: Colors.yellow,
      20: Colors.orange,
      30: Colors.red
    };
    tipo = data.nome;
    int valoreMedio = data.mediaNuova();
    if (valoreMedio < 20 && valoreMedio > 1) valoreMedio = 20;
    if (valoreMedio < 30 && valoreMedio > 20) valoreMedio = 30;
    livello = livelli[valoreMedio]!;
    col = livColori[valoreMedio]!;
    img = AssetImage('assets/images/${tipo.toLowerCase()}.png');
  }
}
