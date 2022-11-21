import 'package:demo_1/providers/inquinamento.dart';
import 'package:demo_1/providers/polline.dart';

// INPUT: map di polline e tendenza divise in categorie
// OUTPUT: lista decrescente dell'intensità della famiglia
List<String> tipoMaggiore(
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
  // ordinare una map restituendo solo la lista delle key ordinate
  return Map.fromEntries(massimi.entries.toList()
        ..sort((e1, e2) => e1.value.compareTo(e2.value)))
      .keys
      .toList()
      .reversed
      .toList();
}
