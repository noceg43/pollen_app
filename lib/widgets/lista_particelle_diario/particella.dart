import 'package:demo_1/providers/polline.dart';
import 'package:flutter/material.dart';

class ParticellaDiario extends StatelessWidget {
  ParticellaDiario(
      {super.key,
      required this.nome,
      required this.livello,
      required this.ore});
  final String nome;
  final String livello;
  final String ore;
  final Map<num, String> livelli = {
    1: "Basso 🙂",
    5: "Medio 😑",
    10: "Alto 🤧"
  };
  final Map<num, Color> colore = {
    1: const Color.fromARGB(255, 215, 198, 41),
    5: const Color(0xFFFBAF55),
    10: const Color(0xFFD33C3C),
  };
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Polline>>(
        future: Polline.fetch(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String tipo = "inquinamento";
            Iterable<Polline> tipi = snapshot.data!.where(
              (e) => e.partNameI == nome,
            );
            if (tipi.isNotEmpty) tipo = tipi.first.tipo;
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
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
                        image: AssetImage(
                            'assets/images/${tipo.toLowerCase()}.png'),
                        fit: BoxFit.fill),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nome,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(2, 2, 0, 1),
                        child: RichText(
                            text: TextSpan(
                                text: "Livello dei sintomi riportati: ",
                                style: Theme.of(context).textTheme.bodyMedium,
                                children: <TextSpan>[
                              TextSpan(
                                  text: "${livelli[num.parse(livello)]}",
                                  style: TextStyle(
                                      color: colore[num.parse(livello)],
                                      fontWeight: FontWeight.bold))
                            ])),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(2, 2, 0, 1),
                        child: RichText(
                            text: TextSpan(
                                text: (num.parse(ore).toInt() == 1)
                                    ? "un'ora "
                                    : "${num.parse(ore).toInt()}" " ore",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                children: <TextSpan>[
                              TextSpan(
                                  text: (num.parse(ore).toInt() == 1)
                                      ? " trascorsa all'aperto"
                                      : " trascorse all'aperto",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal))
                            ])),
                      ),
                    ],
                  ),
                )
              ],
            );
          } else {
            return Container(
              height: 50,
            );
          }
        });
  }
}
