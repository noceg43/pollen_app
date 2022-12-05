// ignore_for_file: avoid_print

import 'package:demo_1/providers/position.dart';
import 'package:demo_1/utils/calcolo_tipo_maggiore.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  static Future<Map<String, String>> stampa() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print({for (String i in prefs.getKeys()) i: prefs.get(i).toString()});
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
