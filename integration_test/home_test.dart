import 'dart:convert';

import 'package:demo_1/screens/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:json_theme/json_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // solito gruppo di test
  group('Testing App Performance Tests', () {
    // controlla che sia iniziato l'integration test
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    // settare il frame policy su fully live meglio per il test di animazioni pesanti
    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
    SharedPreferences.setMockInitialValues({
      'dario': [
        DateTime.now().subtract(const Duration(days: 1)).month.toString(),
        DateTime.now().subtract(const Duration(days: 1)).day.toString()
      ]
    });
    // primo test di scrolling
    testWidgets('Test cambio schermate', (tester) async {
      // ottenere il tema
      final themeStr =
          await rootBundle.loadString("assets/theme/appainter_theme.json");
      final themeJson = jsonDecode(themeStr);
      final theme = ThemeDecoder.decodeThemeData(themeJson)!;

      // renderizza l'app da testare
      await tester.pumpWidget(MyApp(
        primaVolta: false,
        theme: theme,
      ));
      // aspetta fine caricamento
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // trova il bottoneSearch
      final searchButtonFinder = find.byIcon(Icons.search);
      await tester.tap(searchButtonFinder);

      // trova la listview
      final listFinder = find.byType(ListView).first;

      // watch performance salva i record delle azioni fatte
      await binding.watchPerformance(() async {
        // simula una gesture che parte dal centro dello schermo + offset con velocità 1000
        await tester.fling(
          listFinder,
          const Offset(0, -500),
          10000,
        );
        await tester.pumpAndSettle(const Duration(seconds: 1));
      }, reportKey: 'scrolling_summary');

      // trova il bottoneBack
      final backButtonFinder = find.byTooltip('Back');
      await tester.tap(backButtonFinder);

      await tester.pumpAndSettle();

      // trova il bottoneSettings
      final settingsButtonFinder = find.byIcon(Icons.settings);
      await tester.tap(settingsButtonFinder);

      await tester.pumpAndSettle();

      // trova il bottoneBack
      final backButtonSettingsFinder = find.byTooltip('Back');
      await tester.tap(backButtonSettingsFinder);

      await tester.pumpAndSettle();

      // trova il bottoneDiario
      final diarioButtonFinder = find.byTooltip('Diario');
      await tester.tap(diarioButtonFinder);

      await tester.pumpAndSettle();

      // trova il bottoneBack
      final backButtonDiarioFinder = find.byTooltip('Back');
      await tester.tap(backButtonDiarioFinder);
    });

    testWidgets('Visualizzazione diario', (tester) async {
      // ottenere il tema
      final themeStr =
          await rootBundle.loadString("assets/theme/appainter_theme.json");
      final themeJson = jsonDecode(themeStr);
      final theme = ThemeDecoder.decodeThemeData(themeJson)!;

      // renderizza l'app da testare
      await tester.pumpWidget(MyApp(
        primaVolta: false,
        theme: theme,
      ));
      // aspetta fine caricamento
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // check esistenza e tap bottoneDiario
      final diarioButtonFinder = find.byTooltip('Diario');
      await tester.tap(diarioButtonFinder);

      await tester.pumpAndSettle();

      // trovare e tap su compilazione diario
      final compilazioneFinder = find.byIcon(Icons.check);
      await tester.tap(compilazioneFinder);

      await tester.pumpAndSettle(const Duration(seconds: 1));

      // check non esistenza bottoneDiario
      expect(find.byTooltip("Diario"), findsNothing);

      // check su SharedPreferences
      SharedPreferences pref = await SharedPreferences.getInstance();

      expect(pref.getStringList('diario'),
          [DateTime.now().month.toString(), DateTime.now().day.toString()]);
    });
  });
}
