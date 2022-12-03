import 'dart:convert';
import 'dart:math';

import 'package:demo_1/providers/cache.dart';
import 'package:demo_1/providers/position.dart';

class Inquinamento {
  late final double latitude;
  late final double longitude;
  late final double generationtimeMs;
  late final int utcOffsetSeconds;
  late final String timezone;
  late final String timezoneAbbreviation;
  late final HourlyUnits hourlyUnits;
  late final Hourly hourly;
  static Future<Inquinamento> fetch(Posizione p) async {
    String urlInquinamento =
        'https://air-quality-api.open-meteo.com/v1/air-quality?latitude=${p.lat}&longitude=${p.lon}&hourly=pm10,pm2_5,carbon_monoxide,nitrogen_dioxide,sulphur_dioxide,ozone';
    //final response = await http.get(Uri.parse(urlInquinamento));
    var file =
        await GiornalieraCacheManager.instance.getSingleFile(urlInquinamento);

    return Inquinamento.fromJson(jsonDecode(await file.readAsString()));
    /*
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Inquinamento.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
    */
  }

  Inquinamento(
      {required this.latitude,
      required this.longitude,
      required this.generationtimeMs,
      required this.utcOffsetSeconds,
      required this.timezone,
      required this.timezoneAbbreviation,
      required this.hourlyUnits,
      required this.hourly});

  Inquinamento.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    generationtimeMs = json['generationtime_ms'];
    utcOffsetSeconds = json['utc_offset_seconds'];
    timezone = json['timezone'];
    timezoneAbbreviation = json['timezone_abbreviation'];
    hourlyUnits = (json['hourly_units'] != null
        ? HourlyUnits.fromJson(json['hourly_units'])
        : null)!;
    hourly = (json['hourly'] != null ? Hourly.fromJson(json['hourly']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['generationtime_ms'] = generationtimeMs;
    data['utc_offset_seconds'] = utcOffsetSeconds;
    data['timezone'] = timezone;
    data['timezone_abbreviation'] = timezoneAbbreviation;
    data['hourly_units'] = hourlyUnits.toJson();
    data['hourly'] = hourly.toJson();
    return data;
  }

  // metodo per ottenere in modo strutturato (ParticellaInquinante) i dati di un giorno
  List<ParticellaInquinante> giornaliero(int day) {
    List<ParticellaInquinante> ret = [];
    ret.add(ParticellaInquinante(
        "carbon_monoxide",
        hourly.carbonMonoxide.sublist(24 * (day), 24 * (day + 1)).reduce(max),
        4000));
    ret.add(ParticellaInquinante(
        "sulphur_dioxide",
        hourly.sulphurDioxide.sublist(24 * (day), 24 * (day + 1)).reduce(max),
        40));
    ret.add(ParticellaInquinante(
        "nitrogen_dioxide",
        hourly.nitrogenDioxide.sublist(24 * (day), 24 * (day + 1)).reduce(max),
        25));
    ret.add(ParticellaInquinante("ozone",
        hourly.ozone.sublist(24 * (day), 24 * (day + 1)).reduce(max), 100));
    ret.add(ParticellaInquinante("pm10",
        hourly.pm10.sublist(24 * (day), 24 * (day + 1)).reduce(max), 45));
    ret.add(ParticellaInquinante("pm2_5",
        hourly.pm25.sublist(24 * (day), 24 * (day + 1)).reduce(max), 15));

    return ret;
  }
}

class ParticellaInquinante {
  String tipo = "";
  int val;
  int lim;
  bool superato = false;
  ParticellaInquinante(this.tipo, this.val, this.lim) {
    superato = (val >= lim);
  }
  @override
  String toString() {
    return tipo;
  }
}

class HourlyUnits {
  late final String time;
  late final String pm10;
  late final String pm25;
  late final String carbonMonoxide;
  late final String nitrogenDioxide;
  late final String sulphurDioxide;
  late final String ozone;

  HourlyUnits(
      {required this.time,
      required this.pm10,
      required this.pm25,
      required this.carbonMonoxide,
      required this.nitrogenDioxide,
      required this.sulphurDioxide,
      required this.ozone});

  HourlyUnits.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    pm10 = json['pm10'];
    pm25 = json['pm2_5'];
    carbonMonoxide = json['carbon_monoxide'];
    nitrogenDioxide = json['nitrogen_dioxide'];
    sulphurDioxide = json['sulphur_dioxide'];
    ozone = json['ozone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    data['pm10'] = pm10;
    data['pm2_5'] = pm25;
    data['carbon_monoxide'] = carbonMonoxide;
    data['nitrogen_dioxide'] = nitrogenDioxide;
    data['sulphur_dioxide'] = sulphurDioxide;
    data['ozone'] = ozone;
    return data;
  }
}

class Hourly {
  late final List<String> time;
  late final List<int> pm10;
  late final List<int> pm25;
  late final List<int> carbonMonoxide;
  late final List<int> nitrogenDioxide;
  late final List<int> sulphurDioxide;
  late final List<int> ozone;

  Hourly(
      {required this.time,
      required this.pm10,
      required this.pm25,
      required this.carbonMonoxide,
      required this.nitrogenDioxide,
      required this.sulphurDioxide,
      required this.ozone});

  Hourly.fromJson(Map<String, dynamic> json) {
    time = json['time'].cast<String>();
    pm10 = json['pm10'].cast<int>();
    pm25 = json['pm2_5'].cast<int>();
    carbonMonoxide = json['carbon_monoxide'].cast<int>();
    nitrogenDioxide = json['nitrogen_dioxide'].cast<int>();
    sulphurDioxide = json['sulphur_dioxide'].cast<int>();
    ozone = json['ozone'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    data['pm10'] = pm10;
    data['pm2_5'] = pm25;
    data['carbon_monoxide'] = carbonMonoxide;
    data['nitrogen_dioxide'] = nitrogenDioxide;
    data['sulphur_dioxide'] = sulphurDioxide;
    data['ozone'] = ozone;
    return data;
  }
}
