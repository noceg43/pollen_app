import 'package:demo_1/providers/inquinamento.dart';
import 'package:demo_1/providers/polline.dart';

List<dynamic> getListaOrdinata(dynamic data) {
  List<dynamic> lista = [];
  if (data.values.first is List<ParticellaInquinante>) {
    lista = data.values.first;
    // ordinamento inquinamento
    lista.sort(
      (a, b) {
        return (b.superato ? 1 : 0).compareTo(a.superato ? 1 : 0);
      },
    );
  } else {
    Map<Polline, Tendenza> map = data.values.first;
    lista = [
      for (int i = 0; i < map.length; i++)
        {map.keys.elementAt(i): map.values.elementAt(i)}
    ];
    // ordinamento polline
    lista.sort(
      (a, b) {
        return b.values.first.gruppoValore
            .compareTo(a.values.first.gruppoValore);
      },
    );
  }
  return lista;
}
