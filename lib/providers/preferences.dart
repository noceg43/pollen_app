import 'package:shared_preferences/shared_preferences.dart';

class Peso {
  double p = 0;
  String codice = "";
  static Future<Peso> getContatore(String cod) async {
    final preferences = await SharedPreferences.getInstance();
    final virgolato = preferences.getDouble(cod) ?? 0;

    return Peso(cod, virgolato);
  }

  Peso(this.codice, this.p);
  Future<void> aumenta() async {
    final prefs = await SharedPreferences.getInstance();
    p = p + 0.3;
    await prefs.setDouble(codice, p);
    print("$codice $p");
  }
}
