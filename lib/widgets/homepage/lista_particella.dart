import 'package:demo_1/providers/polline.dart';
import 'package:demo_1/providers/position.dart';
import 'package:demo_1/screens/tipo_schermata/tipo_schermata.dart';
import 'package:demo_1/utils/calcolo_tipo_maggiore.dart';
import 'package:demo_1/utils/format_dati_giornalieri.dart';
import 'package:demo_1/widgets/homepage/particella.dart';
import 'package:flutter/material.dart';

// INPUT: Map<String, dynamic> insieme di particelle del tipo
// OUTPUT: Container decorato con listview riempita da ItemParticella
class ListaParticella extends StatelessWidget {
  const ListaParticella(
      {super.key, required this.data, required this.s, required this.p});
  final Tipologia data;
  final Stazione s;
  final Posizione p;
  @override
  Widget build(BuildContext context) {
    // ottengo la lunghezza della Map(se è polline) o List( se è inq) del campo value
    int lungh = data.lenght();
    // formatto la Map ottentendo i dati da mostrare
    FormatTipoGiornaliero formTipo = FormatTipoGiornaliero(data);
    //
    // PARTE DI LOGICA DENTRO UN WIDGET
    //
    // logica per restituire in modo ordinato
    // la corretta particella/polline in base all'indice
    ItemParticella getItemParticella(int index) {
      if (data.nome == "Inquinamento") {
        return ItemParticella(
          data: data.lista.elementAt(index),
          s: p,
        );
      } else {
        return ItemParticella(
          data: data.lista.elementAt(index),
          s: s,
        );
      }
    }

    return Container(
      height: 250,
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 10,
              ),
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
                  image: DecorationImage(image: formTipo.img, fit: BoxFit.fill),
                ),
              ),
              Container(
                width: 7,
              ),
              Text(
                formTipo.tipo,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              const Spacer(),
              IconButton(
                iconSize: 30,
                icon: const Icon(
                  Icons.navigate_next,
                ),
                onPressed:
                    (lungh == 0) // se lista vuota non permettere il click
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TipoSchermata(
                                  tipologia: data,
                                  s: (data.nome ==
                                          "Inquinamento") // se particella inquinante allora restituisci posizione
                                      ? p
                                      : s,
                                  formTipo: formTipo,
                                  localizzato: p,
                                ),
                              ),
                            );
                          },
              ),
            ],
          ),
          Expanded(
            child: lungh == 0 // controllo se ci sono dati da mostrare
                // se non ce ne sono
                ? const Text("Nessun dato rilevato")
                // se ci sono
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: lungh,
                    itemBuilder: (context, i) {
                      return getItemParticella(i);
                    }),
          )
        ],
      ),
    );
  }
}
