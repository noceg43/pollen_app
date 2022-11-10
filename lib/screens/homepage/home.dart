import 'package:demo_1/providers/position.dart';
import 'package:demo_1/screens/homepage/scheletro_dati_completi.dart';
import 'package:flutter/material.dart';

// Contiene: Scaffold homepage

// INPUT: niente
// OUTPUT: se ottiene posizione SchermataDatiCompleti
//         altrimenti SceltaManuale
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Posizione>(
      future: Posizione.localizza(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const SchermataDatiCaricamento(
            errore: true,
          );
        }
        if (snapshot.hasData) {
          return SchermataDatiCompleti(dataPos: snapshot.data!);
        }
        return const SchermataDatiCaricamento(
          errore: false,
        );
      },
    );
  }
}
