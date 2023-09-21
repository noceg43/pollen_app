import 'package:demo_1/providers/inquinamento.dart';
import 'package:demo_1/providers/position.dart';
import 'package:test/test.dart';

void main() async {
  // dichiaro qua le strutture asincrone perchè group non può essere async
  group('Test Provider inquinamento', () {
    test('Controlla numero corretto di dati', () async {
      // posizione di Modena
      Posizione p = Posizione(44.64711867532993, 10.918126753845915, "Modena");
      Inquinamento inq = await Inquinamento.fetch(p);
      for (int i = 0; i < 5; i++) {
        List<ParticellaInquinante> inqGiorno = inq.giornaliero(i);
        expect(inqGiorno.length, 6);
      }
    });
  });
}
