import 'package:demo_1/providers/polline.dart';
import 'package:demo_1/providers/position.dart';
import 'package:demo_1/screens/homepage/scheletro_dati_completi.dart';
import 'package:flutter/material.dart';

class WidgetStazione extends StatelessWidget {
  const WidgetStazione({super.key, required this.s});
  final Stazione s;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(s.statenameI),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SchermataDatiCompleti(
                    dataPos: Posizione(s.latitude, s.longitude, s.statenameI),
                  )),
        );
      },
    );
  }
}
