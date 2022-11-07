// ignore_for_file: missing_return

import 'dart:convert';
import 'dart:io';

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
  late final double latitude;
  late final double longitude;
  late final double generationtimeMs;
  late final num utcOffsetSeconds;
  late final String timezone;
  late final String timezoneAbbreviation;
  late final num elevation;
  late final HourlyUnits hourlyUnits;
  late final Hourly hourly;
  late final DailyUnits dailyUnits;
  late final Daily daily;

  Meteo.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    generationtimeMs = json['generationtime_ms'];
    utcOffsetSeconds = json['utc_offset_seconds'];
    timezone = json['timezone'];
    timezoneAbbreviation = json['timezone_abbreviation'];
    elevation = json['elevation'];
    hourlyUnits = HourlyUnits.fromJson(json['hourly_units']);
    hourly = Hourly.fromJson(json['hourly']);
    dailyUnits = DailyUnits.fromJson(json['daily_units']);
    daily = Daily.fromJson(json['daily']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    _data['generationtime_ms'] = generationtimeMs;
    _data['utc_offset_seconds'] = utcOffsetSeconds;
    _data['timezone'] = timezone;
    _data['timezone_abbreviation'] = timezoneAbbreviation;
    _data['elevation'] = elevation;
    _data['hourly_units'] = hourlyUnits.toJson();
    _data['hourly'] = hourly.toJson();
    _data['daily_units'] = dailyUnits.toJson();
    _data['daily'] = daily.toJson();
    return _data;
  }
}

class HourlyUnits {
  HourlyUnits({
    required this.time,
    required this.temperature_2m,
    required this.apparentTemperature,
    required this.weathercode,
  });
  late final String time;
  late final String temperature_2m;
  late final String apparentTemperature;
  late final String weathercode;

  HourlyUnits.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    temperature_2m = json['temperature_2m'];
    apparentTemperature = json['apparent_temperature'];
    weathercode = json['weathercode'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['time'] = time;
    _data['temperature_2m'] = temperature_2m;
    _data['apparent_temperature'] = apparentTemperature;
    _data['weathercode'] = weathercode;
    return _data;
  }
}

class Hourly {
  Hourly({
    required this.time,
    required this.temperature_2m,
    required this.apparentTemperature,
    required this.weathercode,
  });
  late final List<DateTime> time;
  late final List<num> temperature_2m;
  late final List<num> apparentTemperature;
  late final List<num> weathercode;

  Hourly.fromJson(Map<String, dynamic> json) {
    List<String> stringTime = json['time'].cast<String>();
    time = [for (String s in stringTime) DateTime.parse(s)];
    temperature_2m = List.castFrom<dynamic, num>(json['temperature_2m']);
    apparentTemperature =
        List.castFrom<dynamic, num>(json['apparent_temperature']);
    weathercode = List.castFrom<dynamic, num>(json['weathercode']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['time'] = time;
    _data['temperature_2m'] = temperature_2m;
    _data['apparent_temperature'] = apparentTemperature;
    _data['weathercode'] = weathercode;
    return _data;
  }
}

class DailyUnits {
  DailyUnits({
    required this.time,
    required this.weathercode,
    required this.temperature_2mMax,
    required this.temperature_2mMin,
    required this.sunrise,
    required this.sunset,
  });
  late final String time;
  late final String weathercode;
  late final String temperature_2mMax;
  late final String temperature_2mMin;
  late final String sunrise;
  late final String sunset;

  DailyUnits.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    weathercode = json['weathercode'];
    temperature_2mMax = json['temperature_2m_max'];
    temperature_2mMin = json['temperature_2m_min'];
    sunrise = json['sunrise'];
    sunset = json['sunset'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['time'] = time;
    _data['weathercode'] = weathercode;
    _data['temperature_2m_max'] = temperature_2mMax;
    _data['temperature_2m_min'] = temperature_2mMin;
    _data['sunrise'] = sunrise;
    _data['sunset'] = sunset;
    return _data;
  }
}

class Daily {
  Daily({
    required this.time,
    required this.weathercode,
    required this.temperature_2mMax,
    required this.temperature_2mMin,
    required this.sunrise,
    required this.sunset,
  });
  late final List<DateTime> time;
  late final List<num> weathercode;
  late final List<double> temperature_2mMax;
  late final List<num> temperature_2mMin;
  late final List<String> sunrise;
  late final List<String> sunset;

  Daily.fromJson(Map<String, dynamic> json) {
    List<String> stringTime = List.castFrom<dynamic, String>(json['time']);
    time = [for (String s in stringTime) DateTime.parse(s)];
    weathercode = List.castFrom<dynamic, num>(json['weathercode']);
    temperature_2mMax =
        List.castFrom<dynamic, double>(json['temperature_2m_max']);
    temperature_2mMin = List.castFrom<dynamic, num>(json['temperature_2m_min']);
    sunrise = List.castFrom<dynamic, String>(json['sunrise']);
    sunset = List.castFrom<dynamic, String>(json['sunset']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['time'] = time;
    _data['weathercode'] = weathercode;
    _data['temperature_2m_max'] = temperature_2mMax;
    _data['temperature_2m_min'] = temperature_2mMin;
    _data['sunrise'] = sunrise;
    _data['sunset'] = sunset;
    return _data;
  }
}

String numerpretazioneWeatherCode(num code) {
  switch (code) {
    case 0:
      {
        return "Soleggiato";
      }
      break;
    case 1:
      {
        return "Prevalentemente sereno";
      }
      break;
    case 2:
      {
        return "Poco nuvoloso";
      }
      break;
    case 3:
      {
        return "Nuvoloso";
      }
      break;
    case 45:
      {
        return "Nebbia";
      }
      break;
    case 48:
      {
        return "Depositi di nebbbia";
      }
      break;
    case 51:
      {
        return "Pioggerellina leggera";
      }
      break;
    case 53:
      {
        return "Pioggerellina";
      }
      break;
    case 55:
      {
        return "Pioggerellina numensa";
      }
      break;
    case 56:
      {
        return "Pioggierellina leggera e gelo";
      }
      break;
    case 57:
      {
        return "Pioggerellina numensa e gelo";
      }
      break;
    case 61:
      {
        return "Pioggia leggera";
      }
      break;
    case 63:
      {
        return "Pioggia";
      }
      break;
    case 65:
      {
        return "Pioggia numensa";
      }
      break;
    case 66:
      {
        return "Pioggia leggera e gelo";
      }
      break;
    case 67:
      {
        return "Pioggia numensa e gelo";
      }
      break;
    case 71:
      {
        return "Nevicata leggera";
      }
      break;
    case 73:
      {
        return "Nevicata";
      }
      break;
    case 75:
      {
        return "Nevicata numensa";
      }
      break;
    case 77:
      {
        return "Granelli di neve";
      }
      break;
    case 80:
      {
        return "Rovesci lievi";
      }
      break;
    case 81:
      {
        return "Rovesci";
      }
      break;
    case 82:
      {
        return "Rovesci numensi";
      }
      break;
    case 85:
      {
        return "Rovesci di neve lievi";
      }
      break;
    case 86:
      {
        return "Rovesci di neve abbondanti";
      }
      break;
    case 95:
      {
        return "Temporale";
      }
      break;
    case 96:
      {
        return "Temporale con leggera grandine";
      }
      break;
    case 99:
      {
        return "Temporale con pesante grandine";
      }
      break;
    default:
      {
        return '';
      }
      break;
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

Future<Meteo> fetchMeteo(num lat, num lon) async {
  final response = await http.get(Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&hourly=temperature_2m,apparent_temperature,weathercode&daily=weathercode,temperature_2m_max,temperature_2m_min,sunrise,sunset&timezone=auto'));

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

void main() async {
  num latMo = 44.645958;
  num lonMo = 10.925529;
  Meteo m = await fetchMeteo(latMo, lonMo);
  print([for (num n in m.daily.weathercode) numerpretazioneWeatherCode(n)]);
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
    out.write(m.daily.temperature_2mMin[i]);
    out.write("   Max: ");
    out.write(m.daily.temperature_2mMax[i]);
    out.write("\n");
    out.write("## PREVISIONI ORARIE ##\n");
    for (int o = (24 * (i)); o < (24 * (i + 1)); o++) {
      out.write("${m.hourly.time[o].hour}:00");
      out.write("   ");
      out.write(numerpretazioneWeatherCode(m.hourly.weathercode[o]));
      out.write("   Temperatura: ");
      out.write(m.hourly.temperature_2m[o]);
      out.write("   Temperatura percepita: ");
      out.write(m.hourly.apparentTemperature[o]);
      out.write("\n");
    }
    out.write("\n");
  }

  out.close();
}
