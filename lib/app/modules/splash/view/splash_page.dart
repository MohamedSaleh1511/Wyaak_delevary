import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
// import 'package:wayaak_delivery/app/data/constants/constants.dart';

import '../controllers/splash_controller.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: Get.width * 0.35,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 5),
            'Delivery Man'.tr.bodyMedium(),
          ],
        ),
      ),
    );
  }
}
