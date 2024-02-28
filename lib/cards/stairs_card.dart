import 'package:flutter/material.dart';
import 'package:imbuelight_stair_controller_mobile_app/enums/enums.dart';
import 'package:imbuelight_stair_controller_mobile_app/methods/font_style.dart';

class StairsCard extends StatelessWidget {
  final int index;
  const StairsCard({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child:
          Text('$index', style: fontStyle(Weight.bold, 20, Colors.white, true)),
    );
  }
}
