import 'package:demo_1/providers/inquinamento.dart';

// Contiene: costruttore che restituisce tutto il necessario per costruire il widget Inquinamento

// INPUT: ParticellaInquinante
// OUTPUT: Stringhe ed icone per costruire Widget Inquinamento

class FormatInquinamento {
  String tipo = "";
  num val = 0;
  int valoreColore = 0;
  FormatInquinamento(ParticellaInquinante p) {
    tipo = p.tipo;
    val = p.val;
    if (p.superato) valoreColore = 3;
  }
}
