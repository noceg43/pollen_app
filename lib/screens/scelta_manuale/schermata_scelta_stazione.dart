import 'package:demo_1/providers/polline.dart';
import 'package:demo_1/screens/scelta_manuale/scelta_stazione.dart';
import 'package:flutter/material.dart';

// Contiene: caricamento lista stazioni

// INPUT: niente
// OUTPUT: lista stazioni caricate
class SchermataSceltaStazione extends StatelessWidget {
  const SchermataSceltaStazione({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Stazione>>(
        future: fetchStazione(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {}
          if (snapshot.hasData) {
            return SceltaStazione(
              staz: snapshot.data!,
            );
          }
          return const SceltaStazioneCaricamento();
        });
  }
}
