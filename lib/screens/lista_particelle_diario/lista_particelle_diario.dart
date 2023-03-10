import 'package:demo_1/providers/preferences.dart';
import 'package:demo_1/widgets/lista_particelle_diario/giorno.dart';
import 'package:flutter/material.dart';

class ListaParticelleDiario extends StatefulWidget {
  const ListaParticelleDiario({super.key});

  @override
  State<ListaParticelleDiario> createState() => _ListaParticelleDiarioState();
}

class _ListaParticelleDiarioState extends State<ListaParticelleDiario> {
  bool vuoto = false;
  void _showdialog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Attenzione'),
        content: const Text('Confermi di voler cancellare tutti i dati ?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => {Navigator.pop(context)},
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => {
              setState(() {
                Peso.eliminaDatiDiario();
                vuoto = true;
              }),
              Navigator.of(context).maybePop()
            },
            child: const Text('Sì, confermo'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diario Personale'),
      ),
      body: Center(
        child: FutureBuilder<List<String>?>(
            future: Peso.getGiorni(),
            builder: (context, snapshot) {
              if (snapshot.hasData && !vuoto) {
                return ListView(
                  children: [
                    for (String s in snapshot.data!)
                      GiornoListaParticelle(
                        giorno: s,
                      ),
                    const Divider()
                  ],
                );
              } else {
                return const Text("Nessun dato presente");
              }
            }),
      ),
      floatingActionButton: FutureBuilder<List<String>?>(
          future: Peso.getGiorni(),
          builder: (context, snapshot) {
            if (snapshot.hasData && !vuoto) {
              return FloatingActionButton(
                onPressed: () {
                  _showdialog();
                },
                tooltip: "Elimina i dati personali registrati",
                backgroundColor: Colors.red,
                child: Icon(
                  Icons.delete,
                ),
              );
            } else {
              return Container();
            }
          }),
    );
  }
}
