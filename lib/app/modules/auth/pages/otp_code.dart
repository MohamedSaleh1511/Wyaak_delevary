import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:wayaak_delivery/app/core/enums/enums.dart';
import 'package:wayaak_delivery/app/core/widgets/back_button.dart';
import 'package:wayaak_delivery/app/core/widgets/global_button.dart';
import 'package:wayaak_delivery/app/data/constants/constants.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
import '../controllers/auth_controller.dart';

class OtpCodePage extends StatefulWidget {
  const OtpCodePage({super.key});

  @override
  State<OtpCodePage> createState() => _OtpCodePageState();
}

class _OtpCodePageState extends State<OtpCodePage> {
  final AuthController controller = Get.find<AuthController>();

  int _remainingTime = 60; // 60 seconds = 1 minute
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 35),
              const GlobalBackButton(),
              const SizedBox(height: 26),
              'Verfication code'.tr.headline(color: Colors.black),
              const SizedBox(height: 60),
              Form(
                key: controller.otpFormKey,
                child: Center(
                  child: Pinput(
                    onCompleted: (value) {
                      controller.otpCode.value = value;
                    },
                    onSubmitted: (value) {},
                    length: 6,
                    submittedPinTheme: PinTheme(
                      height: 55,
                      width: 55,
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(
                              color: Colors.black, fontWeight: FontWeight.bold),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100)),
                        border: Border.all(
                            color: const Color(0xFFB5B5B5), width: 2),
                      ),
                    ),
                    errorPinTheme: PinTheme(
                      height: 55,
                      width: 55,
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(
                              color: Get.theme.colorScheme.error,
                              fontWeight: FontWeight.bold),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        border: Border.all(
                            color: const Color(0xFFB5B5B5), width: 2),
                      ),
                    ),
                    defaultPinTheme: PinTheme(
                      height: 55,
                      width: 55,
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(
                              color: Colors.black, fontWeight: FontWeight.bold),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        border: Border.all(
                            color: const Color(0xFFB5B5B5), width: 2),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              GlobalButton(
                onTap: () {
                  if (controller.otpFormKey.currentState!.validate()) {
                    controller.otpFormKey.currentState!.save();
                    if (controller.appServices.otpType.value ==
                        OtpType.register) {
                      controller.verifyOtp();
                    } else {
                      controller.resetCode();
                    }
                  }
                },
                text: 'Verify'.tr,
                width: Get.width,
              ),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        startTimer();
                      },
                      child: 'Resend New Code'.tr.bodyMedium(
                            color: _remainingTime == 0
                                ? Constants.accent
                                : Constants.grey,
                            weight: FontWeight.bold,
                          ),
                    ),
                    if (_remainingTime != 0)
                      ' ${'in'.tr} 00:$_remainingTime'.bodyMedium(
                        color: Constants.secondary,
                        weight: FontWeight.bold,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
