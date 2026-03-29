import 'package:geolocator/geolocator.dart';

Future<Position> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("permisson denied");
      }
      if (permission == LocationPermission.deniedForever) {
        return Future.error("permisson is denied forever");
      }
    }
    return Geolocator.getCurrentPosition();
  }