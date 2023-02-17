import 'package:demo_1/providers/polline.dart';
import 'package:test/test.dart';

void main() async {
  // dichiaro qua le strutture asincrone perchè group non può essere async
  List<Polline> poll = await Polline.fetch();
  List<Stazione> staz = await Stazione.fetch();

  group('Test Provider polline, stazione, tendenza', () {
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
    test('Controllare esistenza di stazioni', () {
      expect(staz.contains(stazioneCercata), true);
    });

    test('Controllare esistenza di pollini', () {
      Polline pollineCercato = const Polline(
          partId: 1323,
          parentId: 1,
          partLow: 0.5,
          partMiddle: 16,
          partHigh: 50,
          parentNameL: "Betulaceae",
          partCode: "BETU",
          partNameI: "Betulacee",
          partNameD: "Birkengewächse",
          partNameE: "birch family",
          partNameF: "",
          partNameL: "Betulaceae",
          tipo: "Alberi");
      expect(poll.contains(pollineCercato), true);
    });

    test('Controllare calcolo Tendenza', () async {
      List<Concentrazione> ultimaConc =
          await Concentrazione.fetch(stazioneCercata);
      Map<Polline, Tendenza> tend = await tendenza(stazioneCercata, poll);
      // partendo dall'ultima concentrazione controlla che la tendenza restituita contenga i tipi indicati nell'ultima concentrazione
      for (Concentrazione conc in ultimaConc) {
        for (Polline p in tend.keys) {
          if (conc.partId == p.partId) {
            // ignore: unrelated_type_equality_checks
            expect(conc == p, true);
          }
        }
      }
      // partendo dalla tendenza controlla che contenga i tipi indicati nell'ultima concentrazione
      for (Polline p in tend.keys) {
        bool presente = false;
        for (Concentrazione c in ultimaConc) {
          if (p.partId == c.partId) {
            presente = true;
          }
        }
        expect(presente, true);
      }
    });
  });
}
