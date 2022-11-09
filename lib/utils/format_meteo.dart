import 'package:demo_1/providers/meteo.dart';
import 'package:demo_1/providers/position.dart';
import 'package:flutter/material.dart';

// Contiene: costruttore che restituisce tutto il necessario per costruire il widget Meteo

// INPUT: dato Meteo grezzo e giorno
// OUTPUT: Stringhe ed icone per costruire Widget Meteo
class FormatMeteo {
  String max = "";
  String min = "";
  String stringaMeteo = "";
  String temperatura = "";
  IconData iconaMeteo = Icons.cloud;
  Posizione pos;
  FormatMeteo(Meteo m, int day, this.pos) {
    final oraMeteo = DateTime.now().hour + 24 * day;
    max = m.daily.temperature_2mMax[day].toStringAsFixed(0);
    min = m.daily.temperature_2mMin[day].toStringAsFixed(0);
    String getTemperatura() {
      if (day == 0) {
        return m.hourly.apparentTemperature[oraMeteo].toStringAsFixed(1);
      } else {
        List<num> l =
            m.hourly.apparentTemperature.sublist(24 * (day), 24 * (day + 1));

        return (l.reduce((a, b) => a + b) / l.length).toStringAsFixed(1);
      }
    }

    temperatura = getTemperatura();

    String getStringaMeteo() {
      Map<num, String> mapStringaMeteo = {
        0: "Sereno",
        1: "Prevalentemente sereno",
        2: "Poco nuvoloso",
        3: "Nuvoloso",
        45: "Nebbia",
        48: "Depositi di nebbia",
        51: "Pioggerellina leggera",
        53: "Pioggerellina",
        55: "Pioggerellina intensa",
        56: "Pioggerellina leggera e gelo",
        57: "Pioggerellina intensa e gelo",
        61: "Pioggia leggera",
        63: "Pioggia",
        65: "Pioggia intensa",
        66: "Pioggia leggera e gelo",
        67: "Pioggia intensa e gelo",
        71: "Nevicata leggera",
        73: "Nevicata",
        75: "Nevicata intensa",
        77: "Granelli di neve",
        80: "Rovesci lievi",
        81: "Rovesci",
        82: "Rovesci intensi",
        85: "Rovesci di neve lievi",
        86: "Rovesci di neve abbondanti",
        95: "Temporale",
        96: "Temporale con leggera grandine",
        99: "Temporale con pesante grandine"
      };
      if (day == 0) {
        return mapStringaMeteo[m.hourly.weathercode[oraMeteo]]!;
      } else {
        return mapStringaMeteo[m.daily.weathercode[day]]!;
      }
    }

    stringaMeteo = getStringaMeteo();

    IconData getIconaMeteo() {
      final orario = DateTime.now();
      num code = m.daily.weathercode[day];

      if (day == 0) {
        code = m.hourly.weathercode[oraMeteo];
      }
      Map<int, IconData> getIconaGiorno = {
        0: Icons.sunny,
        1: Icons.sunny,
        2: Icons.cloud,
        3: Icons.cloud,
        45: Icons.water,
        48: Icons.water,
        51: Icons.water_drop,
        53: Icons.water_drop,
        55: Icons.water_drop,
        56: Icons.water_drop,
        57: Icons.water_drop,
        61: Icons.cloudy_snowing,
        63: Icons.cloudy_snowing,
        65: Icons.cloudy_snowing,
        66: Icons.water_drop,
        67: Icons.cloudy_snowing,
        71: Icons.ac_unit,
        73: Icons.ac_unit,
        75: Icons.ac_unit,
        77: Icons.ac_unit,
        80: Icons.cloudy_snowing,
        81: Icons.cloudy_snowing,
        82: Icons.cloudy_snowing,
        85: Icons.cloudy_snowing,
        86: Icons.cloudy_snowing,
        95: Icons.thunderstorm,
        96: Icons.thunderstorm,
        99: Icons.thunderstorm,
      };

      bool notte = orario.isAfter(DateTime.parse(m.daily.sunset[day]));
      if (notte && day == 0) {
        getIconaGiorno[0] = Icons.bedtime;
        getIconaGiorno[1] = Icons.bedtime;
        getIconaGiorno[2] = Icons.nights_stay;
        getIconaGiorno[3] = Icons.nights_stay;
      }
      return getIconaGiorno[code]!;
    }

    iconaMeteo = getIconaMeteo();
  }
}
