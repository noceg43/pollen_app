import 'package:demo_1/utils/calcolo_tipo_maggiore.dart';
import 'package:demo_1/widgets/particella_pagina/grafo_particella.dart';
import 'package:demo_1/widgets/particella_pagina/scheda_info.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ScheletroParticella extends StatelessWidget {
  const ScheletroParticella({super.key, required this.p, required this.s});
  final Particella p;
  final dynamic s;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(p.nome[0].toUpperCase() + p.nome.substring(1)),
        leading: const BackButton(),
      ),
      body: FutureBuilder<Map<DateTime, num>>(
          future: Tipologia.daParticella(s, p),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(2),
                      child: Row(
                        children: [
                          Text(
                            "Latest data available:",
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          const Spacer(),
                          Text(
                            (p.tipo == "Pollution")
                                ? "(µg/m³)"
                                : "(granules/m³)",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ],
                      ),
                    ),
                    Grafico(
                      p: p,
                      listVal: snapshot.data!,
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: Text.rich(
                        TextSpan(
                            style: Theme.of(context).textTheme.subtitle2,
                            children: [
                              const TextSpan(text: "Data obtained from: "),
                              (p.tipo == "Pollution")
                                  ? TextSpan(
                                      children: [
                                        TextSpan(
                                            style: const TextStyle(
                                                color: Colors.blue,
                                                decoration:
                                                    TextDecoration.underline),
                                            //make link blue and underline
                                            text: "Open-Meteo.com",
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                //on tap code here, you can navigate to other page or URL
                                                var urllaunchable =
                                                    await canLaunchUrl(Uri.parse(
                                                        "https://open-meteo.com/")); //canLaunch is from url_launcher package
                                                if (urllaunchable) {
                                                  await launchUrl(Uri.parse(
                                                      "https://open-meteo.com/")); //launch is from url_launcher package to launch URL
                                                } else {
                                                  //print("URL can't be launched.");
                                                }
                                              }),
                                        const TextSpan(text: " & "),
                                        TextSpan(
                                            style: const TextStyle(
                                                color: Colors.blue,
                                                decoration:
                                                    TextDecoration.underline),
                                            //make link blue and underline
                                            text: "C.A.M.S.",
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                //on tap code here, you can navigate to other page or URL
                                                var urllaunchable =
                                                    await canLaunchUrl(Uri.parse(
                                                        "https://atmosphere.copernicus.eu/")); //canLaunch is from url_launcher package
                                                if (urllaunchable) {
                                                  await launchUrl(Uri.parse(
                                                      "https://atmosphere.copernicus.eu/")); //launch is from url_launcher package to launch URL
                                                } else {
                                                  //print("URL can't be launched.");
                                                }
                                              }),
                                      ],
                                    )
                                  : TextSpan(
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline),
                                      //make link blue and underline
                                      text: "POLLnet.it",
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          //on tap code here, you can navigate to other page or URL
                                          var urllaunchable =
                                              await canLaunchUrl(Uri.parse(
                                                  "https://www.isprambiente.gov.it/it/banche-dati/banche-dati-folder/aria/aerobiologia")); //canLaunch is from url_launcher package
                                          if (urllaunchable) {
                                            await launchUrl(Uri.parse(
                                                "https://www.isprambiente.gov.it/it/banche-dati/banche-dati-folder/aria/aerobiologia")); //launch is from url_launcher package to launch URL
                                          } else {
                                            //print("URL can't be launched.");
                                          }
                                        })
                            ]),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    SchedaInfoParticella(p: p)
                  ],
                ),
              );
            } else {
              if (snapshot.hasError) {
                return Text("errore: ${snapshot.error}");
              }
              return Container();
            }
          }),
    );
  }
}
