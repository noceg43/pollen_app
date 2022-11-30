import 'package:demo_1/providers/position.dart';
import 'package:demo_1/providers/preferences.dart';
import 'package:demo_1/screens/diario/diario.dart';
import 'package:demo_1/screens/homepage/dati_completi.dart';
import 'package:demo_1/screens/scelta_manuale/schermata_scelta_stazione.dart';
import 'package:flutter/material.dart';

// Contiene: Scheletro dati completi

// INPUT: posizione
// OUTPUT: Scaffold con nome posizione e le 3 schermate giorno
class SchermataDatiCompleti extends StatelessWidget {
  const SchermataDatiCompleti(
      {super.key,
      required this.dataPos,
      required this.update,
      required this.homepage});
  final Posizione dataPos;
  final void Function() update;
  final bool homepage;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(dataPos.pos),
          leading: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DiarioSchermata(),
                  ),
                );
              },
              icon: const Icon(Icons.settings)),
          actions: [
            IconButton(
                onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SchermataSceltaStazione(),
                        ),
                      ),
                    },
                icon: const Icon(Icons.search)),
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
          update: update,
        ),
        floatingActionButton: (homepage)
            ? FutureBuilder<List<Peso>>(
                future: Peso.getContatore(dataPos),
                builder: (context, snapshot) {
                  return FloatingActionButton(
                    onPressed: (() => (snapshot.hasData)
                        ? Peso.aumentaMultipli(snapshot.data!)
                        : null),
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.navigation),
                  );
                })
            : null,
      ),
    );
  }
}

class SchermataDatiCaricamento extends StatelessWidget {
  const SchermataDatiCaricamento({super.key, required this.errore});
  final bool errore;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading:
              IconButton(onPressed: () => {}, icon: const Icon(Icons.settings)),
          actions: [
            IconButton(
                onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SchermataSceltaStazione(),
                        ),
                      ),
                    },
                icon: const Icon(Icons.search)),
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
        body: Center(
            child: errore
                ? const Text(
                    "Seleziona manualmente la stazione da monitorare dall'icona 🔍 in alto a destra",
                    textAlign: TextAlign.center)
                : Container()),
      ),
    );
  }
}
