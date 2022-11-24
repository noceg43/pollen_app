import 'package:demo_1/providers/inquinamento.dart';
import 'package:demo_1/utils/format_inquinamento.dart';
import 'package:demo_1/utils/format_polline.dart';
import 'package:flutter/material.dart';

// INPUT: ParticellaInquinante o Map<Polline,Tendenza>
// OUTPUT: ha la logica per restituire rispettivamente da FormatInquinamento o FormatPolline
class FormatParticella {
  int lunghezza = 0;
  String nome = "";
  num valore = 0;
  int valColore = 0;
  IconData? icona;

  FormatParticella(dynamic data) {
    if (data is ParticellaInquinante) {
      FormatInquinamento i = FormatInquinamento(data);
      nome = i.tipo;
      valore = i.val;
      valColore = i.valoreColore;
    } else {
      FormatPolline p = FormatPolline(data);
      nome = p.nome;
      valore = p.valore;
      valColore = p.valoreColore;
      icona = p.icona;
    }
  }
}
