import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:wayaak_delivery/app/core/widgets/global_textfield.dart';
import 'package:wayaak_delivery/app/data/constants/constants.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
import 'package:wayaak_delivery/app/modules/profile/controllers/profile_controller.dart';

class ProfileFields extends GetWidget<ProfileController> {
  const ProfileFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        Obx(
          () => Stack(
            clipBehavior: Clip.none,
            children: [
              controller.driverNewPhoto.value
                  ? Container(
                      width: 140,
                      height: 140,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(80),
                      ),
                      child: Image.file(
                        controller.avatar.value,
                        fit: BoxFit.cover,
                      ),
                    )
                  : controller.appServices.userImage.isEmpty
                      ? Image.asset('assets/images/edit profile.png')
                      : SizedBox(
                          width: 140,
                          height: 140,
                          child: ClipOval(
                            child:
                                "${Constants.baseUrl}storage/${controller.profile.value.data!.driver!.driverPhoto}"
                                    .profileImage,
                          ),
                        ),
              Positioned(
                right: -5,
                top: -5,
                child: InkWell(
                  onTap: () {
                    ImagePicker picker = ImagePicker();
                    controller.appServices.pickImage(
                      () async {
                        final imageSelected = await picker.pickImage(
                          source: ImageSource.camera,
                          imageQuality: 50,
                        );
                        if (imageSelected != null) {
                          controller.driverNewPhoto.value = true;
                          controller.avatar.value = File(imageSelected.path);
                        }
                        Get.back();
                      },
                      () async {
                        final imageSelected = await picker.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 50,
                        );
                        if (imageSelected != null) {
                          controller.driverNewPhoto.value = true;
                          controller.avatar.value = File(imageSelected.path);
                        }
                        Get.back();
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                    child: 'camera'.iconColored(size: 17),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: Get.width,
          child: 'Personal information'.tr.subtitle(),
        ),
        const SizedBox(height: 5),
        Form(
          key: controller.formKey,
          child: Column(
            children: [
              GlobalTextField(
                hintText: 'Full Name'.tr,
                prefixIcon: 'person',
                inputType: TextInputType.name,
                textInputAction: TextInputAction.next,
                controller: controller.fullNameController,
                onSaved: (p0) {},
                validator: (p0) {
                  if (p0!.isEmpty) {
                    return 'Please enter your name';
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
                controller: controller.emailController,
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
              GlobalTextField(
                hintText: 'Birth Date'.tr,
                prefixIcon: 'calendar',
                inputType: TextInputType.datetime,
                textInputAction: TextInputAction.next,
                onTap: () async {
                  DateTime? result = await showDatePicker(
                    context: context,
                    firstDate: DateTime(1950),
                    lastDate:
                        DateTime.now().subtract(const Duration(days: 365)),
                    initialDate: controller.birthDateController.text.isEmpty
                        ? DateTime.now()
                        : DateTime.parse(controller.birthDateController.text),
                    currentDate: controller.isws.value,
                  );

                  if (result != null && result != controller.isws.value) {
                    controller.isws.value = result;
                  }

                  controller.birthDateController.text =
                      DateFormat('yyyy-MM-dd').format(result!);
                },
                controller: controller.birthDateController,
                validator: (p0) {
                  if (p0!.isEmpty) {
                    return 'Please enter your birth date';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        controller.gender.value = 'male';
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: (controller.gender.value == 'male')
                              ? Border.all(
                                  color: Get.theme.primaryColor, width: 1.5)
                              : Border.all(color: Constants.grey, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(width: 5),
                            'male'.iconColored(
                                color: (controller.gender.value == 'male')
                                    ? Get.theme.primaryColor
                                    : Constants.grey),
                            const SizedBox(width: 5),
                            "Male".tr.button(
                                color: (controller.gender.value == 'male')
                                    ? Get.theme.primaryColor
                                    : Constants.grey),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        controller.gender.value = 'female';
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: (controller.gender.value == 'female')
                              ? Border.all(
                                  color: Get.theme.primaryColor, width: 1.5)
                              : Border.all(color: Constants.grey, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            'female'.iconColored(
                                color: (controller.gender.value == 'female')
                                    ? Get.theme.primaryColor
                                    : Constants.grey),
                            const SizedBox(width: 5),
                            "Female".tr.button(
                                color: (controller.gender.value == 'female')
                                    ? Get.theme.primaryColor
                                    : Constants.grey),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
