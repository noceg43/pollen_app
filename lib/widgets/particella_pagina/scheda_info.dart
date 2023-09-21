import 'package:demo_1/utils/calcolo_tipo_maggiore.dart';
import 'package:flutter/material.dart';

class SchedaInfoParticella extends StatelessWidget {
  const SchedaInfoParticella({super.key, required this.p});
  final Particella p;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      color: const Color(0xFFF1F1F1),
      child: Column(
        children: [
          Transform.translate(
            offset: const Offset(0.0, -50.0),
            child: Container(
              width: 125,
              height: 125,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 3),
                  ),
                ],
                image: DecorationImage(
                    image:
                        AssetImage('assets/images/${p.tipo.toLowerCase()}.png'),
                    fit: BoxFit.fill),
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(0.0, -40.0),
            child: Text(
              "👷‍♂️Scheda in costruzione...",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
