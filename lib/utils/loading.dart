import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/utils/animation_picker.dart';

Widget loading(Size size) {
  return CircleAvatar(
    backgroundColor: Colors.white.withValues(alpha: 0.1),
    radius: size.width * 0.12,
    child: Lottie.asset(animationPicker('loading')),
  );
}
