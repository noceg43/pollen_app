import 'package:demo_1/utils/calcolo_tipo_maggiore.dart';
import 'package:flutter/material.dart';

// INPUT: ParticellaInquinante o Map<Polline,Tendenza>
// OUTPUT: ha la logica per restituire rispettivamente da FormatInquinamento o FormatPolline
class FormatParticella {
  String nome = "";
  num valore = 0;
  int valColore = 0;
  IconData? icona;
  FormatParticella(Map<Particella, ValoreDelGiorno> data) {
    nome = data.keys.first.nome;
    valore = data.values.first.valore;
    valColore = data.values.first.gruppoValore;
    if (data.keys.first.tipo != "Inquinamento") {
      if (data.values.first.tendenza == "Diminuzione") {
        icona = Icons.arrow_downward;
      } else if (data.values.first.tendenza == "Aumento") {
        icona = Icons.arrow_upward;
      } else {
        icona = Icons.height;
      }
    }
  }
}
