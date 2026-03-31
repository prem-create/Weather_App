import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/utils/get_current_location.dart';
import 'package:weather_app/utils/animation_picker.dart';
import 'package:weather_app/utils/loading.dart';
import 'package:weather_app/model/weather_model.dart';

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
      final WeatherApiService apiServices = WeatherApiService(
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: _isLoading
            ? Center(child: loading(size))
            : error != null
            ? Text(error!)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(animationPicker(weatherModel.mainCondition)),
                  Text(
                    weatherModel.weatherDescription,
                    style: TextStyle(
                      fontSize: 0.1 * size.width,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Temperature ♨: ${weatherModel.temperature.toString()}℃",
                    style: TextStyle(
                      fontSize: 0.05 * size.width,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "Location 🌏: ${weatherModel.cityName}, ${weatherModel.country}",
                    style: TextStyle(
                      fontSize: 0.05 * size.width,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
