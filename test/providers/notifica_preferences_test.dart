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

    test('Test read write', () async {
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
    });
    /*
    test('Test delete', () async {
      storage = const FlutterSecureStorage();

      await storage.delete(key: 'test_key');
      final value = await storage.read(key: 'test_key');
      expect(value, isNull);
    });

    test('Test containsKey', () async {
      storage = const FlutterSecureStorage();
      await storage.write(key: 'test_key', value: 'new_value');
      final keyExists = await storage.containsKey(key: 'test_key');
      expect(keyExists, true);
    });
    */
  });
}
