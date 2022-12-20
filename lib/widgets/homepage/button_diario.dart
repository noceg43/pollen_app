import 'package:demo_1/providers/position.dart';
import 'package:demo_1/providers/preferences.dart';
import 'package:demo_1/screens/diario/diario.dart';
import 'package:flutter/material.dart';

class ButtonDiario extends StatefulWidget {
  const ButtonDiario({super.key, required this.dataPos});
  final Posizione dataPos;
  @override
  State<ButtonDiario> createState() => ButtonDiarioState();
}

class ButtonDiarioState extends State<ButtonDiario> {
  bool result = false;
  _navigaDiario(BuildContext context) async {
    result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiarioSchermata(
          pos: widget.dataPos,
        ),
      ),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Peso>>(
      future: Peso.getContatore(widget.dataPos),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return FutureBuilder<bool>(
              future: DiarioDisponibile.statoUsato(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Visibility(
                    visible: (!result && !snapshot.data!),
                    child: FloatingActionButton(
                      tooltip: "Diario",
                      onPressed: (() {
                        (snapshot.hasData) ? {_navigaDiario(context)} : null;
                      }),
                      backgroundColor: Colors.green,
                      child: const Icon(Icons.menu_book),
                    ),
                  );
                } else {
                  return Container();
                }
              });
        } else {
          return Container();
        }
      },
    );
  }
}
