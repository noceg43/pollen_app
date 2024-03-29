import 'package:demo_1/providers/polline.dart';
import 'package:demo_1/providers/position.dart';
import 'package:flutter/material.dart';

// Contiene: costruttore che restituisce tutto il necessario per costruire il widget ItemPolline

// INPUT: dato Polline
// OUTPUT: Stringhe, icone, colori per costruire il widget

// da posizione restituisce tendenze dei 3 giorni successivi
// aggiunto controllo su stazione vuota

Future<List<Map<Polline, Tendenza>>> tendenzaDaPos(Posizione p) async {
  List<Polline> poll = await Polline.fetch();

  Stazione trovata = await Stazione.trovaStaz(p);

  return [
    await tendenza(trovata, poll, offset: 0),
    await tendenza(trovata, poll, offset: 1),
    await tendenza(trovata, poll, offset: 2)
  ];
}

class FormatPolline {
  num valore = 0;
  String tendenza = "";
  String nome = "";
  int valoreColore = 0;
  IconData icona = Icons.height;
  FormatPolline(Map<Polline, Tendenza> data) {
    valore = data.values.first.valore;
    tendenza = data.values.first.freccia;
    nome = data.keys.first.partNameI;

    valoreColore = data.values.first.gruppoValore;

    IconData getIcona() {
      if (tendenza == "Diminuzione") {
        return Icons.arrow_downward;
      } else if (tendenza == "Aumento") {
        return Icons.arrow_upward;
      } else {
        return Icons.height;
      }
    }

    icona = getIcona();
  }
}
