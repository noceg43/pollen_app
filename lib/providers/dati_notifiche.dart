import 'package:demo_1/providers/inquinamento.dart';
import 'package:demo_1/providers/polline.dart';
import 'package:demo_1/utils/calcolo_tipo_maggiore.dart';
import 'package:flutter/material.dart';

class DatiNotifiche {
  String particella = "";
  String livello = "Medio";
  AssetImage img = const AssetImage(
      'assets/images/alberi.png'); // capire come mettere immagine
  bool vale = false;
  DatiNotifiche(
      List<Map<Polline, Tendenza>> poll, List<List<ParticellaInquinante>> inq) {
// se la particella massima della tipologia massima passa da oggi-basso/assente -> domani-medio || oggi-assente/basso/medio -> domani-alto
// se rilevate più particelle scrivere --> "aumento di diverse particelle sensibili"
    Map<Polline, Tendenza> pollOggi = poll[0];
    List<ParticellaInquinante> inqOggi = inq[0];
    Map<Polline, Tendenza> pollDomani = poll[1];
    List<ParticellaInquinante> inqDomani = inq[1];

    // ottenere e determinare tipo valori domani
    List<dynamic> domani = Tipologia.maxParticelle(tipoMaggiore(
            Tendenza.getAlberi(pollDomani),
            Tendenza.getErbe(pollDomani),
            Tendenza.getSpore(pollDomani),
            inqDomani)
        .first
        .values
        .first);
    if (domani is List<ParticellaInquinante>) {
      domani = List<ParticellaInquinante>.from(domani);
    } else {
      domani = List<Polline>.from(domani);
    }

    // ottenere e determinare tipo valori oggi
    List<dynamic> oggi = Tipologia.maxParticelle(tipoMaggiore(
            Tendenza.getAlberi(pollOggi),
            Tendenza.getErbe(pollOggi),
            Tendenza.getSpore(pollOggi),
            inqOggi)
        .first
        .values
        .first);
    if (oggi is List<ParticellaInquinante>) {
      oggi = List<ParticellaInquinante>.from(oggi);
    } else {
      oggi = List<Polline>.from(oggi);
    }

    // se tipi sono polline
    if (oggi is List<Polline> && domani is List<Polline>) {
      print("pollini");
      // valori che sforano domani
      List<Polline> aumentati = [];
      for (Polline p in domani) {
        if (poll.elementAt(1)[p]!.gruppoValore >= 2) {
          aumentati.add(p);
        }
      }
      // valori che sforano oggi
      List<Polline> altiDiOggi = [];
      for (Polline p in oggi) {
        if (poll.elementAt(0)[p]!.gruppoValore >= 2) {
          altiDiOggi.add(p);
        }
      }

      // capire se qualcosa è aumentato
      int quantiAlti = 0;
      for (Polline p in aumentati) {
        if (altiDiOggi.toString().contains(p.toString())) quantiAlti++;
      }
      if (quantiAlti == aumentati.length) {
        particella = "";
      } else {
        if (aumentati.length == 1) {
          particella = aumentati.first.toString();
          livello = poll.elementAt(1)[aumentati.first]!.gruppoValore == 2
              ? "medio"
              : "alto";
          vale = true;
        } else {
          particella = aumentati.first.tipo;
          livello = poll.elementAt(1)[aumentati.first]!.gruppoValore == 2
              ? "medio"
              : "alto";

          vale = true;
        }
      }
    } else
    // se tipi sono inquinamento
    if (oggi is List<ParticellaInquinante> &&
        domani is List<ParticellaInquinante>) {
      // capire se qualcosa è aumentato
      int quantiAlti = 0;
      for (ParticellaInquinante p in domani) {
        if (oggi.toString().contains(p.toString())) quantiAlti++;
      }
      if (quantiAlti == domani.length) {
        particella = "";
      } else {
        if (domani.length == 1) {
          particella = domani.first.toString();
          vale = true;
        } else {
          particella = "inquinamento";
          livello = "alto";
          vale = true;
        }
      }
    } else
    // se oggi è polline e domani è inquinamento
    if (oggi is List<Polline> && domani is List<ParticellaInquinante>) {
      if (domani.length == 1) {
        particella = domani.first.toString();
        vale = true;
      } else {
        particella = "inquinamento";
        livello = "alto";
        vale = true;
      }
    } else
    // se oggi è inquinamento e domani è polline
    {
      List<Polline> aumentati = [];
      for (Polline p in domani) {
        if (poll.elementAt(1)[p]!.gruppoValore >= 2) {
          aumentati.add(p);
        }
      }
      if (aumentati.isEmpty) {
        particella = "";
      } else if (aumentati.length == 1) {
        particella = aumentati.first.toString();
        livello = poll.elementAt(1)[aumentati.first]!.gruppoValore == 2
            ? "medio"
            : "alto";

        vale = true;
      } else {
        particella = aumentati.first.tipo;
        livello = poll.elementAt(1)[aumentati.first]!.gruppoValore == 2
            ? "medio"
            : "alto";

        vale = true;
      }
    }
  }
  static DatiNotifiche? ottieni(
      List<Map<Polline, Tendenza>> poll, List<List<ParticellaInquinante>> inq) {
    DatiNotifiche d = DatiNotifiche(poll, inq);
    if (d.vale) {
      return d;
    } else {
      return null;
    }
  }
}
