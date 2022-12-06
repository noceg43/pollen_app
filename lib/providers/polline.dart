// ignore_for_file: unrelated_type_equality_checks

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'package:demo_1/providers/cache.dart';
import 'package:demo_1/providers/inquinamento.dart';
import 'package:demo_1/providers/position.dart';
import 'package:demo_1/utils/calcolo_tipo_maggiore.dart';

// valori se non presenti = 0 o se stringhe = '' tranne per il parentNameL
class Polline {
  final num partId, parentId, partLow, partMiddle, partHigh;
  final String parentNameL,
      partCode,
      partNameI,
      partNameD,
      partNameE,
      partNameF,
      partNameL,
      tipo;
  static Future<List<Polline>> fetch() async {
    var urlPolline =
        'http://dati.retecivica.bz.it/services/POLLNET_PARTICLES?format=json';
    //final response = await http.get(Uri.parse(urlPolline));
    var file = await GiornalieraCacheManager.instance.getSingleFile(urlPolline);
    Iterable p = jsonDecode(await file.readAsString());
    List<Polline> poll =
        List<Polline>.from(p.map((model) => Polline.fromJson(model)));
    // rimuove pollini dei quali non si conoscono i valori soglia
    poll.removeWhere((p) => p.partMiddle == 0);

    return poll;
    /*
    if (response.statusCode == 200) {
      Iterable p = jsonDecode(response.body);
      List<Polline> poll =
          List<Polline>.from(p.map((model) => Polline.fromJson(model)));
      return [for (Polline i in poll) i];
    } else {
      throw Exception('Failed to load polline');
    }
    */
  }

  static List<Polline> getAlberi(Iterable<Polline> tutti) {
    List<Polline> ret = [];
    for (Polline p in tutti) {
      if (p.tipo == "Alberi") ret.add(p);
    }
    return ret;
  }

  static List<Polline> getErbe(Iterable<Polline> tutti) {
    List<Polline> ret = [];
    for (Polline p in tutti) {
      if (p.tipo == "Erbe") ret.add(p);
    }
    return ret;
  }

  static List<Polline> getSpore(Iterable<Polline> tutti) {
    List<Polline> ret = [];
    for (Polline p in tutti) {
      if (p.tipo == "Spore") ret.add(p);
    }
    return ret;
  }

  const Polline({
    required this.partId,
    required this.parentId,
    required this.partLow,
    required this.partMiddle,
    required this.partHigh,
    required this.parentNameL,
    required this.partCode,
    required this.partNameI,
    required this.partNameD,
    required this.partNameE,
    required this.partNameF,
    required this.partNameL,
    required this.tipo,
  });

  factory Polline.fromJson(Map<String, dynamic> json) {
    String ottieniTipo() {
      List<String> erbe = [
        "Saxifragaceae",
        "Rubiaceae",
        "Rosaceae",
        "Ranunculaceae",
        "Polygonaceae",
        "Plantaginaceae",
        "Papaveraceae",
        "Juncaceae",
        "Gramineae",
        "Euphorbiaceae",
        "Cyperaceae",
        "Artemisia",
        "Amaranthaceae",
      ];
      List<String> erbeFamiglia = ["Cannabaceae", "Urticaceae", "Compositae"];
      if (json['PARENT_NAME_L'] == "Spore") return "Spore";
      if (erbeFamiglia.contains(json['PARENT_NAME_L']) ||
          erbe.contains(json['PART_NAME_L']) ||
          erbeFamiglia.contains(json['PART_NAME_L'])) {
        return "Erbe";
      } else {
        return "Alberi";
      }
    }

    return Polline(
      partId: json['PART_ID'] ?? 0,
      parentId: json['PARENT_ID'] ?? 0,
      partLow: json['PART_LOW'] ?? 0,
      partMiddle: json['PART_MIDDLE'] ?? 0,
      partHigh: json['PART_HIGH'] ?? 0,
      parentNameL: json['PARENT_NAME_L'] ?? 'Assente',
      partCode: json['PART_CODE'] ?? '',
      partNameI: json['PART_NAME_I'] ?? '',
      partNameD: json['PART_NAME_D'] ?? '',
      partNameE: json['PART_NAME_E'] ?? '',
      partNameF: json['PART_NAME_F'] ?? '',
      partNameL: json['PART_NAME_L'] ?? '',
      tipo: ottieniTipo(),
    );
  }

  @override
  String toString() {
    return partNameI;
  }

  String prettyPrint() {
    return "$partId $partNameI $parentNameL $partLow $partMiddle $partHigh";
  }

  @override
  bool operator ==(Object other) {
    if (other is Polline && other.partId == partId) return true;
    //if (other is Concentrazione && other.partId == partId) return true;
    return false;
  }

  @override
  int get hashCode => partId.hashCode;
}

class Stazione {
  final num latitude, longitude, regiId, statId;
  final String regiNameD, regiNameI, statCode, statNameD, statenameI;
  static Future<List<Stazione>> fetch() async {
    var urlStazione =
        'http://dati.retecivica.bz.it/services/POLLNET_STATIONS?format=json';
    //final response = await http.get(Uri.parse(urlStazione));

    var file =
        await GiornalieraCacheManager.instance.getSingleFile(urlStazione);
    Iterable p = jsonDecode(await file.readAsString());
    List<Stazione> staz =
        List<Stazione>.from(p.map((model) => Stazione.fromJson(model)));

    return staz;
    /*
    if (response.statusCode == 200) {
      Iterable p = jsonDecode(response.body);
      List<Stazione> staz =
          List<Stazione>.from(p.map((model) => Stazione.fromJson(model)));

      return staz;
    } else {
      throw Exception('Failed to load stazioni');
    }
    */
  }

  static Future<Stazione> trovaStaz(Posizione p) async {
    List<Stazione> staz = await Stazione.fetch();
    Stazione localizzata = Stazione._localizza(staz, p.lat, p.lon);

    num maxIterazioni = staz.length;

    Stazione trovata = localizzata;
    Future<bool> checkStazione(Stazione s) async {
      List<Concentrazione> c = await Concentrazione.fetch(s);
      if (c.isEmpty) return false;
      return true;
    }

    for (num i = 0; i < maxIterazioni; i++) {
      bool check = await checkStazione(trovata);
      if (check) break;
      staz.remove(trovata);
      trovata = Stazione._localizza(staz, p.lat, p.lon);
    }
    return trovata;
  }

  static Stazione _localizza(List<Stazione> s, num lat, num lon) {
    num formula(lat1, lon1, lat2, lon2) {
      num p = 0.017453292519943295;
      num hav = 0.5 -
          cos((lat2 - lat1) * p) / 2 +
          cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
      return 12742 * asin(sqrt(hav));
    }

    Map<num, Stazione> test = {
      for (Stazione i in s) formula(lat, lon, i.latitude, i.longitude): i
    };
    Stazione theValue = test.values.first;
    num theKey = test.keys.first;
    test.forEach((k, v) {
      if (k < theKey) {
        theValue = v;
        theKey = k;
      }
    });
    return theValue;
  }

  const Stazione({
    required this.latitude,
    required this.longitude,
    required this.regiId,
    required this.statId,
    required this.regiNameD,
    required this.regiNameI,
    required this.statCode,
    required this.statNameD,
    required this.statenameI,
  });

  factory Stazione.fromJson(Map<String, dynamic> json) {
    return Stazione(
      latitude: json['LATITUDE'],
      longitude: json['LONGITUDE'],
      regiId: json['REGI_ID'],
      statId: json['STAT_ID'],
      regiNameD: json['REGI_NAME_D'],
      regiNameI: json['REGI_NAME_I'],
      statCode: json['STAT_CODE'],
      statNameD: json['STAT_NAME_D'],
      statenameI: json['STAT_NAME_I'],
    );
  }

  String prettyPrint() {
    return '$statId $statenameI lat:$latitude lon:$longitude';
  }

  @override
  String toString() {
    return '$statId';
  }

  @override
  bool operator ==(Object other) {
    return (other is Stazione) && other.statId == statId;
  }

  @override
  int get hashCode => statId.hashCode;
}

class Concentrazione {
  final num partId, partLevel, partSeq, remaConc, statId;
  final String partNameL,
      partParentNameL,
      remaDate,
      statCode,
      statNameD,
      statNameI;
  static Future<List<Concentrazione>> fetch(Stazione staz,
      {DateTime? giorno}) async {
    var urlConcentrazione =
        'http://dati.retecivica.bz.it/services/POLLNET_REMARKS?format=json&STAT_ID=$staz';
    if (giorno != null) {
      String giornoS = '${giorno.year}-${giorno.month}-${giorno.day}';
      urlConcentrazione =
          'http://dati.retecivica.bz.it/services/POLLNET_REMARKS?format=json&from=$giornoS&to=$giornoS&STAT_ID=$staz';
    }
    final response = await http.get(Uri.parse(urlConcentrazione));
    /*
    var file =
        await GiornalieraCacheManager.instance.getSingleFile(urlConcentrazione);
    Iterable p = jsonDecode(await file.readAsString());
    List<Concentrazione> conc = List<Concentrazione>.from(
        p.map((model) => Concentrazione.fromJson(model)));
    return conc;
    */

    if (response.statusCode == 200) {
      Iterable p = jsonDecode(response.body);
      List<Concentrazione> conc = List<Concentrazione>.from(
          p.map((model) => Concentrazione.fromJson(model)));
      return conc;
    } else {
      throw Exception('Failed to load stazioni');
    }
  }

  Concentrazione({
    required this.partId,
    required this.partLevel,
    required this.partSeq,
    required this.remaConc,
    required this.statId,
    required this.partNameL,
    required this.partParentNameL,
    required this.remaDate,
    required this.statCode,
    required this.statNameD,
    required this.statNameI,
  });

  factory Concentrazione.fromJson(Map<String, dynamic> json) {
    return Concentrazione(
      partId: json['PART_ID'],
      partLevel: json['PART_LEVEL'],
      partSeq: json['PART_SEQ'],
      remaConc: json['REMA_CONCENTRATION'] ?? 0,
      statId: json['STAT_ID'],
      partNameL: json['PART_NAME_L'],
      partParentNameL: json['PART_PARENT_NAME_L'],
      remaDate: json['REMA_DATE'],
      statCode: json['STAT_CODE'] ?? '',
      statNameD: json['STAT_NAME_D'] ?? '',
      statNameI: json['STAT_NAME_I'] ?? '',
    );
  }

  String prettyPrint() {
    return '$partNameL$remaDate $remaConc';
  }

  @override
  String toString() {
    return '$partId' '_' '$remaDate';
  }

  @override
  bool operator ==(Object other) {
    if (other is Polline && other.partId == partId) return true;
    if (other is Concentrazione &&
        other.partId == partId &&
        other.remaDate == remaDate) return true;
    return false;
  }

  @override
  int get hashCode => partId.hashCode + remaDate.hashCode;
}

class Tendenza {
  String freccia = "Stabile";
  num valore;
  int gruppoValore = 0;
  Tendenza(Polline polline, this.valore, this.freccia) {
    if (polline.partLow < valore && valore <= polline.partMiddle) {
      gruppoValore = 1;
    } else if (polline.partMiddle < valore && valore <= polline.partHigh) {
      gruppoValore = 20;
    } else if (valore > polline.partHigh) {
      gruppoValore = 30;
    } else {
      gruppoValore = 0;
    }
    valore = double.parse(valore.toStringAsFixed(1));
  }
  @override
  String toString() {
    return "$valore $gruppoValore $freccia ";
  }

  static Map<Polline, Tendenza> getAlberi(Map<Polline, Tendenza> tutte) {
    Map<Polline, Tendenza> ret = {};
    for (Polline p in tutte.keys) {
      if (p.tipo == "Alberi") ret[p] = tutte[p]!;
    }
    return ret;
  }

  static Map<Polline, Tendenza> getErbe(Map<Polline, Tendenza> tutte) {
    Map<Polline, Tendenza> ret = {};
    for (Polline p in tutte.keys) {
      if (p.tipo == "Erbe") ret[p] = tutte[p]!;
    }
    return ret;
  }

  static Map<Polline, Tendenza> getSpore(Map<Polline, Tendenza> tutte) {
    Map<Polline, Tendenza> ret = {};
    for (Polline p in tutte.keys) {
      if (p.tipo == "Spore") ret[p] = tutte[p]!;
    }
    return ret;
  }
}

Future<Map<Polline, Tendenza>> tendenza(Stazione s, List<Polline> poll,
    {int offset = 0}) async {
  List<Concentrazione> ultimaConc = await Concentrazione.fetch(s);

  List<Concentrazione> trovaConcentrazione(
      List<Concentrazione> totale, Polline cercato) {
    List<Concentrazione> trova = [
      for (Concentrazione c in totale)
        if (c == cercato) c
    ];
    return trova;
  }

  num calcolaConcentrazioneMedia(List<Concentrazione> conc) {
    if (conc.isEmpty) return 0;

    List<num> cValori = [for (Concentrazione i in conc) i.remaConc];

    return cValori.reduce((a, b) => a + b) / cValori.length;
  }

  Map<Polline, num> ultimaTend = {
    for (Polline p in poll)
      p: calcolaConcentrazioneMedia(trovaConcentrazione(ultimaConc, p))
  };
  ultimaTend.removeWhere((key, value) => value == 0);
  var annoFa = DateTime(DateTime.now().year - 1, DateTime.now().month,
      DateTime.now().day + offset);
  List<Concentrazione> annoFaConc =
      await Concentrazione.fetch(s, giorno: annoFa);
  Map<Polline, num> annoFaTend = {
    for (Polline p in ultimaTend.keys)
      p: calcolaConcentrazioneMedia(trovaConcentrazione(annoFaConc, p))
  };

  Map<Polline, Tendenza> tendenzaFinale = {
    for (Polline p in ultimaTend.keys)
      p: _calcoloTendenza(p, annoFaTend[p]!, ultimaTend[p]!)
  };
  return tendenzaFinale;
}

Tendenza _calcoloTendenza(Polline p, num pre, num att) {
  num valore(Polline p, num n) {
    if (p.partLow < n && n <= p.partMiddle) return 1;
    if (p.partMiddle < n && n <= p.partHigh) return 2;
    if (n > p.partHigh) return 3;
    return 0;
  }

  num prePart = valore(p, pre);
  num attPart = valore(p, att);
  //print("pre $pre  att $att");
  num nValoreAttuale = ((att + pre) / 2);

  if (prePart == attPart) {
    return Tendenza(
      p,
      nValoreAttuale,
      "Stabile",
    );
  }
  if (prePart < attPart) {
    return Tendenza(
      p,
      nValoreAttuale,
      "Diminuzione",
    );
  }
  if (prePart > attPart) {
    return Tendenza(
      p,
      nValoreAttuale,
      "Aumento",
    );
  }

  return Tendenza(
    p,
    nValoreAttuale,
    "Stabile",
  );
}

void main(List<String> args) async {
  List<Polline> poll = await Polline.fetch();

  List<Stazione> staz = await Stazione.fetch();
  // ignore: unused_local_variable
  num latMo = 44.645958;
  // ignore: unused_local_variable
  num lonMo = 10.925529;
  //Stazione stazLocalizzata = staz.firstWhere((element) => element.statId == 1);
  //print(stazLocalizzata.prettyPrint());

  var out = File('tendenze.txt').openWrite();

  for (Stazione s in staz) {
    out.write("#####################################################\n");
    out.write("${s.prettyPrint()}\n");
    Map<Polline, Tendenza> tend = await tendenza(s, poll);
    Inquinamento inq = await Inquinamento.fetch(
        Posizione(s.latitude, s.longitude, s.statenameI));
    out.write("Inquinamento Max ");
    out.write(Tipologia.media(inq.giornaliero(0)));
    out.write("\n");
    out.write("TIPO MAGGIORE: ");
    out.write(tipoMaggiore(Tendenza.getAlberi(tend), Tendenza.getErbe(tend),
        Tendenza.getSpore(tend), inq.giornaliero(0)));
    out.write("\nALBERI: \n");
    out.write("Alberi Max ");
    out.write(Tipologia.media(Tendenza.getAlberi(tend)));
    out.write("\n");
    for (Polline p in Polline.getAlberi(tend.keys)) {
      out.write("    $p ");
      out.write(tend[p]);
      out.write("\n");
    }
    out.write("Erbe Max ");
    out.write(Tipologia.media(Tendenza.getErbe(tend)));
    out.write("\n");
    out.write("ERBE: \n");
    for (Polline p in Polline.getErbe(tend.keys)) {
      out.write("    $p ");
      out.write(tend[p]);
      out.write("\n");
    }
    out.write("Spore Max ");
    out.write(Tipologia.media(Tendenza.getSpore(tend)));
    out.write("\n");
    out.write("SPORE: \n");
    for (Polline p in Polline.getSpore(tend.keys)) {
      out.write("    $p ");
      out.write(tend[p]);
      out.write("\n");
    }
  }

  out.close();
}
