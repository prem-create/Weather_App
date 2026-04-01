import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/utils/get_current_location.dart';
import 'package:weather_app/utils/animation_picker.dart';
import 'package:weather_app/widgets/loading.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/widgets/my_alert_dialog.dart';

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
      floatingActionButton: _isLoading
          ? null
          : FloatingActionButton(
              onPressed: () async {
                final result = await showModalBottomSheet(
                  isScrollControlled: true,
                  showDragHandle: true,
                  context: context,
                  builder: (context) => MyAlertDialog(),
                );

                if (result != null) {
                  weatherModel = result;
                  setState(() {
                    _isLoading = false;
                  });
                }else{
                  setState(() {
                  _isLoading = true;
                });
                }
              },

              child: Icon(Icons.search),
            ),
      body: Center(
        child: _isLoading
            ? Center(child: loading(size))
            : error != null
            ? Text(error!)
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(animationPicker(weatherModel.mainCondition)),
                    FittedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          weatherModel.weatherDescription,
                          style: TextStyle(
                            fontSize: 0.1 * size.width,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
      ),
    );
  }
}
