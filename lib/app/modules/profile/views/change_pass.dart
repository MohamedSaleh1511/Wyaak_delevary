import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak_delivery/app/core/widgets/back_button.dart';
import 'package:wayaak_delivery/app/core/widgets/global_button.dart';
import 'package:wayaak_delivery/app/core/widgets/global_textfield.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
import 'package:wayaak_delivery/app/modules/profile/controllers/profile_controller.dart';

class ChangesPassword extends GetView<ProfileController> {
  const ChangesPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        // physics: const BouncingScrollPhysics(),
        child: SizedBox(
          height: Get.height,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 35),
                const GlobalBackButton(),
                const SizedBox(height: 26),
                'Change Password'.tr.headline(color: Colors.black),
                const SizedBox(height: 5),
                'enter a new password'.tr.body(),
                const SizedBox(height: 40),
                Expanded(
                  child: Obx(() {
                    return Form(
                      key: controller.changePassFormKey,
                      child: Column(
                        children: [
                          GlobalTextField(
                            hintText: 'Old Password'.tr,
                            prefixIcon: 'lock',
                            obsecure: controller.isOldPassObsecure.value,
                            suffixIcon: (controller.isOldPassObsecure.value)
                                ? 'eye-closed'
                                : 'eye',
                            inputType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.next,
                            onSaved: (val) =>
                                controller.oldPassword.value = val!,
                            validator: (String? val) {
                              if (val!.isEmpty) {
                                return 'password is required'.tr;
                              } else if (val.length < 8) {
                                return 'password must be at least 8 digits'.tr;
                              } else {
                                return null;
                              }
                            },
                            onSuffixTap: () => controller.isOldPassObsecure
                                .value = !controller.isOldPassObsecure.value,
                          ),
                          const SizedBox(height: 8),
                          GlobalTextField(
                            controller: controller.passworfController,
                            hintText: 'New Password'.tr,
                            prefixIcon: 'lock',
                            obsecure: controller.isPassObsecure.value,
                            suffixIcon: (controller.isPassObsecure.value)
                                ? 'eye-closed'
                                : 'eye',
                            inputType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.next,
                            onSaved: (val) => controller.password.value = val!,
                            validator: (String? val) {
                              if (val!.isEmpty) {
                                return 'password is required'.tr;
                              } else if (val.length < 8) {
                                return 'password must be at least 8 digits'.tr;
                              } else {
                                return null;
                              }
                            },
                            onSuffixTap: () => controller.isPassObsecure.value =
                                !controller.isPassObsecure.value,
                          ),
                          const SizedBox(height: 8),
                          GlobalTextField(
                            hintText: 'Re-type New Password'.tr,
                            prefixIcon: 'lock',
                            obsecure: controller.isConfirmPassObsecure.value,
                            suffixIcon: (controller.isConfirmPassObsecure.value)
                                ? 'eye-closed'
                                : 'eye',
                            inputType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.next,
                            onSaved: (val) =>
                                controller.passConfirm.value = val!,
                            validator: (String? val) {
                              if (val!.isEmpty) {
                                return 'password is required'.tr;
                              } else if (val !=
                                  controller.passworfController.text) {
                                return 'Password does not match'.tr;
                              } else {
                                return null;
                              }
                            },
                            onSuffixTap: () =>
                                controller.isConfirmPassObsecure.value =
                                    !controller.isConfirmPassObsecure.value,
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                GlobalButton(
                  onTap: () {
                    if (controller.changePassFormKey.currentState!.validate()) {
                      controller.changePassFormKey.currentState!.save();
                      controller.resetPassword();
                    }
                  },
                  text: 'Save'.tr,
                  width: Get.width,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
