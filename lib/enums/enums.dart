enum Weight { light, regular, bold }

enum AppColor {
  main(0xFF060b2a),
  main2(0xFF131f6f),
  second(0xFF00FFFF),
  third(0xFFffff00),
  fourth(0xFFff00ff),
  background(0xFF0C1657),
  white(0xFFffffff);

  final int value;
  const AppColor(this.value);
}

enum TypeOfDevice { sensor, controller }

enum TypeOfSetValue {
  enableDistance,
  enablelightIntesity,
  enableLedSignalization,
  distance,
  lightIntensity
}

enum TypeOfButton { ledSignalization, distance, lightIntensity }

enum TypeOfGetValue {
  distance,
  lightIntensity,
  thresholdDistanse,
  thresholdlightIntensity
}
