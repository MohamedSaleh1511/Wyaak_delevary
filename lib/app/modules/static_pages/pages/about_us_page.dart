import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:wayaak_delivery/app/core/widgets/global_appbar.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
import 'package:wayaak_delivery/app/modules/static_pages/controllers/static_pages_controller.dart';

class AboutUsPage extends GetView<StaticPagesController> {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppbar(title: 'About Us'.tr),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Obx(
          () => controller.loading.value
              ? Center(
                  child: Lottie.asset('assets/lotties/dots-loader.json',
                      width: 80))
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child:
                      controller.aboutModel.value.data!.content!.bodyMedium(),
                ),
        ),
      ),
    );
  }
}
