import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak_delivery/app/data/constants/constants.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
import 'package:wayaak_delivery/app/modules/home/widgets/drawer_item.dart';
import 'package:wayaak_delivery/app/modules/static_pages/controllers/static_pages_controller.dart';
import 'package:wayaak_delivery/app/modules/support/controllers/support_controller.dart';
import 'package:wayaak_delivery/app/routes/app_routes.dart';

class GuestView extends GetView {
  const GuestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            'Good Morning'.tr.caption(color: Colors.black54),
            'Guest'.subtitle(
              color: Colors.black,
              weight: FontWeight.w600,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            DrawerItem(
              onTap: () {
                Get.find<SupportController>().getFaq();
                Get.toNamed(Routes.faq);
              },
              text: 'FAQ'.tr,
              icon: 'info',
            ),
            DrawerItem(
              onTap: () => Get.toNamed(Routes.language),
              text: 'Language'.tr,
              icon: 'language',
            ),
            DrawerItem(
              onTap: () {
                Get.find<StaticPagesController>().getAbout();
                Get.toNamed(Routes.about);
              },
              text: 'About Us'.tr,
              icon: 'About Us',
            ),
            DrawerItem(
              onTap: () {
                Get.find<StaticPagesController>().getPrivacyPolicy();
                Get.toNamed(Routes.privacy);
              },
              text: 'Privacy Policy'.tr,
              icon: 'danger',
            ),
            DrawerItem(
              onTap: () {
                Get.find<StaticPagesController>().getTerms();
                Get.toNamed(Routes.terms);
              },
              text: 'Terms And Conditions'.tr,
              icon: 'terms',
            ),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onTap: () {
                Get.offAllNamed(Routes.login);
              },
              contentPadding: const EdgeInsets.all(0),
              leading: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: Constants.accent.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: UnconstrainedBox(
                    child: 'login'.iconColored(color: Constants.accent)),
              ),
              title: 'Signin'.tr.subtitle(
                    color: Constants.accent,
                    weight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
