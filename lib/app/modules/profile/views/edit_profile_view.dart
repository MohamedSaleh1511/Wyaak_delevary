import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:wayaak_delivery/app/core/widgets/global_appbar.dart';
import 'package:wayaak_delivery/app/core/widgets/global_button.dart';
import 'package:wayaak_delivery/app/data/constants/constants.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
import 'package:wayaak_delivery/app/modules/profile/controllers/profile_controller.dart';
import 'package:wayaak_delivery/app/modules/profile/widgets/car_fields.dart';
import 'package:wayaak_delivery/app/modules/profile/widgets/profile_fields.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final ProfileController controller = Get.find<ProfileController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppbar(title: 'Edit Profile'.tr),
      body: Obx(() {
        if (controller.isProfileLoading.value) {
          return Center(
            child: Lottie.asset('assets/lotties/dots-loader.json', width: 80),
          );
        } else {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: Column(
                children: [
                  const ProfileFields(),
                  const SizedBox(height: 30),
                  SwitchListTile(
                    value: controller.updateVehicleData.value,
                    onChanged: (v) => controller.updateVehicleData.value = v,
                    title: 'Update Vehicle data'.tr.titleSmall(),
                    activeTrackColor: Constants.green.withOpacity(0.2),
                    activeColor: Constants.green,
                    inactiveThumbColor: Constants.accent,
                    inactiveTrackColor: Constants.accent.withOpacity(0.2),
                    trackOutlineColor:
                        const WidgetStatePropertyAll(Colors.transparent),
                  ).decorate(),
                  const SizedBox(height: 15),
                  if (controller.updateVehicleData.value) const CarFields(),
                  GlobalButton(
                    onTap: () {
                      if (controller.formKey.currentState!.validate()) {
                        controller.formKey.currentState!.save();
                        controller.updateProfileData();
                      }
                    },
                    text: 'Save'.tr,
                    width: Get.width,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        }
      }),
    );
  }
}
