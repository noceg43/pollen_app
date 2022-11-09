import 'package:demo_1/providers/position.dart';
import 'package:demo_1/screens/homepage/dati_completi.dart';
import 'package:flutter/material.dart';

// Contiene: Scaffold homepage

// INPUT: niente
// OUTPUT: DatiCompleti partendo da posizione attuale
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Posizione>(
      future: Posizione.create(),
      builder: (context, snapshot) {
        // testo visualizzato nella appBar mentre carica posizione
        String title = " ";
        //cosa viene visualizzato mentre carica la posizone come body in uno scaffold
        Widget figlio = Container();
        if (snapshot.hasError) {
          //navigator verso la schermata scelta stazione manuali
        }
        if (snapshot.hasData) {
          title = snapshot.data!.pos;
          figlio = DatiCompleti(
            dataPos: snapshot.data!,
          );
        }
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: Text(title),
              leading: IconButton(
                  onPressed: () => {}, icon: const Icon(Icons.settings)),
              actions: [
                IconButton(onPressed: () => {}, icon: const Icon(Icons.search)),
              ],
              bottom: const TabBar(
                tabs: [
                  Tab(
                    text: "OGGI",
                  ),
                  Tab(
                    text: "DOMANI",
                  ),
                  Tab(
                    text: "DOPODOMANI",
                  )
                ],
              ),
            ),
            body: figlio,
          ),
        );
      },
    );
  }
}
