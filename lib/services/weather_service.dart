import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/model/weather_model.dart';

class WeatherApiService {
  final double lon;
  final double lat;
  final apiKey="Your api key";

  WeatherApiService({required this.lon, required this.lat});

  Future<WeatherModel> getWeather() async {
    final response = await http.get(
      Uri.https("api.openweathermap.org", "/data/2.5/weather", {
        "lon": lon.toString(),
        "lat": lat.toString(),
        "units":"metric",
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
    } catch (error) {
      throw ("error: $error");
    }
  }
}
