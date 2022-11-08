import 'package:demo_1/providers/position.dart';
import 'package:demo_1/screens/homepage/dati_completi.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Posizione>(
      future: Posizione.create(),
      builder: (context, snapshot) {
        String title = " ";
        if (snapshot.hasError) {
          //navigator verso la schermata scelta stazione manuali
        }
        if (snapshot.hasData) {
          title = snapshot.data!.pos;
        }
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: Text(title),
              leading: IconButton(
                  onPressed: () => {}, icon: const Icon(Icons.settings)),
              actions: [
                IconButton(onPressed: () => {}, icon: const Icon(Icons.search)),
              ],
              bottom: const TabBar(
                tabs: [
                  Tab(
                    text: "OGGI",
                  ),
                  Tab(
                    text: "DOMANI",
                  ),
                  Tab(
                    text: "DOPODOMANI",
                  )
                ],
              ),
            ),
            body: DatiCompleti(
              data: snapshot.data!,
            ), //const MyTabBarView(),
          ),
        );
      },
    );
  }
}
