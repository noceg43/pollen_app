import 'package:demo_1/providers/inquinamento.dart';
import 'package:demo_1/providers/polline.dart';

// INPUT: map di polline e tendenza divise in categorie
// OUTPUT: lista decrescente sulla base dell'intensità della famiglia in formato <Stringa,famiglia>
List<Map<String, dynamic>> tipoMaggiore(
    Map<Polline, Tendenza> alberi,
    Map<Polline, Tendenza> erbe,
    Map<Polline, Tendenza> spore,
    List<ParticellaInquinante> inq) {
  num massimo(Map<Polline, Tendenza> poll) {
    num ret = 0;
    for (var i in [for (Polline p in poll.keys) poll[p]!.gruppoValore]) {
      ret += i;
    }
    return ret;
  }

  int maxInq = 0;
  List<int> listMaxInq = [
    for (ParticellaInquinante i in inq) i.superato ? 3 : 0
  ];
  for (var element in listMaxInq) {
    maxInq += element;
  }
  Map<String, num> massimi = {
    "Alberi": massimo(alberi),
    "Erbe": massimo(erbe),
    "Spore": massimo(spore),
    "Inquinamento": maxInq
  };

  List<Map<String, dynamic>> ret = [
    {"Alberi": alberi},
    {"Erbe": erbe},
    {"Spore": spore},
    {"Inquinamento": inq}
  ];

  ret.sort(
      ((a, b) => massimi[b.keys.first]!.compareTo(massimi[a.keys.first]!)));
  return ret;
}

// CONTIENE FUNZIONI DA USARE SOLO CON TIPI Map<Polline,Tendenza> o List<ParticellaInquinante>
class Tipologia {
  static media(dynamic tipologiaGiornaliera) {
    num sum = 0;
    if (tipologiaGiornaliera is Map<Polline, Tendenza>) {
      Map<Polline, Tendenza> poll = tipologiaGiornaliera;
      for (Tendenza t in poll.values) {
        sum += t.gruppoValore;
      }
      int lunghezza = poll.values.length;
      if (lunghezza == 0) return 0;
      return (sum / poll.values.length).round();
    } else {
      List<ParticellaInquinante> inq = tipologiaGiornaliera;
      for (ParticellaInquinante p in inq) {
        if (p.superato) sum += 3;
      }
      return (sum / inq.length).round();
    }
  }

  static List<dynamic> maxParticelle(dynamic tipologiaGiornaliera) {
    num massimo(Map<Polline, Tendenza> poll) {
      int ret = 0;
      for (var i in [for (Polline p in poll.keys) poll[p]!.gruppoValore]) {
        if (i > ret) ret = i;
      }
      return ret;
    }

    num max = 0;

    if (tipologiaGiornaliera is Map<Polline, Tendenza>) {
      Map<Polline, Tendenza> poll = tipologiaGiornaliera;

      max = massimo(poll);
      poll.removeWhere((key, value) => value.gruppoValore != max);
      return poll.keys.toList();
    } else {
      List<ParticellaInquinante> inq = tipologiaGiornaliera;

      inq.removeWhere((e) => !e.superato);
      return inq;
    }
  }

  static int lunghezza(dynamic data) {
    if (data is Map<Polline, Tendenza>) {
      Map<Polline, Tendenza> poll = data;
      return poll.values.length;
    } else {
      List<ParticellaInquinante> inq = data;
      return inq.length;
    }
  }
}
