import 'package:demo_1/providers/dati_notifica.dart';
import 'package:demo_1/providers/position.dart';
import 'package:demo_1/providers/preferences.dart';
import 'package:demo_1/utils/calcolo_tipo_maggiore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
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

  group('Test pesi notifiche particelle', () {
    setUpAll(() {
      FlutterSecureStorage.setMockInitialValues({});
    });

    group('STESSA TIPOLOGIA', (() {
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST ASSENTE-ASSENTE
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      group('ASSENTE-ASSENTE', (() {
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
        test('Nessuna particella', () async {
          var storage = const FlutterSecureStorage();

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particella a 0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particella a 2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particella a 3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particelle a 0.5-0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particelle a 0.5-2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particelle a 0.5-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particelle a 2-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });
      }));

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST ASSENTE-BASSO
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      group('ASSENTE-BASSO', (() {
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
        test('Nessuna particella', () async {
          var storage = const FlutterSecureStorage();

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particella a 0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particella a 2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[rossa]");
          expect(dati.valore, "AUMENTO");
        });

        test('Particella a 3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[rossa]");
          expect(dati.valore, "AUMENTO");
        });

        test('Particelle a 0.5-0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particelle a 0.5-2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particelle a 0.5-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particelle a 2-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[rossa]");
          expect(dati.valore, "AUMENTO");
        });
      }));

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST ASSENTE-MEDIO
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      group('ASSENTE-MEDIO', (() {
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
          {verde: medio},
          {blu: assente},
          {gialla: assente}
        ], "Erbe", p);
        List<Tipologia> totDomani = insiemeOrdinate(sDomani, eDomani);
        test('Nessuna particella', () async {
          var storage = const FlutterSecureStorage();

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[rossa, verde]");
          expect(dati.valore, "AUMENTO");
        });

        test('Particella a 0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[rossa, verde]");
          expect(dati.valore, "AUMENTO");
        });

        test('Particella a 2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[rossa, verde]");
          expect(dati.valore, "AUMENTO");
        });

        test('Particella a 3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[rossa, verde]");
          expect(dati.valore, "AUMENTO");
        });

        test('Particelle a 0.5-0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[rossa, verde]");
          expect(dati.valore, "AUMENTO");
        });

        test('Particelle a 0.5-2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[verde, rossa]");
          expect(dati.valore, "AUMENTO");
        });

        test('Particelle a 0.5-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[verde, rossa]");
          expect(dati.valore, "AUMENTO");
        });

        test('Particelle a 2-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[verde, rossa]");
          expect(dati.valore, "AUMENTO");
        });
      }));

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST ASSENTE-ALTO
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      group('ASSENTE-ALTO', (() {
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
          {verde: alto},
          {blu: assente},
          {gialla: assente}
        ], "Erbe", p);
        List<Tipologia> totDomani = insiemeOrdinate(sDomani, eDomani);
        test('Nessuna particella', () async {
          var storage = const FlutterSecureStorage();

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[rossa, verde]");
          expect(dati.valore, "AUMENTO");
        });

        test('Particella a 0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[rossa, verde]");
          expect(dati.valore, "AUMENTO");
        });

        test('Particella a 2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[rossa, verde]");
          expect(dati.valore, "AUMENTO");
        });

        test('Particella a 3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[rossa, verde]");
          expect(dati.valore, "AUMENTO");
        });

        test('Particelle a 0.5-0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[rossa, verde]");
          expect(dati.valore, "AUMENTO");
        });

        test('Particelle a 0.5-2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[verde, rossa]");
          expect(dati.valore, "AUMENTO");
        });

        test('Particelle a 0.5-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[verde, rossa]");
          expect(dati.valore, "AUMENTO");
        });

        test('Particelle a 2-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[verde, rossa]");
          expect(dati.valore, "AUMENTO");
        });
      }));

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST BASSO-ASSENTE
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      group('BASSO-ASSENTE', (() {
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
        test('Nessuna particella', () async {
          var storage = const FlutterSecureStorage();

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particella a 0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particella a 2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particella a 3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 0.5-0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particelle a 0.5-2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particelle a 0.5-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '3');
          await storage.write(key: 'verde', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 2-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });
      }));

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST BASSO-BASSO
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      group('BASSO-BASSO', (() {
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
        test('Nessuna particella', () async {
          var storage = const FlutterSecureStorage();

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particella a 0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particella a 2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particella a 3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particelle a 0.5-0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particelle a 0.5-2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          print(dati!);
          expect(dati!.particelle, '[verde]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 0.5-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[verde]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 2-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[verde]');
          expect(dati.valore, 'AUMENTO');
        });
      }));

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST BASSO-MEDIO
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      group('BASSO-MEDIO', (() {
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
        test('Nessuna particella', () async {
          var storage = const FlutterSecureStorage();

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particella a 0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particella a 2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particella a 3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 0.5-0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 0.5-2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 0.5-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '3');
          await storage.write(key: 'blu', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 2-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'AUMENTO');
        });
      }));

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST BASSO-ALTO
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      group('BASSO-ALTO', (() {
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
        test('Nessuna particella', () async {
          var storage = const FlutterSecureStorage();

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particella a 0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particella a 2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particella a 3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 0.5-0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 0.5-2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 0.5-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 2-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'AUMENTO');
        });
      }));

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST MEDIO-ASSENTE
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      group('MEDIO-ASSENTE', (() {
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
        test('Nessuna particella', () async {
          var storage = const FlutterSecureStorage();

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particella a 0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particella a 2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particella a 3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 0.5-0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 0.5-2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 0.5-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 2-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });
      }));

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST MEDIO-BASSO
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

      group('MEDIO-BASSO', (() {
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
        test('Nessuna particella', () async {
          var storage = const FlutterSecureStorage();

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particella a 0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particella a 2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particella a 3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 0.5-0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 0.5-2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 0.5-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 2-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });
      }));

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST MEDIO-MEDIO
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      group('MEDIO-MEDIO', (() {
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
        test('Nessuna particella', () async {
          var storage = const FlutterSecureStorage();

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[verde]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particella a 0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[verde]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particella a 2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[verde]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particella a 3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[verde]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 0.5-0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[verde]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 0.5-2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[verde]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 0.5-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[verde]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 2-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[verde]');
          expect(dati.valore, 'AUMENTO');
        });
      }));

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST MEDIO-ALTO
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      group('MEDIO-ALTO', (() {
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
        test('Nessuna particella', () async {
          var storage = const FlutterSecureStorage();

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particella a 0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particella a 2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particella a 3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 0.5-0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 0.5-2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 0.5-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 2-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'AUMENTO');
        });
      }));

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST ALTO-ASSENTE
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      group('ALTO-ASSENTE', (() {
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
        test('Nessuna particella', () async {
          var storage = const FlutterSecureStorage();

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particella a 0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particella a 2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particella a 3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 0.5-0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 0.5-2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 0.5-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 2-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });
      }));

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST ALTO-BASSO
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

      group('ALTO-BASSO', (() {
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
        test('Nessuna particella', () async {
          var storage = const FlutterSecureStorage();

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particella a 0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particella a 2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particella a 3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 0.5-0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 0.5-2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 0.5-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 2-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });
      }));

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST ALTO-MEDIO
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      group('ALTO-MEDIO', (() {
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
        test('Nessuna particella', () async {
          var storage = const FlutterSecureStorage();

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particella a 0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particella a 2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particella a 3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 0.5-0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 0.5-2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 0.5-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 2-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });
      }));

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST ALTO-ALTO
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      group('ALTO-ALTO', (() {
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
        test('Nessuna particella', () async {
          var storage = const FlutterSecureStorage();

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[verde]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particella a 0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[verde]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particella a 2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[verde]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particella a 3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[verde]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 0.5-0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[verde]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 0.5-2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[verde]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 0.5-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[verde]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 2-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[verde]');
          expect(dati.valore, 'AUMENTO');
        });
      }));
    }));

    group('TIPOLOGIE DIVERSE', (() {
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST ASSENTE-ASSENTE
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      group('ASSENTE-ASSENTE', (() {
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
        test('Nessuna particella', () async {
          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particella a 0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particella a 2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particella a 3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particelle a 0.5-0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particelle a 0.5-2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particelle a 0.5-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particelle a 2-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });
      }));

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST ASSENTE-BASSO
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      group('ASSENTE-BASSO', (() {
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
        test('Nessuna particella', () async {
          var storage = const FlutterSecureStorage();

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particella a 0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particella a 2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[rossa]");
          expect(dati.valore, "AUMENTO");
        });

        test('Particella a 3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[rossa]");
          expect(dati.valore, "AUMENTO");
        });

        test('Particelle a 0.5-0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particelle a 0.5-2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particelle a 0.5-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particelle a 2-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[rossa]");
          expect(dati.valore, "AUMENTO");
        });
      }));

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST ASSENTE-MEDIO
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      group('ASSENTE-MEDIO', (() {
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
          {verde: medio},
          {blu: assente},
          {gialla: assente}
        ], "Erbe", p);
        List<Tipologia> totDomani = insiemeOrdinate(sDomani, eDomani);
        test('Nessuna particella', () async {
          var storage = const FlutterSecureStorage();

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[rossa, verde]");
          expect(dati.valore, "AUMENTO");
        });

        test('Particella a 0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[rossa, verde]");
          expect(dati.valore, "AUMENTO");
        });

        test('Particella a 2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[rossa, verde]");
          expect(dati.valore, "AUMENTO");
        });

        test('Particella a 3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[rossa, verde]");
          expect(dati.valore, "AUMENTO");
        });

        test('Particelle a 0.5-0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[rossa, verde]");
          expect(dati.valore, "AUMENTO");
        });

        test('Particelle a 0.5-2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[verde, rossa]");
          expect(dati.valore, "AUMENTO");
        });

        test('Particelle a 0.5-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[verde, rossa]");
          expect(dati.valore, "AUMENTO");
        });

        test('Particelle a 2-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[verde, rossa]");
          expect(dati.valore, "AUMENTO");
        });
      }));

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST ASSENTE-ALTO
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      group('ASSENTE-ALTO', (() {
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
          {verde: alto},
          {blu: assente},
          {gialla: assente}
        ], "Erbe", p);
        List<Tipologia> totDomani = insiemeOrdinate(sDomani, eDomani);
        test('Nessuna particella', () async {
          var storage = const FlutterSecureStorage();

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[rossa, verde]");
          expect(dati.valore, "AUMENTO");
        });

        test('Particella a 0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[rossa, verde]");
          expect(dati.valore, "AUMENTO");
        });

        test('Particella a 2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[rossa, verde]");
          expect(dati.valore, "AUMENTO");
        });

        test('Particella a 3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[rossa, verde]");
          expect(dati.valore, "AUMENTO");
        });

        test('Particelle a 0.5-0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[rossa, verde]");
          expect(dati.valore, "AUMENTO");
        });

        test('Particelle a 0.5-2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[verde, rossa]");
          expect(dati.valore, "AUMENTO");
        });

        test('Particelle a 0.5-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[verde, rossa]");
          expect(dati.valore, "AUMENTO");
        });

        test('Particelle a 2-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[verde, rossa]");
          expect(dati.valore, "AUMENTO");
        });
      }));

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST BASSO-ASSENTE
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      group('BASSO-ASSENTE', (() {
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
        test('Nessuna particella', () async {
          var storage = const FlutterSecureStorage();

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particella a 0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particella a 2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particella a 3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 0.5-0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particelle a 0.5-2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particelle a 0.5-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '3');
          await storage.write(key: 'verde', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 2-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });
      }));

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST BASSO-BASSO
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      group('BASSO-BASSO', (() {
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
        test('Nessuna particella', () async {
          var storage = const FlutterSecureStorage();

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particella a 0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'grigia', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particella a 2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'grigia', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[grigia]");
          expect(dati.valore, "AUMENTO");
        });

        test('Particella a 3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'grigia', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[grigia]");
          expect(dati.valore, "AUMENTO");
        });

        test('Particelle a 0.5-0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'grigia', value: '0.5');
          await storage.write(key: 'nera', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particelle a 0.5-2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'grigia', value: '0.5');
          await storage.write(key: 'nera', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particelle a 0.5-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'grigia', value: '0.5');
          await storage.write(key: 'nera', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati, null);
        });

        test('Particelle a 2-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'grigia', value: '2');
          await storage.write(key: 'nera', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, "[grigia]");
          expect(dati.valore, "AUMENTO");
        });
      }));

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST BASSO-MEDIO
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      group('BASSO-MEDIO', (() {
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
          {rossa: basso},
          {verde: assente},
          {blu: assente},
          {gialla: assente}
        ], "Erbe", p);
        List<Tipologia> totDomani = insiemeOrdinate(sDomani, eDomani);
        test('Nessuna particella', () async {
          var storage = const FlutterSecureStorage();

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[grigia]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particella a 0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'grigia', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[grigia]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particella a 2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'grigia', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[grigia]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particella a 3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'grigia', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[grigia]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 0.5-0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'grigia', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[grigia]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 0.5-2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'grigia', value: '0.5');
          await storage.write(key: 'rossa', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[grigia]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 0.5-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'grigia', value: '0.5');
          await storage.write(key: 'rossa', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[grigia]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 2-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'grigia', value: '2');
          await storage.write(key: 'rossa', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[grigia]');
          expect(dati.valore, 'AUMENTO');
        });
      }));

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST BASSO-ALTO
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      group('BASSO-ALTO', (() {
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
          {gialla: basso}
        ], "Erbe", p);
        List<Tipologia> totOggi = insiemeOrdinate(sOggi, eOggi);
        Tipologia sDomani = Tipologia([
          {grigia: alto},
          {nera: basso},
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
        test('Nessuna particella', () async {
          var storage = const FlutterSecureStorage();

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[grigia]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particella a 0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'grigia', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[grigia]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particella a 2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[grigia]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particella a 3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[grigia]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 0.5-0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'grigia', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[grigia]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 0.5-2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'grigia', value: '0.5');
          await storage.write(key: 'verde', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[grigia]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 0.5-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'grigia', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[grigia]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 2-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'grigia', value: '2');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[grigia]');
          expect(dati.valore, 'AUMENTO');
        });
      }));

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST MEDIO-ASSENTE
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      group('MEDIO-ASSENTE', (() {
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
        test('Nessuna particella', () async {
          var storage = const FlutterSecureStorage();

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particella a 0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particella a 2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particella a 3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 0.5-0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 0.5-2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 0.5-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 2-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });
      }));

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST MEDIO-BASSO
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

      group('MEDIO-BASSO', (() {
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
          {nera: basso},
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
        test('Nessuna particella', () async {
          var storage = const FlutterSecureStorage();

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particella a 0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'grigia', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particella a 2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'grigia', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[grigia]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particella a 3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 0.5-0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 0.5-2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 0.5-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 2-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });
      }));

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST MEDIO-MEDIO
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      group('MEDIO-MEDIO', (() {
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
        test('Nessuna particella', () async {
          var storage = const FlutterSecureStorage();

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[verde]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particella a 0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[verde]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particella a 2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[verde]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particella a 3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[verde]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 0.5-0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[verde]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 0.5-2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[verde]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 0.5-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[verde]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 2-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[verde]');
          expect(dati.valore, 'AUMENTO');
        });
      }));

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST MEDIO-ALTO
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      group('MEDIO-ALTO', (() {
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
        test('Nessuna particella', () async {
          var storage = const FlutterSecureStorage();

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particella a 0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particella a 2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particella a 3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 0.5-0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 0.5-2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 0.5-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 2-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'AUMENTO');
        });
      }));

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST ALTO-ASSENTE
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      group('ALTO-ASSENTE', (() {
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
        test('Nessuna particella', () async {
          var storage = const FlutterSecureStorage();

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particella a 0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particella a 2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particella a 3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 0.5-0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 0.5-2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 0.5-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 2-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });
      }));

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST ALTO-BASSO
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

      group('ALTO-BASSO', (() {
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
        test('Nessuna particella', () async {
          var storage = const FlutterSecureStorage();

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particella a 0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particella a 2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particella a 3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 0.5-0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 0.5-2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 0.5-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 2-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });
      }));

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST ALTO-MEDIO
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      group('ALTO-MEDIO', (() {
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
        test('Nessuna particella', () async {
          var storage = const FlutterSecureStorage();

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particella a 0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particella a 2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particella a 3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 0.5-0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 0.5-2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 0.5-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });

        test('Particelle a 2-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[rossa]');
          expect(dati.valore, 'DIMINUZIONE');
        });
      }));

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                                TEST ALTO-ALTO
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      group('ALTO-ALTO', (() {
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
        test('Nessuna particella', () async {
          var storage = const FlutterSecureStorage();

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[verde]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particella a 0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[verde]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particella a 2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[verde]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particella a 3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[verde]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 0.5-0.5', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '0.5');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[verde]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 0.5-2', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '2');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[verde]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 0.5-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '0.5');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[verde]');
          expect(dati.valore, 'AUMENTO');
        });

        test('Particelle a 2-3', () async {
          var storage = const FlutterSecureStorage();
          await storage.write(key: 'rossa', value: '2');
          await storage.write(key: 'verde', value: '3');

          DatiNotifica? dati =
              await DatiNotifica.ottieni(p, totOggi, totDomani);
          expect(dati!.particelle, '[verde]');
          expect(dati.valore, 'AUMENTO');
        });
      }));
    }));

    test('Test read write', () async {});
  });
}


/*

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
      print(totOggi);
      DatiNotifica? dati = await DatiNotifica.ottieni(p, totOggi, totDomani);
      print(totOggi);
      Peso.aumentaMultipliTest(totOggi, Peso.calcolaPeso(10, 2));
      Peso.aumentaMultipliTest(totOggi, Peso.calcolaPeso(10, 2));
      var storage = const FlutterSecureStorage();

      final value = await storage.read(key: 'rossa');
      print(await Peso.getPeso('rossa', storage));
      //expect(value, 'new_value');

*/