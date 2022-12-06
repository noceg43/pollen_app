// ignore_for_file: missing_return

import 'dart:convert';
import 'dart:io';

import 'package:demo_1/providers/cache.dart';
import 'package:http/http.dart' as http;

class Meteo {
  Meteo({
    required this.latitude,
    required this.longitude,
    required this.generationtimeMs,
    required this.utcOffsetSeconds,
    required this.timezone,
    required this.timezoneAbbreviation,
    required this.elevation,
    required this.hourlyUnits,
    required this.hourly,
    required this.dailyUnits,
    required this.daily,
  });
  // https://api.open-meteo.com/v1/forecast?latitude=44.54&longitude=10.81&hourly=weathercode,temperature_2m,apparent_temperature,windspeed_10m&daily=weathercode,temperature_2m_max,temperature_2m_min,sunrise,sunset&timezone=auto
  static Future<Meteo> fetch(num lat, num lon) async {
    String urlMeteo =
        'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&hourly=weathercode,temperature_2m,apparent_temperature,windspeed_10m&daily=weathercode,temperature_2m_max,temperature_2m_min,sunrise,sunset&timezone=auto';
    final response = await http.get(Uri.parse(urlMeteo));
    /*
    var file = await GiornalieraCacheManager.instance.getSingleFile(urlMeteo);
    return Meteo.fromJson(jsonDecode(await file.readAsString()));
    */

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Meteo.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  late final num latitude;
  late final num longitude;
  late final num generationtimeMs;
  late final num utcOffsetSeconds;
  late final String timezone;
  late final String timezoneAbbreviation;
  late final num elevation;
  late final HourlyUnits hourlyUnits;
  late final Hourly hourly;
  late final DailyUnits dailyUnits;
  late final Daily daily;

  factory Meteo.fromJson(Map<String, dynamic> json) => Meteo(
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        generationtimeMs: json["generationtime_ms"].toDouble(),
        utcOffsetSeconds: json["utc_offset_seconds"],
        timezone: json["timezone"],
        timezoneAbbreviation: json["timezone_abbreviation"],
        elevation: json["elevation"],
        hourlyUnits: HourlyUnits.fromJson(json["hourly_units"]),
        hourly: Hourly.fromJson(json["hourly"]),
        dailyUnits: DailyUnits.fromJson(json["daily_units"]),
        daily: Daily.fromJson(json["daily"]),
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "generationtime_ms": generationtimeMs,
        "utc_offset_seconds": utcOffsetSeconds,
        "timezone": timezone,
        "timezone_abbreviation": timezoneAbbreviation,
        "elevation": elevation,
        "hourly_units": hourlyUnits.toJson(),
        "hourly": hourly.toJson(),
        "daily_units": dailyUnits.toJson(),
        "daily": daily.toJson(),
      };
}

class Daily {
  Daily({
    required this.time,
    required this.weathercode,
    required this.temperature2MMax,
    required this.temperature2MMin,
    required this.sunrise,
    required this.sunset,
  });

  late final List<DateTime> time;
  late final List<num> weathercode;
  late final List<num> temperature2MMax;
  late final List<num> temperature2MMin;
  late final List<String> sunrise;
  late final List<String> sunset;

  factory Daily.fromJson(Map<String, dynamic> json) => Daily(
        time: List<DateTime>.from(json["time"].map((x) => DateTime.parse(x))),
        weathercode: List<num>.from(json["weathercode"].map((x) => x)),
        temperature2MMax:
            List<num>.from(json["temperature_2m_max"].map((x) => x.toDouble())),
        temperature2MMin:
            List<num>.from(json["temperature_2m_min"].map((x) => x.toDouble())),
        sunrise: List<String>.from(json["sunrise"].map((x) => x)),
        sunset: List<String>.from(json["sunset"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "time": List<dynamic>.from(time.map((x) =>
            "${x.year.toString().padLeft(4, '0')}-${x.month.toString().padLeft(2, '0')}-${x.day.toString().padLeft(2, '0')}")),
        "weathercode": List<dynamic>.from(weathercode.map((x) => x)),
        "temperature_2m_max":
            List<dynamic>.from(temperature2MMax.map((x) => x)),
        "temperature_2m_min":
            List<dynamic>.from(temperature2MMin.map((x) => x)),
        "sunrise": List<dynamic>.from(sunrise.map((x) => x)),
        "sunset": List<dynamic>.from(sunset.map((x) => x)),
      };
}

class DailyUnits {
  DailyUnits({
    required this.time,
    required this.weathercode,
    required this.temperature2MMax,
    required this.temperature2MMin,
    required this.sunrise,
    required this.sunset,
  });

  late final String time;
  late final String weathercode;
  late final String temperature2MMax;
  late final String temperature2MMin;
  late final String sunrise;
  late final String sunset;

  factory DailyUnits.fromJson(Map<String, dynamic> json) => DailyUnits(
        time: json["time"],
        weathercode: json["weathercode"],
        temperature2MMax: json["temperature_2m_max"],
        temperature2MMin: json["temperature_2m_min"],
        sunrise: json["sunrise"],
        sunset: json["sunset"],
      );

  Map<String, dynamic> toJson() => {
        "time": time,
        "weathercode": weathercode,
        "temperature_2m_max": temperature2MMax,
        "temperature_2m_min": temperature2MMin,
        "sunrise": sunrise,
        "sunset": sunset,
      };
}

class Hourly {
  Hourly({
    required this.time,
    required this.weathercode,
    required this.temperature2M,
    required this.apparentTemperature,
    required this.windspeed10M,
  });

  late final List<DateTime> time;
  late final List<num> weathercode;
  late final List<num> temperature2M;
  late final List<num> apparentTemperature;
  late final List<num> windspeed10M;
  factory Hourly.fromJson(Map<String, dynamic> json) => Hourly(
        weathercode: List<num>.from(json["weathercode"].map((x) => x)),
        temperature2M:
            List<num>.from(json["temperature_2m"].map((x) => x.toDouble())),
        apparentTemperature: List<num>.from(
            json["apparent_temperature"].map((x) => x.toDouble())),
        windspeed10M:
            List<num>.from(json["windspeed_10m"].map((x) => x.toDouble())),
        time: [for (String s in json['time'].cast<String>()) DateTime.parse(s)],
      );

  Map<String, dynamic> toJson() => {
        "time": List<dynamic>.from(time.map((x) => x)),
        "weathercode": List<dynamic>.from(weathercode.map((x) => x)),
        "temperature_2m": List<dynamic>.from(temperature2M.map((x) => x)),
        "apparent_temperature":
            List<dynamic>.from(apparentTemperature.map((x) => x)),
        "windspeed_10m": List<dynamic>.from(windspeed10M.map((x) => x)),
      };
}

class HourlyUnits {
  HourlyUnits({
    required this.time,
    required this.weathercode,
    required this.temperature2M,
    required this.apparentTemperature,
    required this.windspeed10M,
  });

  late final String time;
  late final String weathercode;
  late final String temperature2M;
  late final String apparentTemperature;
  String windspeed10M;

  factory HourlyUnits.fromJson(Map<String, dynamic> json) => HourlyUnits(
        time: json["time"],
        weathercode: json["weathercode"],
        temperature2M: json["temperature_2m"],
        apparentTemperature: json["apparent_temperature"],
        windspeed10M: json["windspeed_10m"],
      );

  Map<String, dynamic> toJson() => {
        "time": time,
        "weathercode": weathercode,
        "temperature_2m": temperature2M,
        "apparent_temperature": apparentTemperature,
        "windspeed_10m": windspeed10M,
      };
}

String numerpretazioneWeatherCode(num code) {
  switch (code) {
    case 0:
      {
        return "Soleggiato";
      }
    case 1:
      {
        return "Prevalentemente sereno";
      }
    case 2:
      {
        return "Poco nuvoloso";
      }
    case 3:
      {
        return "Nuvoloso";
      }
    case 45:
      {
        return "Nebbia";
      }
    case 48:
      {
        return "Depositi di nebbbia";
      }
    case 51:
      {
        return "Pioggerellina leggera";
      }
    case 53:
      {
        return "Pioggerellina";
      }
    case 55:
      {
        return "Pioggerellina numensa";
      }
    case 56:
      {
        return "Pioggierellina leggera e gelo";
      }
    case 57:
      {
        return "Pioggerellina numensa e gelo";
      }
    case 61:
      {
        return "Pioggia leggera";
      }
    case 63:
      {
        return "Pioggia";
      }
    case 65:
      {
        return "Pioggia numensa";
      }
    case 66:
      {
        return "Pioggia leggera e gelo";
      }
    case 67:
      {
        return "Pioggia numensa e gelo";
      }
    case 71:
      {
        return "Nevicata leggera";
      }
    case 73:
      {
        return "Nevicata";
      }
    case 75:
      {
        return "Nevicata numensa";
      }
    case 77:
      {
        return "Granelli di neve";
      }
    case 80:
      {
        return "Rovesci lievi";
      }
    case 81:
      {
        return "Rovesci";
      }
    case 82:
      {
        return "Rovesci numensi";
      }
    case 85:
      {
        return "Rovesci di neve lievi";
      }
    case 86:
      {
        return "Rovesci di neve abbondanti";
      }
    case 95:
      {
        return "Temporale";
      }
    case 96:
      {
        return "Temporale con leggera grandine";
      }
    case 99:
      {
        return "Temporale con pesante grandine";
      }
    default:
      {
        return '';
      }
  }
/*
  0	Clear sky
1, 2, 3	Mainly clear, partly cloudy, and overcast
45, 48	Fog and depositing rime fog
51, 53, 55	Drizzle: Light, moderate, and dense numensity
56, 57	Freezing Drizzle: Light and dense numensity
61, 63, 65	Rain: Slight, moderate and heavy numensity
66, 67	Freezing Rain: Light and heavy numensity
71, 73, 75	Snow fall: Slight, moderate, and heavy numensity
77	Snow grains
80, 81, 82	Rain showers: Slight, moderate, and violent
85, 86	Snow showers slight and heavy
95 *	Thunderstorm: Slight or moderate
96, 99 *	Thunderstorm with slight and heavy hail
*/
}

void main() async {
  num latMo = 44.645958;
  num lonMo = 10.925529;
  Meteo m = await Meteo.fetch(latMo, lonMo);
  //print([for (num n in m.daily.weathercode) numerpretazioneWeatherCode(n)]);
  var out = File('meteo.txt').openWrite();
  for (int i = 0; i < m.daily.time.length; i++) {
    out.write(
        "${m.daily.time[i].day}/${m.daily.time[i].month}/${m.daily.time[i].year}");
    out.write(" ");
    out.write(numerpretazioneWeatherCode(m.daily.weathercode[i]));
    out.write("\n");
    out.write("Alba: ");
    out.write(m.daily.sunrise[i]);
    out.write("   Tramonto: ");
    out.write(m.daily.sunset[i]);
    out.write("\n");
    out.write("Min: ");
    out.write(m.daily.temperature2MMin[i]);
    out.write("   Max: ");
    out.write(m.daily.temperature2MMax[i]);
    out.write("\n");
    out.write("## PREVISIONI ORARIE ##\n");
    for (int o = (24 * (i)); o < (24 * (i + 1)); o++) {
      out.write("${m.hourly.time[o].hour}:00");
      out.write("   ");
      out.write(numerpretazioneWeatherCode(m.hourly.weathercode[o]));
      out.write("   Temperatura: ");
      out.write(m.hourly.temperature2M[o]);
      out.write("   Temperatura percepita: ");
      out.write(m.hourly.apparentTemperature[o]);
      out.write("\n");
    }
    out.write("\n");
  }

  out.close();
}
