import 'package:demo_1/providers/inquinamento.dart';
import 'package:demo_1/providers/polline.dart';
import 'package:demo_1/utils/calcolo_tipo_maggiore.dart';
import 'package:demo_1/utils/format_dati_giornalieri.dart';
import 'package:demo_1/widgets/homepage/particella.dart';
import 'package:flutter/material.dart';

class ListaPolline extends StatelessWidget {
  const ListaPolline({super.key, required this.data});
  final Map<String, dynamic> data;
  @override
  Widget build(BuildContext context) {
    // logica per determinare il tipo da restituire e lunghezza del relativo tipo
    int lungh = lunghezza(data.values.first);
    FormatTipoGiornaliero formTipo = FormatTipoGiornaliero(data);

    // logica per determinare il tipo da restituire all'item polline
    ItemParticella getItemParticella(int index) {
      if (data.values.first is List<ParticellaInquinante>) {
        List<ParticellaInquinante> lista = data.values.first;
        return ItemParticella(data: lista.elementAt(index));
      } else {
        Map<Polline, Tendenza> map = data.values.first;
        return ItemParticella(
            data: {map.keys.elementAt(index): map.values.elementAt(index)});
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
                  image: DecorationImage(
                      image: AssetImage(
                          'assets/images/${formTipo.tipo.toLowerCase()}.png'),
                      fit: BoxFit.fill),
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
