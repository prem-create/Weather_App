import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/services/weather_services.dart';
import 'package:weather_app/utils/get_current_location.dart';
import 'package:weather_app/weather_model/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  bool _isLoading = true;
  String? error;
  late Position position;
  late WeatherModel weatherModel;

  void initPosition() async {
    try {
      position = await getCurrentLocation();
      final WeatherApiServices apiServices = WeatherApiServices(
        lon: position.longitude,
        lat: position.latitude,
      );
      weatherModel = await apiServices.getWeather();
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        this.error = error.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    initPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : error != null
            ? Text(error!)
            : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(weatherModel.mainCondition),
                Text(weatherModel.temperature.toString()),
                Text(weatherModel.cityName),
              ],
            ),
      ),
    );
  }
}
