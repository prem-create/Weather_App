class GeocodingModel {
  final String name;
  final String state;
  final String country;
  final double lat;
  final double lon;

  GeocodingModel({
    required this.name,
    required this.state,
    required this.country,
    required this.lat,
    required this.lon,
  });

  factory GeocodingModel.fromJson(Map<String, dynamic> json) {
    return GeocodingModel(
      name: json["name"]??'Location not found',
      state: json["state"]??'',
      country: json["country"]??'',
      lat: json["lat"].toDouble(),
      lon: json["lon"].toDouble(),
    );
  }
}
