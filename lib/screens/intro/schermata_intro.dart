import 'package:demo_1/providers/preferences.dart';
import 'package:demo_1/screens/homepage/home.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class SchermataIntro extends StatelessWidget {
  const SchermataIntro({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: const Color(0xFFE8F5E9),
      pages: [
        PageViewModel(
          title: "Scopri cosa trasporta l'aria che ti circonda 🌍",
          body:
              "Monitora le particelle organiche e non, presenti nelle tue vicinanze",
          image: Transform.translate(
            offset: const Offset(0.0, 60.0),
            child: Image.asset("assets/images/intro1.png"),
          ),
          decoration: const PageDecoration(pageColor: Color(0xFFE8F5E9)),
        ),
        PageViewModel(
          title: "Polline🌷 e Spore Fungine🍄",
          bodyWidget: Text.rich(
            TextSpan(
              style: const TextStyle(
                fontSize: 18,
              ),
              children: [
                const TextSpan(
                  text:
                      "Previsioni e Tendenza giornaliera delle particelle grazie alla rete nazionale ",
                ),
                TextSpan(
                    style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                    //make link blue and underline
                    text: "POLLnet.it",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        //on tap code here, you can navigate to other page or URL
                        var urllaunchable = await canLaunchUrl(Uri.parse(
                            "https://www.isprambiente.gov.it/it/banche-dati/banche-dati-folder/aria/aerobiologia")); //canLaunch is from url_launcher package
                        if (urllaunchable) {
                          await launchUrl(Uri.parse(
                              "https://www.isprambiente.gov.it/it/banche-dati/banche-dati-folder/aria/aerobiologia")); //launch is from url_launcher package to launch URL
                        } else {
                          //print("URL can't be launched.");
                        }
                      })
              ],
            ),
            textAlign: TextAlign.center,
          ),
          image: Transform.translate(
            offset: const Offset(0.0, 60.0),
            child: Image.asset("assets/images/intro2.png"),
          ),
          decoration: const PageDecoration(pageColor: Color(0xFFE8F5E9)),
        ),
        PageViewModel(
          title: "Particelle Inquinanti 🏭",
          bodyWidget: Text.rich(
            TextSpan(
              style: const TextStyle(
                fontSize: 18,
              ),
              children: [
                const TextSpan(
                  text:
                      "Previsioni fino a 5 giorni disponibili grazie ai dati di ",
                ),
                TextSpan(
                    style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                    //make link blue and underline
                    text: "open-meteo.com",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        //on tap code here, you can navigate to other page or URL
                        var urllaunchable = await canLaunchUrl(Uri.parse(
                            "https://open-meteo.com/en/docs/air-quality-api")); //canLaunch is from url_launcher package
                        if (urllaunchable) {
                          await launchUrl(Uri.parse(
                              "https://open-meteo.com/en/docs/air-quality-api")); //launch is from url_launcher package to launch URL
                        } else {
                          //print("URL can't be launched.");
                        }
                      })
              ],
            ),
            textAlign: TextAlign.center,
          ),
          image: Transform.translate(
            offset: const Offset(0.0, 60.0),
            child: Image.asset("assets/images/intro3.png"),
          ),
          decoration: const PageDecoration(pageColor: Color(0xFFE8F5E9)),
        ),
        PageViewModel(
          title: "Segnala un disturbo al diario📒",
          body:
              "Compilandolo, l'app calcolerà a quali particelle si è più sensibili e ti notificherà in caso di possibili aumenti di esse",
          image: Transform.translate(
            offset: const Offset(0.0, 60.0),
            child: Image.asset("assets/images/intro4.png"),
          ),
          decoration: const PageDecoration(pageColor: Color(0xFFE8F5E9)),
        )
      ],
      showSkipButton: true,
      skip: Text(
        "Salta",
        style: TextStyle(color: Colors.green.shade900),
      ),
      next: Icon(
        Icons.keyboard_arrow_right_rounded,
        color: Colors.green.shade900,
      ),
      done: Text("Fatto",
          style: TextStyle(
              fontWeight: FontWeight.w700, color: Colors.green.shade900)),
      onDone: () {
        PrimaVolta.finitaIntro();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MyHomePage(),
          ),
        );
      },
      onSkip: () {
        PrimaVolta.finitaIntro();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MyHomePage(),
          ),
        );
      },
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: Theme.of(context).colorScheme.secondary,
        color: Colors.black26,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      ),
    );
  }
}
