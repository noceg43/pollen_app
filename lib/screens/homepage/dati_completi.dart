import 'package:demo_1/providers/meteo.dart';
import 'package:demo_1/providers/position.dart';
import 'package:demo_1/screens/homepage/dati_giornalieri.dart';
import 'package:flutter/material.dart';

class DatiCompleti extends StatelessWidget {
  const DatiCompleti({super.key, required this.data});
  final Posizione data;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Meteo>(
      future: fetchMeteo(data.lat, data.lon),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return TabBarView(
            children: [
              ListGiornaliera(offset: 0, m: snapshot.data!),
              Center(child: Text(snapshot.data.toString())),
              Center(child: Text(snapshot.data.toString())),
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
