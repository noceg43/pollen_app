// ignore_for_file: avoid_print

import 'package:demo_1/providers/position.dart';
import 'package:demo_1/utils/calcolo_tipo_maggiore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UltimaPosizione {
  static Future<void> salva(Posizione p) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setStringList(
        "posizione", [p.lat.toString(), p.lon.toString(), p.pos]);
  }

  static Future<Posizione> ottieni() async {
    final preferences = await SharedPreferences.getInstance();
    List<String> lista = preferences.getStringList("posizione")!;
    return Posizione(double.parse(lista[0]), double.parse(lista[1]), lista[2]);
  }
}

class DiarioDisponibile {
  static Future<void> usato() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setInt("diario", DateTime.now().day);
  }

  static Future<bool> statoUsato() async {
    final preferences = await SharedPreferences.getInstance();
    if (!preferences.containsKey("diario")) return false;
    int giorno = preferences.getInt("diario")!;
    print(DateTime.now().day == giorno);
    if (DateTime.now().day == giorno) {
      return true;
    } else {
      return false;
    }
  }
}

class Peso {
  double p = 0;
  String codice = "";

  static Future<List<Peso>> getContatore(Posizione pos) async {
    final preferences = await SharedPreferences.getInstance();
    List lista = await chiAumentare(pos);
    List<Peso> pesi = [];
    for (String s in lista) {
      final virgolato = preferences.getDouble(s) ?? 0;
      pesi.add(Peso(s, virgolato));
    }
    return pesi;
  }

  //                 DA QUALE VALORE INZIARE AD INSERIRE NEL DIARIO LE PARTICELLE
  static Future<List<String>> chiAumentare(Posizione pos) async {
    List<Tipologia> listaTip = await Tipologia.daPosizione(pos, 0);
    List<String> tip = [
      for (Map<Particella, ValoreDelGiorno> p
          in Tipologia.massimi(listaTip) ?? [])
        p.keys.first.nome
    ];
    return tip;
  }

  Peso(this.codice, this.p);
  Future<void> aumentaSingolo(double peso) async {
    final prefs = await SharedPreferences.getInstance();
    p = p + peso;
    await prefs.setDouble(codice, p);
  }

  // usare questa
  static Future<void> aumentaMultipli(Posizione pos, double peso) async {
    final preferences = await SharedPreferences.getInstance();
    List lista = await chiAumentare(pos);
    List<Peso> pesi = [];
    for (String s in lista) {
      final virgolato = preferences.getDouble(s) ?? 0;
      pesi.add(Peso(s, virgolato));
    }

    for (Peso p in pesi) {
      p.aumentaSingolo(peso);
    }
  }

  static Future<Map<String, String>> stampa(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print({for (String i in prefs.getKeys()) i: prefs.get(i).toString()});
    final snackBar = SnackBar(
      content: Text({
        for (String i in prefs.getKeys()) i: prefs.get(i).toString()
      }.toString()),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    return {for (String i in prefs.getKeys()) i: prefs.get(i).toString()};
  }

  static Future<void> elimina() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  static Future<double> getPeso(String cod) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(cod) ?? 0;
  }
}
