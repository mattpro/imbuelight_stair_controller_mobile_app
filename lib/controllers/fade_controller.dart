import 'package:get/get.dart';
import 'package:flutter/material.dart';

class FadeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final Rxn<AnimationController> _animationController =
      Rxn<AnimationController>();
  AnimationController? get animationController => _animationController.value;
  final Rxn<Animation<double>> _opacityAnimation = Rxn<Animation<double>>();
  Animation<double>? get opacityAnimation => _opacityAnimation.value;

  @override
  void onInit() {
    super.onInit();
    const duration = Duration(seconds: 2);
    _animationController.value = AnimationController(
      vsync: this,
      duration: duration,
    );
    _opacityAnimation.value = (Tween<double>(begin: 0.0, end: 1.0)
        .animate(_animationController.value!)
      ..addListener(() {
        update();
      }));
    _animationController.value?.forward();
  }

  // @override
  // void onClose() {
  //   _animationController.value?.dispose();
  //   super.onClose();
  // }
}
