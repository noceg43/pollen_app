import 'package:demo_1/providers/inquinamento.dart';
import 'package:demo_1/providers/meteo.dart';
import 'package:demo_1/providers/polline.dart';
import 'package:demo_1/providers/position.dart';
import 'package:demo_1/screens/homepage/dati_giornalieri.dart';
import 'package:demo_1/utils/format_meteo.dart';
import 'package:demo_1/utils/format_polline.dart';
import 'package:flutter/material.dart';

// Contiene: TabBarView di 3 elementi e funzione tendenzaDaPos

// INPUT: Posizione
// OUTPUT: 3 ListGiornaliera rispettivamente OGGI, DOMANI, DOPODOMANI
class DatiCompleti extends StatelessWidget {
  const DatiCompleti({
    super.key,
    required this.dataPos,
    required this.update,
  });
  final Posizione dataPos;
  final void Function() update;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait(
        [
          Meteo.fetch(dataPos.lat, dataPos.lon),
          tendenzaDaPos(dataPos),
          Inquinamento.fetch(dataPos.lat, dataPos.lon),
          trovaStaz(dataPos)
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
          List<Map<Polline, Tendenza>> tendList = snapshot.data![1];
          Inquinamento i = snapshot.data![2];
          List<List<ParticellaInquinante>> formInq = [
            i.giornaliero(0),
            i.giornaliero(1),
            i.giornaliero(2)
          ];
          Stazione s = snapshot.data![3];
          return TabBarView(
            children: [
              ListGiornaliera(
                  m: meteoList[0],
                  tend: tendList[0],
                  inq: formInq[0],
                  s: s,
                  update: update),
              ListGiornaliera(
                  m: meteoList[1],
                  tend: tendList[1],
                  inq: formInq[1],
                  s: s,
                  update: update),
              ListGiornaliera(
                  m: meteoList[2],
                  tend: tendList[2],
                  inq: formInq[2],
                  s: s,
                  update: update),
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
