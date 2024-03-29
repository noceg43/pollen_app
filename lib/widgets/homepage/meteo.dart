import 'package:auto_size_text/auto_size_text.dart';
import 'package:demo_1/utils/format_meteo.dart';
import 'package:flutter/material.dart';

// Contiene Container 205x100

// INPUT: FormatMeteo del giorno richiesto
// OUTPUT: Container con dati rappresentati nel modo corretto
class WidgetMeteo extends StatelessWidget {
  const WidgetMeteo({super.key, required this.m});
  final FormatMeteo m;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE8F5E9),
      height: 100,
      width: (MediaQuery.of(context).textScaleFactor > 1) ? 260 : 220,
      padding: const EdgeInsets.all(3),
      child: Row(
        children: [
          Icon(
            m.iconaMeteo,
            size: 56,
          ),
          const Spacer(),
          Column(
            children: [
              const Spacer(),
              Text(
                "${m.temperatura}°",
                style: Theme.of(context).textTheme.headline4,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Icon(Icons.wind_power),
                  Text(
                    "${m.vento}km/h",
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                ],
              ),
              const Spacer(),
            ],
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Max ${m.max}°",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                "Min ${m.min}°",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          )
        ],
      ),
    );
  }
}
