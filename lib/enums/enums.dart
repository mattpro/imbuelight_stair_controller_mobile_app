enum Weight { light, regular, bold }

enum AppColor {
  main(0xFF060b2a),
  main2(0xFF131f6f),
  second(0xFF00FFFF),
  third(0xFFffff00),
  fourth(0xFFff00ff),
  background(0xFF0C1657);

  final int value;
  const AppColor(this.value);
}

enum TypeOfDevice { sensor, controller }

enum TypeOfValue {
  enableDistance,
  enablelightIntesity,
  enableLedSignalization,
  distance,
  lightIntesity
}

enum TypeOfButton { ledSignalization, distance, lightIntesity }
