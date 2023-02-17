import 'package:demo_1/providers/polline.dart';
import 'package:demo_1/providers/position.dart';
import 'package:test/test.dart';

void main() async {
  // dichiaro qua le strutture asincrone perchè group non può essere async
  group('Test Provider posizione', () {
    test('Controlla localizzazione stazione più vicina', () async {
      // posizione di Modena
      Posizione p = Posizione(44.64711867532993, 10.918126753845915, "Modena");
      Stazione stazioneCercata = const Stazione(
          latitude: 44.650804,
          longitude: 10.925505,
          regiId: 11,
          statId: 122,
          regiNameD: "Emilia Romagna",
          regiNameI: "Emilia Romagna",
          statCode: "MO1",
          statNameD: "Modena",
          statenameI: "Modena");
      expect(await Stazione.trovaStaz(p), stazioneCercata);
    });
  });
}
