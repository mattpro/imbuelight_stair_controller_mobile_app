import 'package:flutter/material.dart';
import 'package:imbuelight_stair_controller_mobile_app/enums/enums.dart';

TextStyle fontStyle(Weight weight, double size, Color color, bool isShadow) {
  if (weight == Weight.light) {
    if (isShadow) {
      return TextStyle(
          fontFamily: 'Comfortaa',
          fontWeight: FontWeight.w400,
          fontSize: size,
          color: color,
          shadows: const [
            Shadow(
              color: Colors.black, // Choose the color of the shadow
              blurRadius: 4.0, // Adjust the blur radius for the shadow effect
              offset: Offset(1.0, 1.0),
            )
          ]);
    } else {
      return TextStyle(
        fontFamily: 'Comfortaa',
        fontWeight: FontWeight.w400,
        fontSize: size,
        color: color,
      );
    }
  } else if (weight == Weight.bold) {
    if (isShadow) {
      return TextStyle(
          fontFamily: 'Comfortaa',
          fontWeight: FontWeight.w800,
          fontSize: size,
          color: color,
          shadows: const [
            Shadow(
              color: Colors.black, // Choose the color of the shadow
              blurRadius: 4.0, // Adjust the blur radius for the shadow effect
              offset: Offset(1.0, 1.0),
            )
          ]);
    } else {
      return TextStyle(
        fontFamily: 'Comfortaa',
        fontWeight: FontWeight.w800,
        fontSize: size,
        color: color,
      );
    }
  } else {
    if (isShadow) {
      return TextStyle(
          fontFamily: 'Comfortaa',
          fontSize: size,
          color: color,
          shadows: const [
            Shadow(
              color: Colors.black, // Choose the color of the shadow
              blurRadius: 4.0, // Adjust the blur radius for the shadow effect
              offset: Offset(1.0, 1.0),
            )
          ]);
    } else {
      return TextStyle(fontFamily: 'Comfortaa', fontSize: size, color: color);
    }
  }
}
