import 'package:demo_1/providers/inquinamento.dart';
import 'package:demo_1/providers/polline.dart';
import 'package:demo_1/widgets/homepage/particella.dart';
import 'package:flutter/material.dart';

class ListaPolline extends StatelessWidget {
  const ListaPolline({super.key, required this.data, required this.tipo});
  final dynamic data;
  final String tipo;
  @override
  Widget build(BuildContext context) {
    // logica per determinare il tipo da restituire e lunghezza del relativo tipo
    int lunghezza = 0;
    if (data is List<ParticellaInquinante>) {
      List<ParticellaInquinante> data = this.data;
      lunghezza = data.length;
    } else {
      Map<Polline, Tendenza> data = this.data;
      lunghezza = data.length;
    }
    // logica per determinare il tipo da restituire all'item polline
    ItemParticella getItemParticella(int index) {
      if (data is List<ParticellaInquinante>) {
        List<ParticellaInquinante> data = this.data;
        return ItemParticella(data: data.elementAt(index));
      } else {
        Map<Polline, Tendenza> data = this.data;
        return ItemParticella(
            data: {data.keys.elementAt(index): data.values.elementAt(index)});
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
                      image:
                          AssetImage('assets/images/${tipo.toLowerCase()}.png'),
                      fit: BoxFit.fill),
                ),
              ),
              Text(tipo),
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
            child: lunghezza == 0 // controllo se ci sono dati da mostrare
                // se non ce ne sono
                ? const Text("Nessun dato rilevato")
                // se ci sono
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: lunghezza,
                    itemBuilder: (context, i) {
                      return getItemParticella(i);
                    }),
          )
        ],
      ),
    );
  }
}
