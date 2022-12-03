import 'package:demo_1/providers/meteo.dart';
import 'package:demo_1/providers/polline.dart';
import 'package:demo_1/providers/position.dart';
import 'package:demo_1/screens/homepage/dati_giornalieri.dart';
import 'package:demo_1/utils/calcolo_tipo_maggiore.dart';
import 'package:demo_1/utils/format_meteo.dart';
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
          Stazione.trovaStaz(dataPos),
          Tipologia.daPosizione(dataPos, 0),
          Tipologia.daPosizione(dataPos, 1),
          Tipologia.daPosizione(dataPos, 2)
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
          Stazione s = snapshot.data![1];
          List<Tipologia> oggi = snapshot.data![2];
          List<Tipologia> domani = snapshot.data![3];
          List<Tipologia> dopoDomani = snapshot.data![4];

          /*
          Noti.initialize(flutterLocalNotificationsPlugin);
          DatiNotifiche? d = DatiNotifiche.ottieni(tendList, formInq);
          if (d != null) {
            Noti.showBigTextNotification(
                title: d.particella,
                body: d.livello,
                fln: flutterLocalNotificationsPlugin);
          }
          */

          return TabBarView(
            children: [
              ListGiornaliera(
                  m: meteoList[0],
                  tipologie: oggi,
                  s: s,
                  p: dataPos,
                  update: update),
              ListGiornaliera(
                  m: meteoList[1],
                  tipologie: domani,
                  s: s,
                  p: dataPos,
                  update: update),
              ListGiornaliera(
                  m: meteoList[2],
                  tipologie: dopoDomani,
                  s: s,
                  p: dataPos,
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
