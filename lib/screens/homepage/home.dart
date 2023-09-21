import 'package:demo_1/providers/position.dart';
import 'package:demo_1/screens/homepage/scheletro_dati_completi.dart';
import 'package:flutter/material.dart';

// Contiene: Scaffold homepage

// INPUT: niente
// OUTPUT: se ottiene posizione SchermataDatiCompleti
//         altrimenti errore e consigliare di cercare manualmente

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Posizione> posizione;
  @override
  void initState() {
    super.initState();
    posizione = Posizione.localizza();
  }

  void update() {
    setState(() {
      posizione = Posizione.localizza();
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
                homepage: true,
              );
            } else {
              return const SchermataDatiCaricamento(errore: false);
            }
        }
      },
    );
  }
}
