import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak_delivery/app/core/enums/enums.dart';
import 'package:wayaak_delivery/app/core/theme/theme.dart';
import 'package:wayaak_delivery/app/core/widgets/back_button.dart';
import 'package:wayaak_delivery/app/core/widgets/global_button.dart';
import 'package:wayaak_delivery/app/core/widgets/global_phone_field.dart';
import 'package:wayaak_delivery/app/core/widgets/global_textfield.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
import 'package:wayaak_delivery/app/routes/app_routes.dart';
import '../controllers/auth_controller.dart';

class SignupPage extends GetView<AuthController> {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        controller.vehicleModelYearController.text = '';
      },
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 35),
                const GlobalBackButton(),
                const SizedBox(height: 16),
                'Create Your New Driver Account'
                    .tr
                    .headline(color: Colors.black),
                const SizedBox(height: 5),
                'Please complete your Profile'
                    .tr
                    .bodyMedium(color: Colors.black),
                const SizedBox(height: 20),
                Form(
                  key: controller.signupFormKey,
                  child: Column(
                    children: [
                      GlobalTextField(
                        hintText: 'Full Name'.tr,
                        prefixIcon: 'person',
                        inputType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        onSaved: (val) => controller.fullName.value = val!,
                        validator: (String? val) {
                          if (val!.isEmpty) {
                            return 'Please enter your full name'.tr;
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      GlobalTextField(
                        hintText: 'email address'.tr,
                        prefixIcon: 'email',
                        inputType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onSaved: (val) => controller.email.value = val!,
                        validator: (String? val) {
                          if (val!.isEmpty) {
                            return 'Please enter your email'.tr;
                          } else if (!val.isEmail) {
                            return 'Please enter a valid email'.tr;
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      GlobalPhoneField(
                        onChanged: (phone) {},
                        onSaved: (val) {
                          controller.phone.value = val!.completeNumber;
                        },
                      ),
                      const SizedBox(height: 8),
                      Obx(
                        () {
                          return GlobalTextField(
                            controller: controller.passSignupController,
                            obsecure: controller.isPassObsecure.value,
                            hintText: 'password'.tr,
                            prefixIcon: 'lock',
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
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Obx(
                  () {
                    return Row(
                      children: [
                        Checkbox(
                          value: controller.terms.value,
                          onChanged: (val) {
                            controller.terms.value = val!;
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        Expanded(
                          child: Wrap(
                            runSpacing: 3,
                            spacing: 3,
                            children: [
                              'I Agree to our '.tr.caption(color: Colors.black),
                              GestureDetector(
                                onTap: () {
                                  controller.staticPagesController.getTerms();
                                  Get.toNamed(Routes.terms);
                                },
                                child: 'Terms of Services'.tr.caption(
                                      color: Get.theme.primaryColor,
                                      weight: FontWeight.w600,
                                    ),
                              ),
                              ' and '.tr.caption(color: Colors.black),
                              GestureDetector(
                                onTap: () {
                                  controller.staticPagesController
                                      .getPrivacyPolicy();
                                  Get.toNamed(Routes.privacy);
                                },
                                child: 'Privacy Policy'.tr.caption(
                                      color: Get.theme.primaryColor,
                                      weight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                GlobalButton(
                  onTap: () {
                    if (controller.signupFormKey.currentState!.validate()) {
                      controller.signupFormKey.currentState!.save();
                      if (!controller.terms.value) {
                        Ui.errorGetBar(
                            message: 'Please agree to our terms & policy'.tr);
                      } else {
                        controller.appServices.registerType.value =
                            RegisterType.normal;
                        Get.toNamed(Routes.setLocation);
                      }
                    }
                  },
                  text: 'Continue'.tr,
                  width: Get.width,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    '${'Already have an account?'.tr} '.bodyMedium(),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: 'Signin'.tr.bodyMedium(
                            color: Get.theme.primaryColor,
                            weight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
