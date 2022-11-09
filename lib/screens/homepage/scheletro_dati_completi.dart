import 'package:demo_1/providers/position.dart';
import 'package:demo_1/screens/homepage/dati_completi.dart';
import 'package:flutter/material.dart';

// Contiene: Scheletro dati completi

// INPUT: posizione
// OUTPUT: Scaffold con nome posizione e le 3 schermate giorno
class SchermataDatiCompleti extends StatelessWidget {
  const SchermataDatiCompleti({super.key, required this.dataPos});
  final Posizione dataPos;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(dataPos.pos),
          leading:
              IconButton(onPressed: () => {}, icon: const Icon(Icons.settings)),
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
        body: DatiCompleti(
          dataPos: dataPos,
        ),
      ),
    );
  }
}

class SchermataDatiCaricamento extends StatelessWidget {
  const SchermataDatiCaricamento({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading:
              IconButton(onPressed: () => {}, icon: const Icon(Icons.settings)),
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
        body: Container(),
      ),
    );
  }
}
