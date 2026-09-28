import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:wayaak_delivery/app/core/widgets/global_appbar.dart';
import 'package:wayaak_delivery/app/core/widgets/global_button.dart';
import 'package:wayaak_delivery/app/data/constants/constants.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
import 'package:wayaak_delivery/app/modules/requests/controllers/requests_controller.dart';

class WaitingView extends GetView<RequestsController> {
  const WaitingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppbar(title: "Waiting".tr),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/lotties/dots-loader.json', width: 85),
              const SizedBox(height: 15),
              "Please wait here until the owner of the order respond to your offer"
                  .tr
                  .bodyMedium(center: true),
              const Spacer(),
              GlobalButton(
                onTap: () => controller.cancelOffer(),
                text: "Cancel Offer".tr,
                color: Constants.accent,
                textColor: Colors.white,
                width: Get.width * 0.9,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
