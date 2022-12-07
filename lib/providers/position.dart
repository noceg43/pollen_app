import 'package:demo_1/providers/preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class Posizione {
  String pos;
  num lat, lon;

  Posizione(this.lat, this.lon, this.pos);

  static Future<Posizione> localizza() async {
    List<dynamic> l = await _determinePosition();

    var component = Posizione(l[0], l[1], l[2]);
    UltimaPosizione.salva(component);
    return component;
  }
}

Future<List<dynamic>> _determinePosition() async {
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
  List<Placemark> placemarks =
      await placemarkFromCoordinates(p.latitude, p.longitude);
  return [p.latitude, p.longitude, placemarks[0].locality];
}
