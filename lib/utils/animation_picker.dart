import 'package:weather_app/utils/animation_addresses.dart';

String animationPicker(String weather) {
  AnimationAddresses address = AnimationAddresses();
  switch (weather) {
    //clear sky
    case 'clear':
      return address.clear;

    //clouds
    case 'clouds':
      return address.clouds;

    //rain
    case "Rain":
    case "Drizzle":
    case "Thunderstorm":
      return address.rain;

    //loading animation
    case "loading":
      return address.loading;
      
    //weather conditions defined below
    default:
      return address.fog;
  }
}


//other conditions

/*
Snow
Mist
Fog
Haze
Dust
Smoke
Sand
Ash
Squall
*/