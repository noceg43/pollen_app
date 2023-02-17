import 'package:demo_1/screens/impostazioni/impostazioni.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test Schermata Impostazioni', () {
    testWidgets('Verifica titolo della pagina', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SchermataImpostazioni(),
        ),
      );
      expect(find.text('Impostazioni'), findsOneWidget);
    });
    testWidgets(
        'Verifica switch notifiche particelle inizialmente impostato su true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SchermataImpostazioni(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(Switch), findsNWidgets(2));
      final switchParticelle = tester.widget<Switch>(find.byType(Switch).first);
      expect(switchParticelle.value, true);
    });

    testWidgets('Verifica cambio stato switch notifiche particelle',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SchermataImpostazioni(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(Switch), findsNWidgets(2));
      final switchParticelle = find.byType(Switch).first;
      expect(tester.widget<Switch>(switchParticelle).value, true);
      await tester.tap(switchParticelle);
      await tester.pumpAndSettle();
      expect(tester.widget<Switch>(switchParticelle).value, false);
      await tester.tap(switchParticelle);
      await tester.pumpAndSettle();
      expect(tester.widget<Switch>(switchParticelle).value, true);
    });

    testWidgets('Verifica alert dialog cancellazione dati personali',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SchermataImpostazioni(),
        ),
      );
      expect(
          find.text('Cancella le interazioni con il diario'), findsOneWidget);
      await tester.tap(find.text('Cancella le interazioni con il diario'));
      await tester.pumpAndSettle();
      expect(find.text('Attenzione'), findsOneWidget);
      expect(find.text('Confermi di voler cancellare tutti i dati ?'),
          findsOneWidget);
      expect(find.text('No'), findsOneWidget);
      expect(find.text('Sì, confermo'), findsOneWidget);
    });

    testWidgets('Verifica stato permesso posizione',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SchermataImpostazioni(),
        ),
      );
      expect(find.text('Reimposta permesso per posizione'), findsOneWidget);
    });
  });
}
