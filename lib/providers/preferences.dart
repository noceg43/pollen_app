// ignore_for_file: avoid_print

import 'package:demo_1/providers/position.dart';
import 'package:demo_1/utils/calcolo_tipo_maggiore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UltimaPosizione {
  static Future<void> salva(Posizione p) async {
    /*
    final preferences = await SharedPreferences.getInstance();
    preferences.setStringList(
        "posizione", [p.lat.toString(), p.lon.toString(), p.pos]);
    */
    const storage = FlutterSecureStorage();
    await storage.write(key: 'posizione', value: p.pos);
    await storage.write(key: 'latitudine', value: p.lat.toString());
    await storage.write(key: 'longitudine', value: p.lon.toString());
  }

  static Future<Posizione> ottieni() async {
    /*
    final preferences = await SharedPreferences.getInstance();
    List<String> lista = preferences.getStringList("posizione")!;
    return Posizione(double.parse(lista[0]), double.parse(lista[1]), lista[2]);
    */
    const storage = FlutterSecureStorage();
    Map<String, String> tutto = await storage.readAll();
    String? pos = tutto['posizione'];
    String? lat = tutto['latitudine'];
    String? lon = tutto['longitudine'];

    return Posizione(double.parse(lat!), double.parse(lon!), pos!);
  }
}

class PreferencesNotificaParticelle {
  static Future<void> modifica(bool val) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setBool("particelle", val);
  }

  static Future<bool> ottieni() async {
    final preferences = await SharedPreferences.getInstance();
    if (!preferences.containsKey("particelle")) {
      modifica(true);
      return true;
    }
    bool val = preferences.getBool("particelle")!;
    return val;
  }
}

class PreferencesNotificaInquinamento {
  static Future<void> modifica(bool val) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setBool("inquinamento", val);
  }

  static Future<bool> ottieni() async {
    final preferences = await SharedPreferences.getInstance();
    if (!preferences.containsKey("inquinamento")) {
      preferences.setBool("inquinamento", true);
      return true;
    }
    bool val = preferences.getBool("inquinamento")!;
    return val;
  }
}

class DiarioDisponibile {
  static Future<void> usato() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setStringList("diario",
        [DateTime.now().month.toString(), DateTime.now().day.toString()]);
  }

  static Future<bool> statoUsato() async {
    final preferences = await SharedPreferences.getInstance();
    if (!preferences.containsKey("diario")) return false;
    List<String> data = preferences.getStringList("diario")!;

    if (DateTime.now().month.toString() == data[0] &&
        DateTime.now().day.toString() == data[1]) {
      return true;
    } else {
      return false;
    }
  }
}

class PrimaVolta {
  static Future<void> finitaIntro() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setBool("primavolta", false);
  }

  static Future<bool> ottieni() async {
    final preferences = await SharedPreferences.getInstance();
    if (!preferences.containsKey("primavolta")) {
      preferences.setBool("primavolta", true);
      return true;
    }
    return preferences.getBool("primavolta")!;
  }
}

class Peso {
  num statoFisicoValore;
  num oraValore;
  String codice = "";
  DateTime giorno;

  //                 DA QUALE VALORE INZIARE AD INSERIRE NEL DIARIO LE PARTICELLE
  static Future<List<String>> chiAumentareNo(Posizione pos) async {
    List<Tipologia> listaTip = await Tipologia.daPosizione(pos, 0);
    List<String> tip = [
      for (Map<Particella, ValoreDelGiorno> p
          in Tipologia.massimi(listaTip) ?? [])
        p.keys.first.nome
    ];
    return tip;
  }

  static Future<List<String>> chiAumentare(List<Tipologia> listaTip) async {
    List<String> tip = [
      for (Map<Particella, ValoreDelGiorno> p
          in Tipologia.massimi(listaTip) ?? [])
        p.keys.first.nome
    ];
    return tip;
  }

  Peso(this.codice, this.statoFisicoValore, this.oraValore, this.giorno);
  Future<void> aumentaSingolo(num statoFisicoValore, num oraValore) async {
    const storage = FlutterSecureStorage();

    await storage.write(
        key: "${codice}_${giorno.month}/${giorno.day}/${giorno.year}_STATO",
        value: statoFisicoValore.toString());
    await storage.write(
        key: "${codice}_${giorno.month}/${giorno.day}/${giorno.year}_ORA",
        value: oraValore.toString());
  }

  // usare questa
  static Future<void> aumentaMultipli(Posizione pos, num statoFisicoValore,
      num oraValore, BuildContext context) async {
    const storage = FlutterSecureStorage();
    List lista = await Peso.chiAumentare(await Tipologia.daPosizione(pos, 0));
    String testo;
    if (lista.isEmpty) {
      testo = "Nessuna particella di livello medio-alta rilevata";
    } else {
      testo = "Segnate:";
      for (String i in lista) {
        testo = "$testo $i";
      }
    }
    print(testo);
    final snackBar = SnackBar(
      content: Text(testo),
    );
    //ScaffoldMessenger.of(context).showSnackBar(snackBar);

    List<Peso> pesi = [];
    Map<String, String> tutto = await storage.readAll();

    for (String s in lista) {
      pesi.add(Peso(s, statoFisicoValore, oraValore, DateTime.now()));
    }

    for (Peso p in pesi) {
      p.aumentaSingolo(statoFisicoValore, oraValore);
    }
  }

  static double calcolaPeso(num statoFisicoValore, num oraValore) {
    return (statoFisicoValore / 10) *
        0.0625 *
        (16 - (oraValore > 16 ? 16 : oraValore) + 1);
  }

/*
  static Future<void> aumentaMultipliTest(
      List<Tipologia> listaTip, double peso) async {
    const storage = FlutterSecureStorage();
    List lista = await Peso.chiAumentare(listaTip);
    String testo;
    if (lista.isEmpty) {
      testo = "Nessuna particella di livello medio-alta rilevata";
    } else {
      testo = "Segnate:";
      for (String i in lista) {
        testo = "$testo $i";
      }
    }
    print(testo);

    List<Peso> pesi = [];
    Map<String, String> tutto = await storage.readAll();

    for (String s in lista) {
      final virgolato = tutto[s] ?? '0';
      pesi.add(Peso(s, double.parse(virgolato), DateTime.now()));
    }

    for (Peso p in pesi) {
      p.aumentaSingolo(peso);
    }
  }
*/
  static Future<Map<String, String>> stampa(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print({for (String i in prefs.getKeys()) i: prefs.get(i).toString()});
    final snackBar = SnackBar(
      content: Text({
        for (String i in prefs.getKeys()) i: prefs.get(i).toString()
      }.toString()),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    const storage = FlutterSecureStorage();
    Map<String, String> valoricriptati = await storage.readAll();
    print(valoricriptati);
    print(await Peso.getPeso("Cupressacee/Taxacee", storage));
    print(await Peso.getParticelleDaGiorno("3/11/2023"));
    print(await Peso.getGiorni());
    return {for (String i in prefs.getKeys()) i: prefs.get(i).toString()};
  }

  static Future<void> eliminaDatiDiario() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool i = preferences.getBool("inquinamento")!;
    bool part = preferences.getBool("particelle")!;
    Posizione p = await UltimaPosizione.ottieni();
    bool primaVolta = preferences.getBool("primavolta")!;
    await preferences.clear();
    await PreferencesNotificaInquinamento.modifica(i);
    await PreferencesNotificaParticelle.modifica(part);
    await preferences.setBool("primavolta", primaVolta);
    const storage = FlutterSecureStorage();
    storage.deleteAll();
    await UltimaPosizione.salva(p);
  }

  static Future<void> elimina() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  static Future<List<String>?> getGiorni() async {
    const storage = FlutterSecureStorage();
    Map<String, String> tutto = await storage.readAll();
    Set<DateTime> giorni = {};
    for (String s in tutto.keys) {
      if (s.split("_").length < 2) continue;
      String g = s.split("_")[1];
      giorni.add(DateTime(int.parse(g.split("/")[2]),
          int.parse(g.split("/")[0]), int.parse(g.split("/")[1])));
    }
    List<DateTime> ordinato = giorni.toList();
    ordinato.sort(((a, b) => b.compareTo(a)));
    if (ordinato.isEmpty) return null;
    return [for (DateTime o in ordinato) "${o.month}/${o.day}/${o.year}"];
  }

  static Future<List<String>?> getParticelleDaGiorno(String giorno) async {
    const storage = FlutterSecureStorage();
    //print(await storage.read(key: (await storage.readAll()).keys.first));
    Map<String, String> tutto = await storage.readAll();
    num ore = 0;
    for (String s in tutto.keys) {
      if (s.contains(giorno) && s.contains("_ORA")) {
        ore = num.parse(tutto[s]!);
        break;
      }
    }
    if (ore == 0) return null;

    num valore = 0;
    for (String s in tutto.keys) {
      if (s.contains(giorno) && s.contains("_STATO")) {
        valore = num.parse(tutto[s]!);
        break;
      }
    }

    Set<String> particelle = {
      for (String s in tutto.keys)
        if (s.contains(giorno)) s.split("_")[0]
    };
    return [ore.toString(), valore.toString()] + particelle.toList();
  }

  static Future<double> getPeso(
      String cod, FlutterSecureStorage storage) async {
    //print(await storage.read(key: (await storage.readAll()).keys.first));
    Map<String, String> tutto = await storage.readAll();

    Map<String, String> ore = {
      for (String s in tutto.keys)
        if (s.contains(cod) && s.contains("_ORA")) s.split('_')[1]: tutto[s]!
    };
    Map<String, String> stati = {
      for (String s in tutto.keys)
        if (s.contains(cod) && s.contains("_STATO")) s.split('_')[1]: tutto[s]!
    };

    List<double> pesi = [
      for (String s in ore.keys)
        calcolaPeso(num.parse(stati[s]!), num.parse(stati[s]!))
    ];
    if (pesi.isEmpty) return 0;
    double ret = pesi.reduce((value, element) => value + element);

    return ret;
  }
}
