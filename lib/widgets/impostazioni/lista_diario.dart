import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class BiometricButton extends StatelessWidget {
  final LocalAuthentication localAuth = LocalAuthentication();

  BiometricButton({super.key});

  Future<bool> _authenticate() async {
    final LocalAuthentication auth = LocalAuthentication();
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    print(canAuthenticate);
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
    return ElevatedButton(
      onPressed: () async {
        // Verifica l'autenticazione biometrica
        bool authenticated = await _authenticate();
        if (authenticated) {
          // Naviga alla nuova schermata se l'autenticazione è riuscita
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewScreen(),
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
      child: const Text('Avvia nuova schermata'),
    );
  }
}

class NewScreen extends StatelessWidget {
  const NewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuova Schermata'),
      ),
      body: const Center(
        child: Text('Questa è la nuova schermata'),
      ),
    );
  }
}
