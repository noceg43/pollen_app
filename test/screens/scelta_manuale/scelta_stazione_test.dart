import 'package:demo_1/providers/polline.dart';
import 'package:demo_1/screens/scelta_manuale/scelta_stazione.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Scelta stazione: ricerca testuale', (WidgetTester tester) async {
    // Define a list of stations to use in the test
    List<Stazione> stazioni = const [
      Stazione(
          latitude: 1,
          longitude: 1,
          regiId: 1,
          statId: 1,
          regiNameD: "",
          regiNameI: "",
          statCode: "",
          statNameD: "",
          statenameI: "Modena"),
      Stazione(
          latitude: 1,
          longitude: 1,
          regiId: 1,
          statId: 1,
          regiNameD: "",
          regiNameI: "",
          statCode: "",
          statNameD: "",
          statenameI: "Reggio Emilia"),
      Stazione(
          latitude: 1,
          longitude: 1,
          regiId: 1,
          statId: 1,
          regiNameD: "",
          regiNameI: "",
          statCode: "",
          statNameD: "",
          statenameI: "Bologna"),
    ];

    // Build the widget under test
    await tester.pumpWidget(
      MaterialApp(
        home: SceltaStazione(staz: stazioni),
      ),
    );

    // Verify that all stations are displayed
    expect(find.text('Bologna'), findsOneWidget);
    expect(find.text('Modena'), findsOneWidget);
    expect(find.text('Reggio Emilia'), findsOneWidget);

    // Enter "Regione 1" in the search field
    await tester.enterText(find.byType(TextField), 'Mod');
    await tester.pumpAndSettle();

    // Verify that only "Stazione 1" is displayed
    expect(find.text('Modena'), findsOneWidget);
    expect(find.text('Bologna'), findsNothing);
    expect(find.text('Reggio Emilia'), findsNothing);
  });
}
