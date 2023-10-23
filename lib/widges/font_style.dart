import 'package:flutter/material.dart';
import 'package:imbuelight_stair_controller_mobile_app/enums/enums.dart';

TextStyle fontStyle(Weight weight, double size) {
  if (weight == Weight.light) {
    return TextStyle(
        fontFamily: 'Comfortaa', fontWeight: FontWeight.w400, fontSize: size);
  } else if (weight == Weight.bold) {
    return TextStyle(
        fontFamily: 'Comfortaa', fontWeight: FontWeight.w700, fontSize: size);
  } else {
    return TextStyle(fontFamily: 'Comfortaa', fontSize: size);
  }
}
