import 'package:flutter/material.dart';
import 'package:imbuelight_stair_controller_mobile_app/enums/enums.dart';

TextStyle fontStyle(Weight weight, double size, Color color) {
  if (weight == Weight.light) {
    return TextStyle(
        fontFamily: 'Comfortaa',
        fontWeight: FontWeight.w400,
        fontSize: size,
        color: color);
  } else if (weight == Weight.bold) {
    return TextStyle(
        fontFamily: 'Comfortaa',
        fontWeight: FontWeight.w700,
        fontSize: size,
        color: color);
  } else {
    return TextStyle(fontFamily: 'Comfortaa', fontSize: size, color: color);
  }
}
