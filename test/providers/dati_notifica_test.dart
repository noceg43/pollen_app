import 'package:demo_1/providers/dati_notifica.dart';
import 'package:demo_1/providers/position.dart';
import 'package:demo_1/utils/calcolo_tipo_maggiore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  Posizione p = Posizione(44.645958, 10.925529, "Modena");
  // dichiaro qua le strutture asincrone perchè group non può essere async
  Particella rossa = Particella('rossa', [5, 20, 30], 'Erbe');
  Particella verde = Particella('verde', [5, 20, 30], 'Erbe');
  Particella blu = Particella('blu', [5, 20, 30], 'Erbe');
  Particella gialla = Particella('gialla', [5, 20, 30], 'Erbe');

  Particella grigia = Particella('grigia', [5, 20, 30], "Spore");
  Particella nera = Particella('nera', [5, 20, 30], "Spore");
  Particella marrone = Particella('marrone', [5, 20, 30], "Spore");
  Particella beige = Particella('beige', [5, 20, 30], "Spore");
  // 0 = assente
  // 1 = basso
  // 20 = medio
  // 30 = alto
  ValoreDelGiorno assente = ValoreDelGiorno(0, DateTime(2023, 2, 23), null, 0);
  ValoreDelGiorno basso = ValoreDelGiorno(10, DateTime(2023, 2, 23), null, 1);
  ValoreDelGiorno medio = ValoreDelGiorno(25, DateTime(2023, 2, 23), null, 20);
  ValoreDelGiorno alto = ValoreDelGiorno(50, DateTime(2023, 2, 23), null, 30);

  List<Tipologia> insiemeOrdinate(Tipologia spore, Tipologia erbe) {
    spore.ordina();
    erbe.ordina();
    List<Tipologia> totTipologie = [spore, erbe];
    // ordinare le istanze di Tipologia
    totTipologie.sort(((a, b) => b.sommaValori().compareTo(a.sommaValori())));
    return totTipologie;
  }

  group('Test Provider dati_notifica STESSA TIPOLOGIA', () {
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST ASSENTE-
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    test('ASSENTE-ASSENTE', () async {
      Tipologia sOggi = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eOggi = Tipologia([
        {rossa: assente},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totOggi = insiemeOrdinate(sOggi, eOggi);

      Tipologia sDomani = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eDomani = Tipologia([
        {rossa: assente},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totDomani = insiemeOrdinate(sDomani, eDomani);

      DatiNotifica? dati = await DatiNotifica.ottieni(p, totOggi, totDomani);
      expect(dati, null);
    });

    test('ASSENTE-BASSO', () async {
      Tipologia sOggi = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eOggi = Tipologia([
        {rossa: assente},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totOggi = insiemeOrdinate(sOggi, eOggi);

      Tipologia sDomani = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eDomani = Tipologia([
        {rossa: basso},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totDomani = insiemeOrdinate(sDomani, eDomani);

      DatiNotifica? dati = await DatiNotifica.ottieni(p, totOggi, totDomani);
      expect(dati, null);
    });

    test('ASSENTE-MEDIO', () async {
      Tipologia sOggi = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eOggi = Tipologia([
        {rossa: assente},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totOggi = insiemeOrdinate(sOggi, eOggi);

      Tipologia sDomani = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eDomani = Tipologia([
        {rossa: medio},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totDomani = insiemeOrdinate(sDomani, eDomani);

      DatiNotifica? dati = await DatiNotifica.ottieni(p, totOggi, totDomani);
      expect(dati!.stampaNomi, "[rossa]");
      expect(dati.stampaLivello, "AUMENTO");
    });

    test('ASSENTE-ALTO', () async {
      Tipologia sOggi = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eOggi = Tipologia([
        {rossa: assente},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totOggi = insiemeOrdinate(sOggi, eOggi);

      Tipologia sDomani = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eDomani = Tipologia([
        {rossa: alto},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totDomani = insiemeOrdinate(sDomani, eDomani);

      DatiNotifica? dati = await DatiNotifica.ottieni(p, totOggi, totDomani);
      expect(dati!.stampaNomi, "[rossa]");
      expect(dati.stampaLivello, "AUMENTO");
    });

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST BASSO-
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    test('BASSO-ASSENTE', () async {
      Tipologia sOggi = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eOggi = Tipologia([
        {rossa: basso},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totOggi = insiemeOrdinate(sOggi, eOggi);

      Tipologia sDomani = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eDomani = Tipologia([
        {rossa: assente},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totDomani = insiemeOrdinate(sDomani, eDomani);

      DatiNotifica? dati = await DatiNotifica.ottieni(p, totOggi, totDomani);
      expect(dati, null);
    });

    test('BASSO-BASSO', () async {
      Tipologia sOggi = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eOggi = Tipologia([
        {rossa: basso},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totOggi = insiemeOrdinate(sOggi, eOggi);

      Tipologia sDomani = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eDomani = Tipologia([
        {rossa: basso},
        {verde: basso},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totDomani = insiemeOrdinate(sDomani, eDomani);

      DatiNotifica? dati = await DatiNotifica.ottieni(p, totOggi, totDomani);
      expect(dati, null);
    });

    test('BASSO-MEDIO', () async {
      Tipologia sOggi = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eOggi = Tipologia([
        {rossa: basso},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totOggi = insiemeOrdinate(sOggi, eOggi);

      Tipologia sDomani = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eDomani = Tipologia([
        {rossa: medio},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totDomani = insiemeOrdinate(sDomani, eDomani);

      DatiNotifica? dati = await DatiNotifica.ottieni(p, totOggi, totDomani);
      expect(dati!.stampaNomi, "[rossa]");
      expect(dati.stampaLivello, "AUMENTO");
    });

    test('BASSO-ALTO', () async {
      Tipologia sOggi = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eOggi = Tipologia([
        {rossa: basso},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totOggi = insiemeOrdinate(sOggi, eOggi);

      Tipologia sDomani = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eDomani = Tipologia([
        {rossa: alto},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totDomani = insiemeOrdinate(sDomani, eDomani);

      DatiNotifica? dati = await DatiNotifica.ottieni(p, totOggi, totDomani);
      expect(dati!.stampaNomi, "[rossa]");
      expect(dati.stampaLivello, "AUMENTO");
    });

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST MEDIO-
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    test('MEDIO-ASSENTE', () async {
      Tipologia sOggi = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eOggi = Tipologia([
        {rossa: medio},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totOggi = insiemeOrdinate(sOggi, eOggi);

      Tipologia sDomani = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eDomani = Tipologia([
        {rossa: assente},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totDomani = insiemeOrdinate(sDomani, eDomani);

      DatiNotifica? dati = await DatiNotifica.ottieni(p, totOggi, totDomani);
      expect(dati!.stampaNomi, "[rossa]");
      expect(dati.stampaLivello, "DIMINUZIONE");
    });

    test('MEDIO-BASSO', () async {
      Tipologia sOggi = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eOggi = Tipologia([
        {rossa: medio},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totOggi = insiemeOrdinate(sOggi, eOggi);

      Tipologia sDomani = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eDomani = Tipologia([
        {rossa: basso},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totDomani = insiemeOrdinate(sDomani, eDomani);

      DatiNotifica? dati = await DatiNotifica.ottieni(p, totOggi, totDomani);
      expect(dati!.stampaNomi, "[rossa]");
      expect(dati.stampaLivello, "DIMINUZIONE");
    });

    test('MEDIO-MEDIO', () async {
      Tipologia sOggi = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eOggi = Tipologia([
        {rossa: medio},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totOggi = insiemeOrdinate(sOggi, eOggi);

      Tipologia sDomani = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eDomani = Tipologia([
        {rossa: medio},
        {verde: medio},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totDomani = insiemeOrdinate(sDomani, eDomani);

      DatiNotifica? dati = await DatiNotifica.ottieni(p, totOggi, totDomani);
      expect(dati!.stampaNomi, "prova");
      expect(dati.stampaLivello, "provo");
    });

    test('MEDIO-ALTO', () async {
      Tipologia sOggi = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eOggi = Tipologia([
        {rossa: medio},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totOggi = insiemeOrdinate(sOggi, eOggi);

      Tipologia sDomani = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eDomani = Tipologia([
        {rossa: alto},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totDomani = insiemeOrdinate(sDomani, eDomani);

      DatiNotifica? dati = await DatiNotifica.ottieni(p, totOggi, totDomani);
      expect(dati!.stampaNomi, "[rossa]");
      expect(dati.stampaLivello, "AUMENTO");
    });

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST ALTO-
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    test('ALTO-ASSENTE', () async {
      Tipologia sOggi = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eOggi = Tipologia([
        {rossa: alto},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totOggi = insiemeOrdinate(sOggi, eOggi);

      Tipologia sDomani = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eDomani = Tipologia([
        {rossa: assente},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totDomani = insiemeOrdinate(sDomani, eDomani);

      DatiNotifica? dati = await DatiNotifica.ottieni(p, totOggi, totDomani);
      expect(dati!.stampaNomi, "[rossa]");
      expect(dati.stampaLivello, "DIMINUZIONE");
    });

    test('ALTO-BASSO', () async {
      Tipologia sOggi = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eOggi = Tipologia([
        {rossa: alto},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totOggi = insiemeOrdinate(sOggi, eOggi);

      Tipologia sDomani = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eDomani = Tipologia([
        {rossa: basso},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totDomani = insiemeOrdinate(sDomani, eDomani);

      DatiNotifica? dati = await DatiNotifica.ottieni(p, totOggi, totDomani);
      expect(dati!.stampaNomi, "[rossa]");
      expect(dati.stampaLivello, "DIMINUZIONE");
    });

    test('ALTO-MEDIO', () async {
      Tipologia sOggi = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eOggi = Tipologia([
        {rossa: alto},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totOggi = insiemeOrdinate(sOggi, eOggi);

      Tipologia sDomani = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eDomani = Tipologia([
        {rossa: medio},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totDomani = insiemeOrdinate(sDomani, eDomani);

      DatiNotifica? dati = await DatiNotifica.ottieni(p, totOggi, totDomani);
      expect(dati!.stampaNomi, "[rossa]");
      expect(dati.stampaLivello, "DIMINUZIONE");
    });

    test('ALTO-ALTO', () async {
      Tipologia sOggi = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eOggi = Tipologia([
        {rossa: alto},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totOggi = insiemeOrdinate(sOggi, eOggi);

      Tipologia sDomani = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eDomani = Tipologia([
        {rossa: alto},
        {verde: alto},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totDomani = insiemeOrdinate(sDomani, eDomani);

      DatiNotifica? dati = await DatiNotifica.ottieni(p, totOggi, totDomani);
      expect(dati!.stampaNomi, "prova");
      expect(dati.stampaLivello, "provo");
    });
  });

  group('Test Provider dati_notifica TIPOLOGIE DIVERSE', () {
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST ASSENTE-
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    test('ASSENTE-ASSENTE', () async {
      Tipologia sOggi = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eOggi = Tipologia([
        {rossa: assente},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totOggi = insiemeOrdinate(sOggi, eOggi);

      Tipologia sDomani = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eDomani = Tipologia([
        {rossa: assente},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totDomani = insiemeOrdinate(sDomani, eDomani);

      DatiNotifica? dati = await DatiNotifica.ottieni(p, totOggi, totDomani);
      expect(dati, null);
    });

    test('ASSENTE-BASSO', () async {
      Tipologia sOggi = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eOggi = Tipologia([
        {rossa: assente},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totOggi = insiemeOrdinate(sOggi, eOggi);

      Tipologia sDomani = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eDomani = Tipologia([
        {rossa: basso},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totDomani = insiemeOrdinate(sDomani, eDomani);

      DatiNotifica? dati = await DatiNotifica.ottieni(p, totOggi, totDomani);
      expect(dati, null);
    });

    test('ASSENTE-MEDIO', () async {
      Tipologia sOggi = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eOggi = Tipologia([
        {rossa: assente},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totOggi = insiemeOrdinate(sOggi, eOggi);

      Tipologia sDomani = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eDomani = Tipologia([
        {rossa: medio},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totDomani = insiemeOrdinate(sDomani, eDomani);

      DatiNotifica? dati = await DatiNotifica.ottieni(p, totOggi, totDomani);
      expect(dati!.stampaNomi, "[rossa]");
      expect(dati.stampaLivello, "AUMENTO");
    });

    test('ASSENTE-ALTO', () async {
      Tipologia sOggi = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eOggi = Tipologia([
        {rossa: assente},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totOggi = insiemeOrdinate(sOggi, eOggi);

      Tipologia sDomani = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eDomani = Tipologia([
        {rossa: alto},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totDomani = insiemeOrdinate(sDomani, eDomani);

      DatiNotifica? dati = await DatiNotifica.ottieni(p, totOggi, totDomani);
      expect(dati!.stampaNomi, "[rossa]");
      expect(dati.stampaLivello, "AUMENTO");
    });

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST BASSO-
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    test('BASSO-ASSENTE', () async {
      Tipologia sOggi = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eOggi = Tipologia([
        {rossa: basso},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totOggi = insiemeOrdinate(sOggi, eOggi);

      Tipologia sDomani = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eDomani = Tipologia([
        {rossa: assente},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totDomani = insiemeOrdinate(sDomani, eDomani);

      DatiNotifica? dati = await DatiNotifica.ottieni(p, totOggi, totDomani);
      expect(dati, null);
    });

    test('BASSO-BASSO', () async {
      Tipologia sOggi = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eOggi = Tipologia([
        {rossa: basso},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totOggi = insiemeOrdinate(sOggi, eOggi);

      Tipologia sDomani = Tipologia([
        {grigia: basso},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eDomani = Tipologia([
        {rossa: assente},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totDomani = insiemeOrdinate(sDomani, eDomani);

      DatiNotifica? dati = await DatiNotifica.ottieni(p, totOggi, totDomani);
      expect(dati, null);
    });

    test('BASSO-MEDIO', () async {
      Tipologia sOggi = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eOggi = Tipologia([
        {rossa: basso},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totOggi = insiemeOrdinate(sOggi, eOggi);

      Tipologia sDomani = Tipologia([
        {grigia: medio},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eDomani = Tipologia([
        {rossa: assente},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totDomani = insiemeOrdinate(sDomani, eDomani);

      DatiNotifica? dati = await DatiNotifica.ottieni(p, totOggi, totDomani);
      expect(dati!.stampaNomi, "[grigia]");
      expect(dati.stampaLivello, "AUMENTO");
    });

    test('BASSO-ALTO', () async {
      Tipologia sOggi = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eOggi = Tipologia([
        {rossa: basso},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totOggi = insiemeOrdinate(sOggi, eOggi);

      Tipologia sDomani = Tipologia([
        {grigia: alto},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eDomani = Tipologia([
        {rossa: assente},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totDomani = insiemeOrdinate(sDomani, eDomani);

      DatiNotifica? dati = await DatiNotifica.ottieni(p, totOggi, totDomani);
      expect(dati!.stampaNomi, "[grigia]");
      expect(dati.stampaLivello, "AUMENTO");
    });

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST MEDIO-
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    test('MEDIO-ASSENTE', () async {
      Tipologia sOggi = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eOggi = Tipologia([
        {rossa: medio},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totOggi = insiemeOrdinate(sOggi, eOggi);

      Tipologia sDomani = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eDomani = Tipologia([
        {rossa: assente},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totDomani = insiemeOrdinate(sDomani, eDomani);

      DatiNotifica? dati = await DatiNotifica.ottieni(p, totOggi, totDomani);
      expect(dati!.stampaNomi, "[rossa]");
      expect(dati.stampaLivello, "DIMINUZIONE");
    });

    test('MEDIO-BASSO', () async {
      Tipologia sOggi = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eOggi = Tipologia([
        {rossa: medio},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totOggi = insiemeOrdinate(sOggi, eOggi);

      Tipologia sDomani = Tipologia([
        {grigia: basso},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eDomani = Tipologia([
        {rossa: assente},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totDomani = insiemeOrdinate(sDomani, eDomani);

      DatiNotifica? dati = await DatiNotifica.ottieni(p, totOggi, totDomani);
      expect(dati!.stampaNomi, "[rossa]");
      expect(dati.stampaLivello, "DIMINUZIONE");
    });

    test('MEDIO-MEDIO', () async {
      Tipologia sOggi = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eOggi = Tipologia([
        {rossa: medio},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totOggi = insiemeOrdinate(sOggi, eOggi);

      Tipologia sDomani = Tipologia([
        {grigia: medio},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eDomani = Tipologia([
        {rossa: assente},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totDomani = insiemeOrdinate(sDomani, eDomani);

      DatiNotifica? dati = await DatiNotifica.ottieni(p, totOggi, totDomani);
      expect(dati!.stampaNomi, "prova");
      expect(dati.stampaLivello, "provo");
    });

    test('MEDIO-ALTO', () async {
      Tipologia sOggi = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eOggi = Tipologia([
        {rossa: medio},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totOggi = insiemeOrdinate(sOggi, eOggi);

      Tipologia sDomani = Tipologia([
        {grigia: alto},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eDomani = Tipologia([
        {rossa: medio},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totDomani = insiemeOrdinate(sDomani, eDomani);

      DatiNotifica? dati = await DatiNotifica.ottieni(p, totOggi, totDomani);
      expect(dati!.stampaNomi, "[grigia]");
      expect(dati.stampaLivello, "AUMENTO");
    });

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST ALTO-
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    test('ALTO-ASSENTE', () async {
      Tipologia sOggi = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eOggi = Tipologia([
        {rossa: alto},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totOggi = insiemeOrdinate(sOggi, eOggi);

      Tipologia sDomani = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eDomani = Tipologia([
        {rossa: assente},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totDomani = insiemeOrdinate(sDomani, eDomani);

      DatiNotifica? dati = await DatiNotifica.ottieni(p, totOggi, totDomani);
      expect(dati!.stampaNomi, "[rossa]");
      expect(dati.stampaLivello, "DIMINUZIONE");
    });

    test('ALTO-BASSO', () async {
      Tipologia sOggi = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eOggi = Tipologia([
        {rossa: alto},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totOggi = insiemeOrdinate(sOggi, eOggi);

      Tipologia sDomani = Tipologia([
        {grigia: basso},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eDomani = Tipologia([
        {rossa: assente},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totDomani = insiemeOrdinate(sDomani, eDomani);

      DatiNotifica? dati = await DatiNotifica.ottieni(p, totOggi, totDomani);
      expect(dati!.stampaNomi, "[rossa]");
      expect(dati.stampaLivello, "DIMINUZIONE");
    });

    test('ALTO-MEDIO', () async {
      Tipologia sOggi = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eOggi = Tipologia([
        {rossa: alto},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totOggi = insiemeOrdinate(sOggi, eOggi);

      Tipologia sDomani = Tipologia([
        {grigia: medio},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eDomani = Tipologia([
        {rossa: assente},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totDomani = insiemeOrdinate(sDomani, eDomani);

      DatiNotifica? dati = await DatiNotifica.ottieni(p, totOggi, totDomani);
      expect(dati!.stampaNomi, "[rossa]");
      expect(dati.stampaLivello, "DIMINUZIONE");
    });

    test('ALTO-ALTO', () async {
      Tipologia sOggi = Tipologia([
        {grigia: assente},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eOggi = Tipologia([
        {rossa: alto},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totOggi = insiemeOrdinate(sOggi, eOggi);

      Tipologia sDomani = Tipologia([
        {grigia: alto},
        {nera: assente},
        {beige: assente},
        {marrone: assente}
      ], "Spore", p);
      Tipologia eDomani = Tipologia([
        {rossa: assente},
        {verde: assente},
        {blu: assente},
        {gialla: assente}
      ], "Erbe", p);
      List<Tipologia> totDomani = insiemeOrdinate(sDomani, eDomani);

      DatiNotifica? dati = await DatiNotifica.ottieni(p, totOggi, totDomani);
      expect(dati!.stampaNomi, "prova");
      expect(dati.stampaLivello, "provo");
    });
  });
}
