import 'package:demo_1/providers/inquinamento.dart';
import 'package:flutter/material.dart';

// Contiene: costruttore che restituisce tutto il necessario per costruire il widget Inquinamento

// INPUT: dato Inquinamento grezzo e giorno
// OUTPUT: Stringhe ed icone per costruire Widget Inquinamento

class ParticellaInquinante {
  String tipo = "";
  int val;
  int lim;
  bool superato = false;
  Color valoreColore = Colors.white;
  ParticellaInquinante(this.tipo, this.val, this.lim) {
    superato = (val >= lim);
    if (superato) {
      valoreColore = Colors.red;
    }
  }
}

class FormatInquinamento {
  var particelle = <ParticellaInquinante>[];
  FormatInquinamento(Inquinamento inq, int day) {
    final oraMeteo = DateTime.now().hour;
    int getDato(List<int> datiGiorno) {
      if (day == 0) {
        return datiGiorno[oraMeteo];
      } else {
        return datiGiorno.reduce((a, b) => a + b) ~/ datiGiorno.length;
      }
    }

    particelle.add(ParticellaInquinante(
        "CO",
        getDato(inq.hourly.carbonMonoxide.sublist(24 * (day), 24 * (day + 1))),
        4000));
    particelle.add(ParticellaInquinante(
        "SO2",
        getDato(inq.hourly.sulphurDioxide.sublist(24 * (day), 24 * (day + 1))),
        40));
    particelle.add(ParticellaInquinante(
        "NO2",
        getDato(inq.hourly.nitrogenDioxide.sublist(24 * (day), 24 * (day + 1))),
        25));
    particelle.add(ParticellaInquinante("O3",
        getDato(inq.hourly.ozone.sublist(24 * (day), 24 * (day + 1))), 100));
    particelle.add(ParticellaInquinante("PM10",
        getDato(inq.hourly.pm10.sublist(24 * (day), 24 * (day + 1))), 45));
    particelle.add(ParticellaInquinante("PM25",
        getDato(inq.hourly.pm25.sublist(24 * (day), 24 * (day + 1))), 15));
  }
}
