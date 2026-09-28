import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:wayaak_delivery/app/data/constants/constants.dart';

final ThemeData light = ThemeData(
  fontFamily: Get.locale == const Locale('ar') ? 'Tajawal' : 'Montserrat',
  primaryColor: Constants.primary,
  colorScheme: const ColorScheme.light().copyWith(
    primary: Constants.primary,
    secondary: Constants.secondary,
    error: Constants.accent,
    surfaceTint: Colors.transparent,
  ),
  scaffoldBackgroundColor: Colors.white,
  shadowColor: const Color.fromRGBO(6, 43, 45, 0.1),
  appBarTheme: AppBarTheme(
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    backgroundColor: Colors.white,
    shadowColor: const Color.fromRGBO(39, 63, 219, 0.09),
  ),
  checkboxTheme: CheckboxThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(3),
    ),
    side: const BorderSide(width: 1.5, color: Colors.black),
  ),
);

class Ui {
  static void successGetBar({required String message}) {
    Get.showSnackbar(
      GetSnackBar(
        messageText: Text(
          message,
          style: Get.textTheme.bodySmall!.merge(
            const TextStyle(color: Colors.white),
          ),
        ),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20),
        backgroundColor: Colors.green,
        icon: const Icon(
          Icons.check_circle_outline,
          size: 32,
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        borderRadius: 15,
        dismissDirection: DismissDirection.horizontal,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void errorGetBar({required String message}) {
    Get.showSnackbar(
      GetSnackBar(
        messageText: Text(
          message,
          style: Get.textTheme.bodySmall!.merge(
            const TextStyle(color: Colors.white),
          ),
        ),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20),
        backgroundColor: Get.theme.colorScheme.secondary,
        icon: const Icon(
          Icons.remove_circle_outline,
          size: 32,
          color: Colors.white,
        ),
        overlayBlur: 2.5,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        borderRadius: 15,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void loadingDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        insetAnimationCurve: Curves.bounceInOut,
        insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Loading'.tr,
                style: Get.textTheme.bodyLarge!.copyWith(
                  color: Colors.black,
                  fontFamily: Get.locale == const Locale('ar')
                      ? 'Tajawal'
                      : 'Montserrat',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 5),
              Lottie.asset('assets/lotties/dots-loader.json', width: 80),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
      transitionCurve: Curves.easeInOutBack,
    );
  }
}
