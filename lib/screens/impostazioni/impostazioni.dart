import 'package:app_settings/app_settings.dart';
import 'package:demo_1/providers/preferences.dart';
import 'package:flutter/material.dart';

class SchermataImpostazioni extends StatefulWidget {
  const SchermataImpostazioni({super.key});

  @override
  State<SchermataImpostazioni> createState() => _SchermataImpostazioniState();
}

class _SchermataImpostazioniState extends State<SchermataImpostazioni> {
  bool inq = true;
  bool part = true;
  @override
  void initState() {
    super.initState();
    getSwitchValues();
  }

  getSwitchValues() async {
    inq = await PreferencesNotificaInquinamento.ottieni();
    part = await PreferencesNotificaParticelle.ottieni();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Impostazioni"),
        leading: const BackButton(),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(40, 10, 40, 5),
            child: Text(
              "Dati personali",
              style: TextStyle(color: Colors.green.shade900, fontSize: 15),
            ),
          ),
          InkWell(
            onTap: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Attenzione'),
                  content:
                      const Text('Confermi di voler cancellare tutti i dati ?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => {Navigator.pop(context)},
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () => {Peso.elimina(), Navigator.pop(context)},
                      child: const Text('Sì, confermo'),
                    ),
                  ],
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(40, 5, 40, 5),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Cancella le interazioni con il diario",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    Text(
                      "Elimina tutti i dati inseriti nella pagina diario",
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.6), fontSize: 16),
                    ),
                  ]),
            ),
          ),
          InkWell(
            onTap: () {
              AppSettings.openLocationSettings();
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(40, 5, 40, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Reimposta permesso per posizione",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  Text(
                    "Abilitato",
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.6), fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(40, 0, 40, 5),
            child: Text(
              "Notifiche",
              style: TextStyle(color: Colors.green.shade900, fontSize: 15),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(40, 5, 20, 5),
            child: Row(
              children: [
                Flexible(
                  flex: 9,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Aumento particelle sensibili",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        Text(
                          "Massimo una volta al giorno, legate alle interazioni con il diario",
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Switch(
                  value: part,
                  onChanged: ((value) {
                    setState(() {
                      part = value;
                      PreferencesNotificaParticelle.modifica(value);
                    });
                  }),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(40, 5, 20, 5),
            child: Row(
              children: [
                Flexible(
                  flex: 9,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Qualità aria",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        Text(
                          "Cambiamenti degli agenti inquinanti nel giorno successivo",
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Switch(
                  value: inq,
                  onChanged: ((value) {
                    setState(() {
                      inq = value;
                      PreferencesNotificaInquinamento.modifica(value);
                    });
                  }),
                )
              ],
            ),
          ),
          const Divider(
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
