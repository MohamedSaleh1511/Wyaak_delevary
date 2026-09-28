import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wayaak_delivery/app/data/services/app_services.dart';
import 'package:wayaak_delivery/app/routes/app_routes.dart';

class SplashController extends GetxController {
  final AppServices _appServices = Get.find<AppServices>();

  @override
  void onInit() {
    super.onInit();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
      ),
    );
  }

  @override
  void onReady() {
    super.onReady();
    if (_appServices.isFirstTime.value) {
      Timer(const Duration(milliseconds: 2500), () {
        Get.offAllNamed(Routes.welcome);
      });
    } else {
      if (_appServices.accessToken.value.isEmpty) {
        Timer(const Duration(milliseconds: 2500), () {
          Get.offAllNamed(Routes.login);
        });
      } else {
        _appServices.setCurrentLocation().then((e) {
          Timer(const Duration(milliseconds: 2500), () {
            Get.offAllNamed(Routes.main);
          });
        });
      }
    }
  }
}
