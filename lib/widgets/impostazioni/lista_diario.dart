import 'package:demo_1/providers/preferences.dart';
import 'package:demo_1/screens/lista_particelle_diario/lista_particelle_diario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class DatiProtettiBiometric extends StatelessWidget {
  final LocalAuthentication localAuth = LocalAuthentication();

  DatiProtettiBiometric({super.key});

  Future<bool> _authenticate() async {
    final LocalAuthentication auth = LocalAuthentication();
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    // Esegue il test di autenticazione biometrica
    bool authenticated = false;
    try {
      authenticated = await localAuth.authenticate(
        options: AuthenticationOptions(biometricOnly: canAuthenticate),
        localizedReason: "Log in to view personal information",
      );
    } catch (e) {
      print('Error during l\'authentication: $e');
    }
    return authenticated;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        // Verifica l'autenticazione biometrica
        bool authenticated = await _authenticate();
        if (authenticated) {
          // Naviga alla nuova schermata se l'autenticazione è riuscita
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListaParticelleDiario(),
            ),
          );
        } else {
          // Mostra un messaggio di errore se l'autenticazione fallisce
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Biometric authentication has failed'),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(40, 5, 40, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "View diary interactions",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            Text(
              "Show data retrieved via diary page",
              style:
                  TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
