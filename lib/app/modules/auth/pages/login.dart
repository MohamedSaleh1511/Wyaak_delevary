import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:wayaak_delivery/app/core/theme/theme.dart';
import 'package:wayaak_delivery/app/core/widgets/global_button.dart';
import 'package:wayaak_delivery/app/core/widgets/global_phone_field.dart';
import 'package:wayaak_delivery/app/core/widgets/global_textfield.dart';
import 'package:wayaak_delivery/app/data/constants/constants.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
import 'package:wayaak_delivery/app/routes/app_routes.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 80),
                  child: SizedBox(
                    width: double.infinity,
                    child: 'Login To Your Account'
                        .tr
                        .headline(color: Colors.black),
                  ),
                ),
                Form(
                  key: controller.loginFormKey,
                  child: Column(
                    children: [
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
                            controller: controller.passController,
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
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                Obx(
                  () {
                    return Row(
                      children: [
                        Checkbox.adaptive(
                          value: controller.remember.value,
                          onChanged: (val) {
                            controller.remember.value = val!;
                          },
                        ),
                        'Remember me'.tr.bodyMedium(color: Colors.black),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 25),
                GlobalButton(
                  onTap: () {
                    if (controller.loginFormKey.currentState!.validate()) {
                      controller.loginFormKey.currentState!.save();
                      controller.login();
                    }
                  },
                  text: 'login'.tr,
                  width: Get.width,
                ),
                const SizedBox(height: 5),
                TextButton(
                  onPressed: () => Get.toNamed(Routes.forgetPass),
                  child: 'Forgot password?'
                      .tr
                      .button(color: Get.theme.primaryColor),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Expanded(
                      child: Divider(endIndent: 10, color: Constants.grey),
                    ),
                    'OR'.tr.body(
                          color: Get.theme.primaryColor,
                          weight: FontWeight.bold,
                        ),
                    const Expanded(
                      child: Divider(indent: 10, color: Constants.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: Get.width,
                  child: TextButton.icon(
                    onPressed: () async {
                      GoogleSignIn googleSignIn = GoogleSignIn.instance;
                      await googleSignIn.initialize(
                        serverClientId: '919515913067-5ioqlhb70o9ua9o40o5n2h638sf7prj2.apps.googleusercontent.com',
                      );
                      try {
                        GoogleSignInAccount? data =
                            await googleSignIn.authenticate();
                        log("Google data :: ${data.email}");
                        log("Google data :: ${data.displayName}");

                        log("Google Access Token :: Not available via GoogleSignInAuthentication");
                        log("Google id :: ${data.id}");
                        controller.socialId.value = data.id;
                        controller.socialProvider.value = 'google';
                        controller.socialAuth(
                          emaill: data.email,
                          name: data.displayName,
                          provider: 'google',
                          socialMediaId: data.id,
                        );
                      } catch (e) {
                        log("Error : $e");
                        Ui.errorGetBar(message: "Something went wrong".tr);
                      }
                    },
                    icon: 'google'.iconColored(),
                    style: TextButton.styleFrom(
                      elevation: 0.0,
                      shape: const StadiumBorder(
                        side: BorderSide(color: Colors.black, width: 1),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    label: "Sign Up with Google".tr.button(
                          color: Colors.black,
                        ),
                  ),
                ),
                // const SizedBox(height: 8),
                // SizedBox(
                //   width: Get.width,
                //   child: TextButton.icon(
                //     onPressed: () async {
                //       var faceAuth = await FacebookAuth.instance.login();
                //       if (faceAuth.status == LoginStatus.success) {
                //         var faceUserData =
                //             await FacebookAuth.instance.getUserData();
                //         log("FaceBook Auth data :: ${faceAuth.accessToken}");
                //         log("FaceBook Auth data :: $faceAuth");
                //         log("FaceBook id :: ${faceUserData['id']}");
                //         controller.socialId.value = faceUserData['id'];
                //         controller.socialProvider.value = 'facebook';
                //         controller.socialAuth(
                //           emaill: faceUserData['email'],
                //           name: faceUserData['name'],
                //           provider: 'facebook',
                //           socialMediaId: faceUserData['id'],
                //         );
                //       }
                //     },
                //     icon: 'facebook'.iconColored(),
                //     style: TextButton.styleFrom(
                //       elevation: 0.0,
                //       shape: const StadiumBorder(),
                //       backgroundColor: Get.theme.primaryColor,
                //       padding: const EdgeInsets.symmetric(vertical: 15),
                //     ),
                //     label: "Sign Up with Facebook".tr.button(
                //           color: Colors.white,
                //         ),
                //   ),
                // ),
                const SizedBox(height: 8),
                SizedBox(
                  width: Get.width,
                  child: TextButton.icon(
                    onPressed: () async {
                      final credential =
                          await SignInWithApple.getAppleIDCredential(
                        scopes: [
                          AppleIDAuthorizationScopes.email,
                          AppleIDAuthorizationScopes.fullName,
                        ],
                      );

                      controller.socialAuth(
                        emaill: credential.email,
                        name: "${credential.givenName}${credential.familyName}",
                        provider: 'apple',
                        socialMediaId: credential.userIdentifier,
                      );
                    },
                    icon: 'apple'.iconColored(color: Colors.white),
                    style: TextButton.styleFrom(
                      elevation: 0.0,
                      shape: const StadiumBorder(),
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    label: "Sign Up with Apple".tr.button(
                          color: Colors.white,
                        ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    '${'Don’t Have An Account?'.tr} '.bodyMedium(),
                    GestureDetector(
                      onTap: () {
                        controller.passSignupController.text = '';
                        controller.passController.text = '';
                        controller.licenseExpiryController.text = '';
                        controller.driverPhoto.value = File('');
                        controller.carPhoto.value = File('');
                        controller.frontLicence.value = File('');
                        controller.backLicence.value = File('');
                        controller.vehicleCategoryId.value = 1;
                        controller.vehicleTypeId.value = 1;
                        controller.vehicleMetalPlate.value = '';
                        controller.vehicleModelYear.value = 0;
                        Get.toNamed(Routes.signup);
                      },
                      child: 'sign up'.tr.bodyMedium(
                            color: Get.theme.primaryColor,
                            weight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                GestureDetector(
                  onTap: () => Get.offAllNamed(Routes.guest),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: 'Login as Guest'.tr.bodyMedium(
                          color: Get.theme.primaryColor,
                          weight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
