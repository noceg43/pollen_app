import 'package:demo_1/providers/polline.dart';
import 'package:flutter/material.dart';

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
