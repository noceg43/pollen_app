// ignore_for_file: missing_return

import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

class Inquinamento {
  late final double latitude;
  late final double longitude;
  late final double generationtimeMs;
  late final int utcOffsetSeconds;
  late final String timezone;
  late final String timezoneAbbreviation;
  late final HourlyUnits hourlyUnits;
  late final Hourly hourly;
  static Future<Inquinamento> fetch(num lat, num lon) async {
    final response = await http.get(Uri.parse(
        'https://air-quality-api.open-meteo.com/v1/air-quality?latitude=$lat&longitude=$lon&hourly=pm10,pm2_5,carbon_monoxide,nitrogen_dioxide,sulphur_dioxide,ozone'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Inquinamento.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
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
        "CO",
        hourly.carbonMonoxide.sublist(24 * (day), 24 * (day + 1)).reduce(max),
        4000));
    ret.add(ParticellaInquinante(
        "SO2",
        hourly.sulphurDioxide.sublist(24 * (day), 24 * (day + 1)).reduce(max),
        40));
    ret.add(ParticellaInquinante(
        "NO2",
        hourly.nitrogenDioxide.sublist(24 * (day), 24 * (day + 1)).reduce(max),
        25));
    ret.add(ParticellaInquinante("O3",
        hourly.ozone.sublist(24 * (day), 24 * (day + 1)).reduce(max), 100));
    ret.add(ParticellaInquinante("PM10",
        hourly.pm10.sublist(24 * (day), 24 * (day + 1)).reduce(max), 45));
    ret.add(ParticellaInquinante("PM25",
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
