import 'package:app_settings/app_settings.dart';
import 'package:demo_1/providers/preferences.dart';
import 'package:demo_1/screens/homepage/home.dart';
import 'package:demo_1/screens/intro/schermata_intro.dart';
import 'package:demo_1/widgets/impostazioni/lista_diario.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

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
        title: const Text("Settings"),
        leading: const BackButton(),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(40, 10, 40, 5),
            child: Text(
              "Personal Data",
              style: TextStyle(color: Colors.green.shade900, fontSize: 15),
            ),
          ),
          DatiProtettiBiometric(),
          InkWell(
            onTap: () {
              setState(() {
                AppSettings.openLocationSettings();
              });
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(40, 5, 40, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Reset location access",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  FutureBuilder<LocationPermission>(
                      future: Geolocator.checkPermission(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data == LocationPermission.always ||
                              snapshot.data == LocationPermission.whileInUse) {
                            return Text(
                              "Enabled",
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6),
                                  fontSize: 16),
                            );
                          } else {
                            return Text(
                              "Disabled",
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6),
                                  fontSize: 16),
                            );
                          }
                        } else {
                          return Container();
                        }
                      }),
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
              "Notifications",
              style: TextStyle(color: Colors.green.shade900, fontSize: 15),
            ),
          ),
          InkWell(
            onTap: (() {
              setState(() {
                part = !part;
                PreferencesNotificaParticelle.modifica(part);
              });
            }),
            child: Container(
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
                            "Regarding possible changes about particles",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          Text(
                            "Maximum once a day, related to diary interactions",
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
          ),
          InkWell(
            onTap: () {
              setState(() {
                inq = !inq;
                PreferencesNotificaInquinamento.modifica(inq);
              });
            },
            child: Container(
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
                            "Air Quality",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          Text(
                            "Changes in pollutant particles in the next day",
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
          ),
          const Divider(
            thickness: 1,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(40, 0, 40, 5),
            child: Text(
              "Help",
              style: TextStyle(color: Colors.green.shade900, fontSize: 15),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SchermataIntro(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(40, 5, 40, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Show Introduction Pages",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  Text(
                    "The initial tutorial",
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.6), fontSize: 16),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
