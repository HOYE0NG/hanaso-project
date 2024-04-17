import 'package:flutter/material.dart';

class SplashController {
  SplashController(this.context, this.reRender) {
    init();
  }

  BuildContext context;
  VoidCallback reRender;

  Future<void> init() async {
    // TODO 구글로그인 전에 한번했으면 자동로그인
  }
}