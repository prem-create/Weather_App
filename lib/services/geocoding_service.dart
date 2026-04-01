import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:weather_app/constants/constants.dart';
import 'package:weather_app/model/geocoding_model.dart';

class GeocodingService {
  Future<List<GeocodingModel>> getSuggestion(String query) async {
    try {
      log("sending request");
      final response = await http.get(
        Uri.https("api.openweathermap.org", "/geo/1.0/direct", {
          "q": query,
          "appid": apiKey,
          "limit": "5",
        }),
      );

      if (response.statusCode == 200) {
        final List result = jsonDecode(response.body);
        return result.map((e) => GeocodingModel.fromJson(e)).toList();
      } else {
        throw (Exception("error: ${response.statusCode}"));
      }
    } catch (error) {
      throw (Exception("failed to get suggestions: $error"));
    }
  }
}
