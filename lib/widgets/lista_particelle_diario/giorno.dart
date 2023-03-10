import 'package:demo_1/providers/preferences.dart';
import 'package:demo_1/widgets/lista_particelle_diario/particella.dart';
import 'package:flutter/material.dart';

class GiornoListaParticelle extends StatelessWidget {
  const GiornoListaParticelle({super.key, required this.giorno});
  final String giorno;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>?>(
        future: Peso.getParticelleDaGiorno(giorno),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String ore = snapshot.data![0];
            String livello = snapshot.data![1];
            return Container(
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                      Text(
                        giorno,
                        style: Theme.of(context).textTheme.headline6,
                      )
                    ] +
                    [
                      for (String s in snapshot.data!.sublist(2))
                        ParticellaDiario(nome: s, livello: livello, ore: ore)
                    ],
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
