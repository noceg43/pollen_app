import 'package:demo_1/providers/position.dart';
import 'package:demo_1/providers/preferences.dart';
import 'package:flutter/material.dart';

class DiarioSchermata extends StatefulWidget {
  const DiarioSchermata({super.key, required this.pos});
  final Posizione pos;
  @override
  State<DiarioSchermata> createState() => _DiarioSchermataState();
}

class _DiarioSchermataState extends State<DiarioSchermata> {
  double oraValore = 12;
  double statoFisicoValore = 0;
  Map<num, String> valoreLabel = {0: "Low 🙂", 5: "Medium 😑", 10: "High 🤧"};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text(p.partNameI),
        leading: const BackButton(),
        title: const Text("Report a symptom"),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
        child: Column(
          //padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                "How was it today ?",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "Enter the intensity of symptoms taking into consideration: ",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "•eyes\n•nose\n•lungs\n•skin",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 10),
              Container(
                decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Level of the symptoms".toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        )),
                    Slider(
                      activeColor: Colors.green.shade900,
                      inactiveColor: Colors.green.shade100,
                      value: statoFisicoValore,
                      max: 10,
                      divisions: 2,
                      label: valoreLabel[(statoFisicoValore).round()],
                      onChanged: (double value) {
                        setState(() {
                          //if (value < 1) value = 1;
                          statoFisicoValore = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ]),
            const Spacer(),
            //const SizedBox(height: 50),
            const Text(
              "How many hours did you spend outside ?",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("number of hours outdoors".toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      )),
                  Slider(
                    activeColor: Colors.green.shade900,
                    inactiveColor: Colors.green.shade100,
                    value: oraValore,
                    max: 24,
                    divisions: 24,
                    label: (oraValore).round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        if (value < 1) value = 1;
                        oraValore = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const Spacer(),
            ConstrainedBox(
              constraints:
                  const BoxConstraints.tightFor(width: 170, height: 50),
              child: ElevatedButton.icon(
                onPressed: (() {
                  // ignore: avoid_print
                  Navigator.pop(context, true);
                  Peso.aumentaMultipli(
                      widget.pos,
                      statoFisicoValore == 0 ? 1 : statoFisicoValore,
                      oraValore,
                      context);
                  DiarioDisponibile.usato();
                }),
                label: const Text("Confirm"),
                icon: const Icon(Icons.check),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
