import 'package:demo_1/providers/meteo.dart';
import 'package:demo_1/providers/polline.dart';
import 'package:demo_1/providers/position.dart';
import 'package:demo_1/screens/homepage/dati_giornalieri.dart';
import 'package:demo_1/utils/format_meteo.dart';
import 'package:flutter/material.dart';

// Contiene: TabBarView di 3 elementi e funzione tendenzaDaPos

// INPUT: Posizione
// OUTPUT: 3 ListGiornaliera rispettivamente OGGI, DOMANI, DOPODOMANI
class DatiCompleti extends StatelessWidget {
  const DatiCompleti({super.key, required this.dataPos});
  final Posizione dataPos;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait(
        [
          fetchMeteo(dataPos.lat, dataPos.lon),
          tendenzaDaPos(dataPos),
        ],
      ),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasData) {
          Meteo m = snapshot.data![0];
          List<FormatMeteo> meteoList = [
            FormatMeteo(m, 0, dataPos),
            FormatMeteo(m, 1, dataPos),
            FormatMeteo(m, 2, dataPos)
          ];
          List<Map<Polline, String>> tendList = snapshot.data![1];
          return TabBarView(
            children: [
              ListGiornaliera(m: meteoList[0], tend: tendList[0]),
              ListGiornaliera(m: meteoList[1], tend: tendList[1]),
              ListGiornaliera(m: meteoList[2], tend: tendList[2]),
            ],
          );
        } else {
          if (snapshot.hasError) {
            return TabBarView(
              children: [
                Center(child: Text(snapshot.error.toString())),
                Center(child: Text(snapshot.error.toString())),
                Center(child: Text(snapshot.error.toString())),
              ],
            );
          }
          return const TabBarView(
            children: [
              Center(
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                ),
              ),
              Center(
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                ),
              ),
              Center(
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

// da posizione restituisce tendenze dei 3 giorni successivi
// aggiunto controllo su stazione vuota
Future<List<Map<Polline, String>>> tendenzaDaPos(Posizione p) async {
  List<Polline> poll = await fetchPolline();
  List<Stazione> staz = await fetchStazione();
  Stazione localizzata = localizza(staz, p.lat, p.lon);
  Future<bool> checkStazione(Stazione s) async {
    List<Concentrazione> c = await fetchConcentrazione(s);
    if (c.isEmpty) return false;
    return true;
  }

  num maxIterazioni = staz.length;
  Stazione trovata = localizzata;

  for (num i = 0; i < maxIterazioni; i++) {
    bool check = await checkStazione(trovata);
    if (check) break;
    staz.remove(trovata);
    trovata = localizza(staz, p.lat, p.lon);
  }

  return [
    await tendenza(trovata, poll, offset: 0),
    await tendenza(trovata, poll, offset: 1),
    await tendenza(trovata, poll, offset: 2)
  ];
}
