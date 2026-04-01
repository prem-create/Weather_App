import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather_app/model/geocoding_model.dart';
import 'package:weather_app/services/geocoding_service.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/widgets/loading.dart';

class MyAlertDialog extends StatefulWidget {
  const MyAlertDialog({super.key});

  @override
  State<MyAlertDialog> createState() => _MyAlertDialogState();
}

class _MyAlertDialogState extends State<MyAlertDialog> {
  TextEditingController queryController = TextEditingController();
  GeocodingService geocodingService = GeocodingService();
  bool isSuggestionRecieved = false;
  Timer? _debounce;

  late List<GeocodingModel> model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: "location",
                  border: OutlineInputBorder(),
                ),
                controller: queryController,
                onChanged: (query) {
                  if (query.length >= 3) {
                    // ?? false because _debouce?.isActive can be nullable so we do false when nullable
                    if (_debounce?.isActive ?? false) _debounce!.cancel();
          
                    _debounce = Timer(Duration(milliseconds: 400), () async {
                      model = await geocodingService.getSuggestion(
                        query.toLowerCase().toString(),
                      );
                      if (model.isNotEmpty) {
                        setState(() {
                          isSuggestionRecieved = true;
                        });
                      } else {
                        setState(() {
                          isSuggestionRecieved = false;
                        });
                      }
                    });
                  } else {}
                },
              ),
              isSuggestionRecieved
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: model.length,
                        itemBuilder: (context, index) {
                          GeocodingModel geocodingModel = model[index];
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ListTile(
                              title: Text(
                                '${geocodingModel.name}, ${geocodingModel.state}, ${geocodingModel.country}',
                              ),
                              onTap: () async {
                                final result = await WeatherApiService(
                                  lon: geocodingModel.lon,
                                  lat: geocodingModel.lat,
                                ).getWeather();
                                if (!context.mounted) return;
                                Navigator.pop(context, result);
                              },
                            ),
                          );
                        },
                      ),
                    )
                  : loading(MediaQuery.of(context).size),
            ],
          ),
        ),
      ),
    );
  }
}
