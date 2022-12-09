import 'package:demo_1/utils/calcolo_tipo_maggiore.dart';
import 'package:demo_1/widgets/particella_pagina/grafo_particella.dart';
import 'package:demo_1/widgets/particella_pagina/scheda_info.dart';
import 'package:flutter/material.dart';

class ScheletroParticella extends StatelessWidget {
  const ScheletroParticella({super.key, required this.p, required this.s});
  final Particella p;
  final dynamic s;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(p.nome),
        leading: const BackButton(),
      ),
      body: FutureBuilder<Map<DateTime, num>>(
          future: Tipologia.daParticella(s, p),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.all(2),
                    child: Row(
                      children: [
                        Text(
                          "Ultimi dati disponibili:",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        const Spacer(),
                        Text(
                          (p.tipo == "Inquinamento")
                              ? "(µg/m³)"
                              : "(granuli/m³)",
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ],
                    ),
                  ),
                  Grafico(
                    p: p,
                    listVal: snapshot.data!,
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  SchedaInfoParticella(p: p)
                ],
              );
            } else {
              if (snapshot.hasError) {
                //print(snapshot.error);
                const Text("errore");
              }
              return Container();
            }
          }),
    );
  }
}
