import 'package:demo_1/providers/inquinamento.dart';
import 'package:demo_1/providers/per_inquinamento.dart';
import 'package:demo_1/providers/per_polline.dart';
import 'package:demo_1/providers/polline.dart';
import 'package:demo_1/providers/position.dart';

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

class Particella {
  String nome = "";
  List<num> limite = [];
  String tipo = "";
  num? idPolline;

  Particella(this.nome, this.limite, this.tipo, {this.idPolline});

  static List<Particella> daPolline(List<Polline> poll, String tipo) {
    return [
      for (Polline p in poll)
        Particella(p.partNameI, [p.partLow, p.partMiddle, p.partHigh], tipo,
            idPolline: p.partId)
    ];
  }

  static List<Particella> daInquinamento(List<ParticellaInquinante> inq) {
    return [
      for (ParticellaInquinante p in inq)
        Particella(p.tipo, [p.lim], "Inquinamento")
    ];
  }

  @override
  String toString() {
    return nome;
  }
}

class ValoreDelGiorno {
  num valore = 0;
  late DateTime giorno;
  String? tendenza;
  int gruppoValore = 0;
  ValoreDelGiorno(this.valore, this.giorno, this.tendenza, this.gruppoValore);

  static Map<String, ValoreDelGiorno> daPolline(
      Map<Polline, Tendenza> tend, int giorno) {
    return {
      for (Polline p in tend.keys)
        p.partNameI: ValoreDelGiorno(
            tend[p]!.valore,
            DateTime.now().add(Duration(days: giorno)),
            tend[p]!.freccia,
            tend[p]!.gruppoValore)
    };
  }

  static Map<String, ValoreDelGiorno> daInquinamento(
      List<ParticellaInquinante> inq, int giorno) {
    return {
      for (ParticellaInquinante p in inq)
        p.tipo: ValoreDelGiorno(
            p.val,
            DateTime.now().add(Duration(days: giorno)),
            null,
            p.superato ? 30 : 0)
    };
  }

  @override
  String toString() {
    return "$valore $gruppoValore ${giorno.day}";
  }
}

class Tipologia {
  List<Map<Particella, ValoreDelGiorno>> lista = [];
  String nome = "";
  late Posizione pos;

  Tipologia._(this.lista, this.nome, this.pos);

  //                                                                            da Posizione e offset del giorno
  //                                                                            ottiene lista ordinata di tipologie
  static Future<List<Tipologia>> daPosizione(Posizione p, int giorno) async {
    // ottenere dati per polline
    List<Polline> poll = await Polline.fetch();
    Stazione staz = await Stazione.trovaStaz(p);
    Map<Polline, Tendenza> tendOggi =
        await tendenza(staz, poll, offset: giorno);
    Map<Polline, Tendenza> alberi = Tendenza.getAlberi(tendOggi);
    Map<Polline, Tendenza> erbe = Tendenza.getErbe(tendOggi);
    Map<Polline, Tendenza> spore = Tendenza.getSpore(tendOggi);

    // ottenere dati per inquinamento
    Inquinamento inq = await Inquinamento.fetch(p);
    List<ParticellaInquinante> listaInq = inq.giornaliero(giorno);

    // creare istanze Tipologia
    Tipologia a = Tipologia._([
      for (Particella p in Particella.daPolline(alberi.keys.toList(), "Alberi"))
        {p: ValoreDelGiorno.daPolline(alberi, giorno)[p.nome]!}
    ], "Alberi", p);
    Tipologia e = Tipologia._([
      for (Particella p in Particella.daPolline(erbe.keys.toList(), "Erbe"))
        {p: ValoreDelGiorno.daPolline(erbe, giorno)[p.nome]!}
    ], "Erbe", p);
    Tipologia s = Tipologia._([
      for (Particella p in Particella.daPolline(spore.keys.toList(), "Spore"))
        {p: ValoreDelGiorno.daPolline(spore, giorno)[p.nome]!}
    ], "Spore", p);
    Tipologia i = Tipologia._([
      for (Particella p in Particella.daInquinamento(listaInq))
        {p: ValoreDelGiorno.daInquinamento(listaInq, giorno)[p.nome]!}
    ], "Inquinamento", p);
    // ordinarle internamente per particella
    a._ordina();
    e._ordina();
    s._ordina();
    i._ordina();
    List<Tipologia> ret = [a, e, s, i];
    // ordinare le istanze di Tipologia
    ret.sort(((a, b) => b.sommaValori().compareTo(a.sommaValori())));

    return ret;
  }

  void _ordina() {
    lista.sort(((a, b) =>
        b.values.first.gruppoValore.compareTo(a.values.first.gruppoValore)));
  }

  int sommaValori() {
    if (lista.isEmpty) return 0;
    int s = 0;
    for (Map<Particella, ValoreDelGiorno> i in lista) {
      s += i.values.first.gruppoValore;
    }
    return s;
  }

  int lenght() {
    return lista.length;
  }

  bool isEmpty() {
    return lista.isEmpty;
  }

  int mediaNuova() {
    if (lista.isEmpty) return 0;
    return ([
              for (Map<Particella, ValoreDelGiorno> i in lista)
                i.values.first.gruppoValore
            ].reduce(((a, b) => a + b)) /
            lista.length)
        .round();
  }

  static Future<Map<DateTime, num>> daParticella(
      dynamic pos, Particella part) async {
    Map<DateTime, num> futura;
    if (pos is Posizione) {
      futura = await PerInquinamento.fetch(pos, part);
    } else {
      futura = await PerPolline.fetch(pos, part);
    }
    return futura;
  }

  //                                                                            ottenere lista delle particelle che superano il 20
  //                                                                            della tipologia più presente
  static List<Map<Particella, ValoreDelGiorno>>? massimi(List<Tipologia> t,
      {num soglia = 20}) {
    List<Map<Particella, ValoreDelGiorno>> top = t.first.lista;
    if (top.isEmpty) return null;
    int valMax = top.first.values.first.gruppoValore;
    if (valMax < soglia) return null;
    List<Map<Particella, ValoreDelGiorno>> ret = [];
    for (Map<Particella, ValoreDelGiorno> p in top) {
      if (p.values.first.gruppoValore == valMax) {
        ret.add({p.keys.first: p.values.first});
      }
    }
    return ret;
  }

  @override
  String toString() {
    return nome + lista.toString();
  }

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
      List<ParticellaInquinante> ret = [];
      for (ParticellaInquinante p in inq) {
        if (p.superato) {
          ret.add(p);
        }
      }
      return ret;
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
