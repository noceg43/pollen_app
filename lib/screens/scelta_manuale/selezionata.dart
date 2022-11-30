import 'package:demo_1/providers/position.dart';
import 'package:demo_1/screens/homepage/scheletro_dati_completi.dart';
import 'package:flutter/material.dart';

// Contiene: Scaffold stazione selezionata

// INPUT: posizione con lat lon e nome di una stazione
// OUTPUT: se ottiene posizione SchermataDatiCompleti
//         altrimenti errore e consigliare di cercare manualmente

class Selezionata extends StatefulWidget {
  const Selezionata({super.key, required this.dataPos});
  final Posizione dataPos;
  // funzione che ritarda l'ottenimento istantaneo della posizione da una stazione
  Future<Posizione> ottieni() async {
    await Future.delayed(const Duration(microseconds: 50));
    return dataPos;
  }

  @override
  State<Selezionata> createState() => _SelezionataState();
}

class _SelezionataState extends State<Selezionata> {
  late Future<Posizione> posizione;
  @override
  void initState() {
    super.initState();
    posizione = widget.ottieni();
  }

  void update() {
    setState(() {
      posizione = widget.ottieni();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Posizione>(
      future: posizione,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const SchermataDatiCaricamento(errore: false);
          case ConnectionState.done:
          default:
            if (snapshot.hasError) {
              return const SchermataDatiCaricamento(
                errore: true,
              );
            } else if (snapshot.hasData) {
              return SchermataDatiCompleti(
                dataPos: snapshot.data!,
                update: update,
                homepage: false,
              );
            } else {
              return const SchermataDatiCaricamento(errore: false);
            }
        }
      },
    );
  }
}
