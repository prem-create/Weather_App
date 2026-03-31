class WeatherModel {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final String weatherDescription;
  final String country;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.weatherDescription,
    required this.country,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'].first['main'],
      weatherDescription: json['weather'].first["description"],
      country: json['sys']['country'],
    );
  }
}
