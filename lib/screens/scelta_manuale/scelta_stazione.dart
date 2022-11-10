import 'package:demo_1/providers/polline.dart';
import 'package:demo_1/widgets/scelta_manuale/stazione.dart';
import 'package:flutter/material.dart';

class SceltaStazione extends StatefulWidget {
  const SceltaStazione({super.key, required this.staz});
  final List<Stazione> staz;

  @override
  State<SceltaStazione> createState() => _SceltaStazioneState();
}

class _SceltaStazioneState extends State<SceltaStazione> {
  List<Stazione> stazTrovate = [];
  @override
  initState() {
    // at the beginning, all users are shown
    stazTrovate = widget.staz;
    super.initState();
  }

  void runFilter(String enteredKeyword) {
    List<Stazione> risultati = [];
    if (enteredKeyword.isEmpty) {
      risultati = widget.staz;
    } else {
      risultati = widget.staz
          .where((s) =>
              s.statenameI.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      stazTrovate = risultati;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scegli la stazione"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => runFilter(value),
            ),
            Expanded(
              child: stazTrovate.isNotEmpty
                  ? ListView.builder(
                      itemCount: stazTrovate.length,
                      itemBuilder: ((context, index) =>
                          WidgetStazione(s: stazTrovate[index])))
                  : const Text("Nessun risultato"),
            )
          ],
        ),
      ),
    );
  }
}

class SceltaStazioneCaricamento extends StatelessWidget {
  const SceltaStazioneCaricamento({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scegli la stazione"),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
