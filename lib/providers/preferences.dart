import 'package:demo_1/providers/inquinamento.dart';
import 'package:demo_1/providers/polline.dart';
import 'package:demo_1/providers/position.dart';
import 'package:demo_1/utils/calcolo_tipo_maggiore.dart';
import 'package:demo_1/utils/format_polline.dart';
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

  static Future<List> chiAumentare(Posizione pos) async {
    Map<Polline, Tendenza> tend = (await tendenzaDaPos(pos)).first;
    List<ParticellaInquinante> inq =
        (await Inquinamento.fetch(pos.lat, pos.lon)).giornaliero(0);
    List lista = Tipologia.maxParticelle(tipoMaggiore(Tendenza.getAlberi(tend),
            Tendenza.getErbe(tend), Tendenza.getSpore(tend), inq)
        .first
        .values
        .first);
    List<String> ret = [for (dynamic d in lista) d.toString()];
    return ret;
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
