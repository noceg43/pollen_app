import 'package:demo_1/providers/inquinamento.dart';
import 'package:demo_1/providers/polline.dart';
import 'package:demo_1/providers/position.dart';
import 'package:demo_1/utils/calcolo_tipo_maggiore.dart';
import 'package:demo_1/utils/format_dati_giornalieri.dart';
import 'package:demo_1/widgets/homepage/particella.dart';
import 'package:flutter/material.dart';

// INPUT: Map<String, dynamic> insieme di particelle del tipo
// OUTPUT: Container decorato con listview riempita da ItemParticella
class ListaParticella extends StatelessWidget {
  const ListaParticella(
      {super.key, required this.data, required this.s, required this.p});
  final Map<String, dynamic> data;
  final Stazione s;
  final Posizione p;
  @override
  Widget build(BuildContext context) {
    // ottengo la lunghezza della Map(se è polline) o List( se è inq) del campo value
    int lungh = lunghezza(data.values.first);
    // formatto la Map ottentendo i dati da mostrare
    FormatTipoGiornaliero formTipo = FormatTipoGiornaliero(data);
    //
    // PARTE DI LOGICA DENTRO UN WIDGET
    //
    // logica per restituire in modo ordinato
    // la corretta particella/polline in base all'indice
    ItemParticella getItemParticella(int index) {
      if (data.values.first is List<ParticellaInquinante>) {
        List<ParticellaInquinante> lista = data.values.first;
        // ordinamento inquinamento
        lista.sort(
          (a, b) {
            return (b.superato ? 1 : 0).compareTo(a.superato ? 1 : 0);
          },
        );
        return ItemParticella(
          data: lista.elementAt(index),
          s: p,
        );
      } else {
        Map<Polline, Tendenza> map = data.values.first;
        List<Map<Polline, Tendenza>> lista = [
          for (int i = 0; i < map.length; i++)
            {map.keys.elementAt(i): map.values.elementAt(i)}
        ];
        // ordinamento polline
        lista.sort(
          (a, b) {
            return b.values.first.gruppoValore
                .compareTo(a.values.first.gruppoValore);
          },
        );
        return ItemParticella(
          data: lista.elementAt(index),
          s: s,
        );
      }
    }

    return Container(
      height: 200,
      padding: const EdgeInsets.all(3.0),
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
              Text(formTipo.tipo),
              const Spacer(),
              const IconButton(
                iconSize: 30,
                icon: Icon(
                  Icons.navigate_next,
                ),
                onPressed: null,
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
