import 'package:demo_1/providers/inquinamento.dart';
import 'package:flutter/material.dart';

// Contiene: costruttore che restituisce tutto il necessario per costruire il widget Inquinamento

// INPUT: ParticellaInquinante
// OUTPUT: Stringhe ed icone per costruire Widget Inquinamento

class FormatInquinamento {
  String tipo = "";
  int val = 0;
  Color valoreColore = Colors.white;
  FormatInquinamento(ParticellaInquinante p) {
    tipo = p.tipo;
    val = p.val;
    if (p.superato) valoreColore = Colors.red;
  }
}
