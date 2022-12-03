// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:math';

import 'package:demo_1/providers/position.dart';
import 'package:demo_1/utils/calcolo_tipo_maggiore.dart';
import 'package:http/http.dart' as http;

// TOGLIERE NEL FETCH LAT E LON, SOSTITUIRE CON POSIZIONE
class PerInquinamento {
  late final double latitude;
  late final double longitude;
  late final double generationtimeMs;
  late final int utcOffsetSeconds;
  late final String timezone;
  late final String timezoneAbbreviation;
  late final HourlyUnits hourlyUnits;
  late final Hourly hourly;
  static Future<Map<DateTime, num>> fetch(
      Posizione p, Particella particella) async {
    final response = await http.get(Uri.parse(
        'https://air-quality-api.open-meteo.com/v1/air-quality?latitude=${p.lat}&longitude=${p.lon}&hourly=${particella.nome}'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      PerInquinamento p =
          PerInquinamento.fromJson(jsonDecode(response.body), particella.nome);

      return {
        for (int day = 0; day < (24 * 5); day = day + 24)
          DateTime.parse(p.hourly.time[day]):
              p.hourly.part.sublist(day, day + 24).reduce(max)
      };
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  PerInquinamento(
      {required this.latitude,
      required this.longitude,
      required this.generationtimeMs,
      required this.utcOffsetSeconds,
      required this.timezone,
      required this.timezoneAbbreviation,
      required this.hourlyUnits,
      required this.hourly});

  PerInquinamento.fromJson(Map<String, dynamic> json, String part) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    generationtimeMs = json['generationtime_ms'];
    utcOffsetSeconds = json['utc_offset_seconds'];
    timezone = json['timezone'];
    timezoneAbbreviation = json['timezone_abbreviation'];
    hourlyUnits = (json['hourly_units'] != null
        ? HourlyUnits.fromJson(json['hourly_units'], part)
        : null)!;
    hourly = (json['hourly'] != null
        ? Hourly.fromJson(json['hourly'], part)
        : null)!;
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
}

class HourlyUnits {
  late final String time;
  late final String part;

  HourlyUnits({required this.time, required this.part});

  HourlyUnits.fromJson(Map<String, dynamic> json, String part) {
    time = json['time'];
    this.part = json[part];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    data['part'] = part;
    return data;
  }
}

class Hourly {
  late final List<String> time;
  late final List<int> part;

  Hourly({required this.time, required this.part});

  Hourly.fromJson(Map<String, dynamic> json, String part) {
    time = json['time'].cast<String>();
    this.part = json[part].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    data['part'] = part;
    return data;
  }
}

void main(List<String> args) async {
  num latMo = 44.645958;
  // ignore: unused_local_variable
  num lonMo = 10.925529;
  Map<DateTime, num> p = await PerInquinamento.fetch(
      Posizione(latMo, lonMo, "Modena"),
      Particella("pm10", [10], "Inquinamento"));
  print(p);
}
