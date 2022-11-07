import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class Posizione {
  late String pos;
  late num lat, lon;

  /// Private constructor
  Posizione(String pos, num lat, num lon);
}

Future<List<dynamic>> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  Position p = await Geolocator.getCurrentPosition();
  log(p.toString());
  List<Placemark> placemarks =
      await placemarkFromCoordinates(p.latitude, p.longitude);
  log(placemarks.toString());
  return [p.latitude, p.longitude, placemarks[0].locality!];
}
