import 'package:demo_1/providers/position.dart';
import 'package:demo_1/utils/calcolo_tipo_maggiore.dart';
import 'package:demo_1/utils/format_dati_giornalieri.dart';
import 'package:demo_1/widgets/tipo_schermata/particella.dart';
import 'package:flutter/material.dart';

class TipoSchermata extends StatelessWidget {
  const TipoSchermata(
      {super.key,
      required this.tipologia,
      required this.s,
      required this.formTipo});
  final Tipologia
      tipologia; // Lista di particella inquinante oppure di map polline-tendenza
  final dynamic s; // posizione oppure stazione
  final FormatTipoGiornaliero formTipo;
  @override
  Widget build(BuildContext context) {
    String posizione;
    if (tipologia.nome == "Inquinamento" && s is Posizione) {
      posizione = s.pos;
    } else {
      posizione = s.statenameI;
    }
    return Scaffold(
      appBar: AppBar(
        //title: Text(p.partNameI),
        leading: const BackButton(),
      ),
      body: ListView(
        children: [
          Container(
            height: 100,
            color: Colors.green,
          ),
          Card(
            child: Column(
              children: [
                Row(
                  children: [
                    Transform.translate(
                      offset: const Offset(0.0, -25.0),
                      child: Container(
                        width: 50,
                        height: 50,
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
                              image: formTipo.img, fit: BoxFit.fill),
                        ),
                      ),
                    ),
                    Text(posizione)
                  ],
                ),
                for (Map<Particella, ValoreDelGiorno> el in tipologia.lista)
                  ItemParticellaDaTipo(
                    data: el,
                    s: s,
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
