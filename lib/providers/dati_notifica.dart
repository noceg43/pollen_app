// ignore_for_file: avoid_print

import 'package:demo_1/providers/position.dart';
import 'package:demo_1/providers/preferences.dart';
import 'package:demo_1/utils/calcolo_tipo_maggiore.dart';

class DatiNotifica {
  late String stampaNomi;
  late String stampaLivello;
  DatiNotifica(this.stampaNomi, this.stampaLivello);

  static Future<DatiNotifica?> ottieni(
      Posizione p, List<Tipologia> oggi, List<Tipologia> domani) async {
    // copia della lista per poter eseguire operazioni in sicurezza
    List<Tipologia> oggiLocal = [for (Tipologia t in oggi) t];
    List<Tipologia> domaniLocal = [for (Tipologia t in domani) t];
    // rimuove dal conteggio la tipologia inquinamento
    domaniLocal.removeWhere((e) => e.nome == "Inquinamento");
    oggiLocal.removeWhere((e) => e.nome == "Inquinamento");
    // ottiene le particelle massime di oggi e domani
    List<Map<Particella, ValoreDelGiorno>> maxOggi =
        Tipologia.massimi(oggiLocal, soglia: 1) ?? [];
    List<Map<Particella, ValoreDelGiorno>>? maxDomani =
        Tipologia.massimi(domaniLocal, soglia: 1);
    // controlla che domani ci sia qualcosa
    if (maxDomani == null) return null;

    // funzione che normalizza trasformando ValoreDelGiorno in un num
    Future<List<Map<Particella, num>>> ottieniValori(
        List<Map<Particella, ValoreDelGiorno>> dati) async {
      List<Map<Particella, num>> ret = [
        for (Map<Particella, ValoreDelGiorno> p in dati)
          {p.keys.first: (p.values.first.gruppoValore)}
      ];
      // lista particella-valore con valore da range 1 a +inf
      // se valore >= 20 riportarlo a 2 quindi /10
      for (Map<Particella, num> p in ret) {
        if (p.values.first >= 20) {
          p.updateAll((key, value) => value / 10);
        }
      }
      // ora si hanno valori da 1 a +inf della stessa base
      //
      //                                                                        aggiungere il peso
      //
      // quelli che aggiungendo il peso non arrivano a 2 escluderli
      for (Map<Particella, num> p in ret) {
        num peso = await Peso.getPeso(p.keys.first.nome);
        p.updateAll((key, value) => value + peso);
      }
      ret.removeWhere((e) => e.values.first < 2);
      return ret;
    }

    List<Map<Particella, num>> valoriOggi = await ottieniValori(maxOggi);
    List<Map<Particella, num>> valoriDomani = await ottieniValori(maxDomani);

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
    nomi = "$nomi a ${p.pos}";
    Map<int, String> livello = {1: "basso", 20: "medio", 30: "alto"};
    print(maxDomani.first.values.first.gruppoValore);
    return DatiNotifica(
        nomi, "Livello ${livello[maxDomani.first.values.first.gruppoValore]!}");
  }

  static DatiNotifica? ottieniInquinamento(
      Posizione p, List<Tipologia> oggi, List<Tipologia> domani) {
    // se non c'è inquinamento
    if (oggi.first.nome != "Inquinamento" &&
        domani.first.nome != "Inquinamento") return null;

    // se domani non c'è inquinamento ma oggi sì
    if (oggi.first.nome == "Inquinamento" &&
        domani.first.nome != "Inquinamento") {
      List<Map<Particella, ValoreDelGiorno>> maxOggi =
          Tipologia.massimi(oggi, soglia: 30) ?? [];

      String aumentati = maxOggi.first.keys.first.nome;
      for (int i = 1; i < maxOggi.length; i++) {
        aumentati = "$aumentati, ${maxOggi[i].keys.first.nome}";
      }
      aumentati = "$aumentati in diminuzione a ${p.pos}";

      return DatiNotifica("domani qualità dell'aria migliore", aumentati);
    }
    // se oggi non c'è inquinamento ma domani sì
    if (oggi.first.nome != "Inquinamento" &&
        domani.first.nome == "Inquinamento") {
      List<Map<Particella, ValoreDelGiorno>> maxDomani =
          Tipologia.massimi(domani, soglia: 30) ?? [];

      String aumentati = maxDomani.first.keys.first.nome;
      for (int i = 1; i < maxDomani.length; i++) {
        aumentati = "$aumentati, ${maxDomani[i].keys.first.nome}";
      }
      aumentati = "$aumentati in aumento a ${p.pos}";

      return DatiNotifica("domani qualità dell'aria peggiore", aumentati);
    }
    // sia oggi che domani c'è inquinamento
    if (oggi.first.nome == "Inquinamento" &&
        domani.first.nome == "Inquinamento") {
      if (oggi.first.mediaNuova() == domani.first.mediaNuova()) {
        return null;
      } else {
        List<Map<Particella, ValoreDelGiorno>> maxOggi =
            Tipologia.massimi(oggi, soglia: 30) ?? [];
        List<Map<Particella, ValoreDelGiorno>> maxDomani =
            Tipologia.massimi(domani, soglia: 30) ?? [];
        List<String> aumentateOggi = [
          for (Map<Particella, ValoreDelGiorno> p in maxOggi) p.keys.first.nome
        ];
        List<String> aumentateDomani = [
          for (Map<Particella, ValoreDelGiorno> p in maxDomani)
            p.keys.first.nome
        ];

        List<String> aggiunte = [];

        if (aumentateDomani.length > aumentateOggi.length) {
          for (String s in aumentateDomani) {
            if (!aumentateOggi.contains(s)) {
              aggiunte.add(s);
            }
          }

          String body = aggiunte.first;
          for (int i = 1; i < aggiunte.length; i++) {
            body = "$body, ${aggiunte[i]}";
          }
          body = "$body in aumento a ${p.pos}";

          return DatiNotifica("domani qualità dell'aria peggiore", body);
        } else {
          for (String s in aumentateOggi) {
            if (!aumentateDomani.contains(s)) aggiunte.add(s);
          }
          String body = aggiunte.first;
          for (int i = 1; i < aggiunte.length; i++) {
            body = "$body, ${aggiunte[i]}";
          }
          body = "$body in diminuzione a ${p.pos}";
          return DatiNotifica("domani qualità dell'aria migliore", body);
        }
      }
    }
    return null;
  }
}
