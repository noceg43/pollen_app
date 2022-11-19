import 'package:demo_1/utils/format_polline.dart';
import 'package:flutter/material.dart';

// Contiene SizedBox 250x50

// INPUT: FormatPolline del giorno richiesto
// OUTPUT: SizedBox con dati rappresentati nel modo corretto
class ItemPolline extends StatelessWidget {
  const ItemPolline({super.key, required this.p});
  final FormatPolline p;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 50,
      child: Card(
        elevation: 10,
        color: p.valoreColore,
        child: Row(
          children: [
            const Spacer(
              flex: 1,
            ),
            Text(
              "${p.nome} ${p.valore}",
            ),
            const Spacer(
              flex: 1,
            ),
            Icon(
              p.icona,
              size: 25,
            )
          ],
        ),
      ),
    );
  }
}
