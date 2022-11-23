import 'package:demo_1/utils/format_inquinamento.dart';
import 'package:flutter/material.dart';

// Contiene SizedBox 250x50

// INPUT: FormatInquinamento del giorno richiesto
// OUTPUT: SizedBox con dati rappresentati nel modo corretto
class ItemInquinamento extends StatelessWidget {
  const ItemInquinamento({super.key, required this.p});
  final FormatInquinamento p;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 50,
      child: Card(
        elevation: 10,
        child: Row(
          children: [
            const Spacer(
              flex: 1,
            ),
            Text("${p.tipo} "),
            const Spacer(
              flex: 1,
            ),
            Text(
              "${p.val}",
            ),
          ],
        ),
      ),
    );
  }
}
