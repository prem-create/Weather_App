import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/weather_model/weather_model.dart';

class WeatherApiServices {
  final double lon;
  final double lat;
  final apiKey="Your_Api_Key";

  WeatherApiServices({required this.lon, required this.lat});

  Future<WeatherModel> getWeather() async {
    final response = await http.get(
      Uri.https("api.openweathermap.org", "/data/2.5/weather", {
        "lon": lon.toString(),
        "lat": lat.toString(),
        "appid": apiKey,
      }),
    );
    try {
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return WeatherModel.fromJson(result);
      } else {
        throw Exception("Error occured, StatusCode: ${response.body}");
      }
    } catch (e) {
      throw ("error:$e");
    }
  }
}
