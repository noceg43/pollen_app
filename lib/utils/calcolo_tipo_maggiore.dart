import 'package:demo_1/providers/inquinamento.dart';
import 'package:demo_1/providers/polline.dart';

// INPUT: map di polline e tendenza divise in categorie
// OUTPUT: lista decrescente dell'intensità della famiglia
List<Map<String, dynamic>> tipoMaggiore(
    Map<Polline, Tendenza> alberi,
    Map<Polline, Tendenza> erbe,
    Map<Polline, Tendenza> spore,
    List<ParticellaInquinante> inq) {
  int massimo(Map<Polline, Tendenza> poll) {
    int ret = 0;
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
  Map<String, int> massimi = {
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

  // TUTTO SBAGLIATO STRUTTURA DATI PESSIMA
  // ordinare una map restituendo solo la lista delle key ordinate
  /*
  return Map.fromEntries(massimi.entries.toList()
        ..sort((e1, e2) => e1.value.compareTo(e2.value)))
      .keys
      .toList()
      .reversed
      .toList();
      */
}

int mediaTipologia(dynamic data) {
  num sum = 0;
  if (data is Map<Polline, Tendenza>) {
    Map<Polline, Tendenza> poll = data;
    for (Tendenza t in poll.values) {
      sum += t.gruppoValore;
    }
    int lunghezza = poll.values.length;
    if (lunghezza == 0) return 0;
    return (sum / poll.values.length).round();
  } else {
    List<ParticellaInquinante> inq = data;
    for (ParticellaInquinante p in inq) {
      if (p.superato) sum += 3;
    }
    return (sum / inq.length).round();
  }
}

int lunghezza(dynamic data) {
  if (data is Map<Polline, Tendenza>) {
    Map<Polline, Tendenza> poll = data;
    return poll.values.length;
  } else {
    List<ParticellaInquinante> inq = data;
    return inq.length;
  }
}
