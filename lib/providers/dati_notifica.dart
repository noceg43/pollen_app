// ignore_for_file: avoid_print

import 'package:demo_1/utils/calcolo_tipo_maggiore.dart';

class DatiNotifica {
  late String stampaNomi;
  late String stampaLivello;
  DatiNotifica(this.stampaNomi, this.stampaLivello);

  static DatiNotifica? ottieni(List<Tipologia> oggi, List<Tipologia> domani) {
    // ottiene le particelle massime di oggi e domani
    List<Map<Particella, ValoreDelGiorno>> maxOggi =
        Tipologia.massimi(oggi, soglia: 1) ?? [];
    List<Map<Particella, ValoreDelGiorno>>? maxDomani =
        Tipologia.massimi(domani, soglia: 1);
    // controlla che domani ci sia qualcosa
    if (maxDomani == null) return null;

    // funzione che normalizza trasformando ValoreDelGiorno in un num
    List<Map<Particella, num>> ottieniValori(
        List<Map<Particella, ValoreDelGiorno>> dati) {
      List<Map<Particella, num>> ret = [
        for (Map<Particella, ValoreDelGiorno> p in dati)
          {p.keys.first: (p.values.first.gruppoValore)}
      ];
      // lista particella-valore con valore da range 1 a +inf
      // se valore >= 20 riportarlo a 2 quindi /10
      ret.map((e) => (e.values.first >= 20)
          ? e.values.first == e.values.first / 10
          : e.values.first);
      // ora si hanno valori da 1 a +inf della stessa base
      //
      //                                                                        aggiungere il peso
      //
      // quelli che aggiungendo il peso non arrivano a 2 escluderli
      ret.removeWhere((e) => e.values.first < 2);
      return ret;
    }

    List<Map<Particella, num>> valoriOggi = ottieniValori(maxOggi);
    List<Map<Particella, num>> valoriDomani = ottieniValori(maxDomani);

    // controllo che siano aumentati i valori inserendoli in chiAumentato

    bool esisteNellaLista(
        List<Map<Particella, num>> lista, Map<Particella, num> p) {
      for (Map<Particella, num> i in lista) {
        if (i.keys.first.nome == p.keys.first.nome) return true;
      }
      return false;
    }

    List<Map<Particella, num>> chiAumentato = [];

    for (Map<Particella, num> p in valoriDomani) {
      if (!esisteNellaLista(valoriOggi, p)) {
        chiAumentato.add(p);
      } else {
        for (Map<Particella, num> i in valoriOggi) {
          if (i.keys.first.nome == p.keys.first.nome) {
            if (i.values.first != p.values.first) chiAumentato.add(p);
          }
        }
      }
    }

    // se non è aumentato nessuno
    if (chiAumentato.isEmpty) return null;
    // se qualcosa è aumentato restiuire cosa stampare
    String nomi = chiAumentato.first.keys.first.nome;
    if (chiAumentato.length > 1) {
      nomi = "diverse particelle di ${chiAumentato.first.keys.first.tipo}";
    }

    Map<int, String> livello = {20: "medio", 30: "alto"};

    return DatiNotifica(
        nomi, livello[maxDomani.first.values.first.gruppoValore]!);
  }
}
