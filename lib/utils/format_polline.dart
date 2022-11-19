import 'package:demo_1/providers/polline.dart';
import 'package:demo_1/providers/position.dart';
import 'package:flutter/material.dart';

// Contiene: costruttore che restituisce tutto il necessario per costruire il widget ItemPolline

// INPUT: dato Polline
// OUTPUT: Stringhe, icone, colori per costruire il widget

// da posizione restituisce tendenze dei 3 giorni successivi
// aggiunto controllo su stazione vuota
Future<List<Map<Polline, String>>> tendenzaDaPos(Posizione p) async {
  List<Polline> poll = await Polline.fetch();
  List<Stazione> staz = await Stazione.fetch();
  Stazione localizzata = Stazione.localizza(staz, p.lat, p.lon);
  Future<bool> checkStazione(Stazione s) async {
    List<Concentrazione> c = await Concentrazione.fetch(s);
    if (c.isEmpty) return false;
    return true;
  }

  num maxIterazioni = staz.length;
  Stazione trovata = localizzata;

  for (num i = 0; i < maxIterazioni; i++) {
    bool check = await checkStazione(trovata);
    if (check) break;
    staz.remove(trovata);
    trovata = Stazione.localizza(staz, p.lat, p.lon);
  }

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
  Color valoreColore = Colors.white;
  IconData icona = Icons.height;
  FormatPolline(Polline poll, String data) {
    valore = double.parse(data.split("_")[1]);
    tendenza = data.split("_")[0];
    nome = poll.partNameI;

    Color getValoreColore() {
      if (poll.partLow < valore && valore <= poll.partMiddle) {
        return Colors.yellow;
      }
      if (poll.partMiddle < valore && valore <= poll.partHigh) {
        return Colors.orange;
      }
      if (valore > poll.partHigh) return Colors.red;
      return Colors.white;
    }

    valoreColore = getValoreColore();

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
