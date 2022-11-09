import 'package:demo_1/utils/format_meteo.dart';
import 'package:flutter/material.dart';

// Contiene Container 300x250

// INPUT: FormatMeteo del giorno richiesto
// OUTPUT: Container con dati rappresentati nel modo corretto
class WidgetMeteo extends StatelessWidget {
  const WidgetMeteo({super.key, required this.m});
  final FormatMeteo m;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 250,
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        Row(
          children: [
            Text(
              m.pos.pos,
              style: Theme.of(context).textTheme.headline4,
            ),
            const Spacer(
              flex: 1,
            ),
            const Icon(
              Icons.location_on,
              size: 25,
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 1),
            Column(
              children: [
                Text(
                  "${m.temperatura}°",
                  style: Theme.of(context).textTheme.headline4,
                ),
                Text("Max ${m.max}°"),
                Text("Min ${m.min}°"),
              ],
            ),
            const Spacer(
              flex: 1,
            ),
            Icon(
              m.iconaMeteo,
              size: 100,
            ),
            const Spacer(flex: 1),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              m.stringaMeteo,
              style: Theme.of(context).textTheme.headline5,
            )
          ],
        ),
      ]),
    );
  }
}
