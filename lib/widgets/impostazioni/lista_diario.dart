import 'package:demo_1/screens/lista_particelle_diario/lista_particelle_diario.dart';
import 'package:flutter/material.dart';
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
        localizedReason:
            "Effettua l'accesso  per visualizzare i dati personali",
      );
    } catch (e) {
      print('Errore durante l\'autenticazione: $e');
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
              content: Text('L\'autenticazione biometrica è fallita'),
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
              "Visualizza le interazioni con il diario",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            Text(
              "Mostra i dati recuperati tramite la pagina diario",
              style:
                  TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
