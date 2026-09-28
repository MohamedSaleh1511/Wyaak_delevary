import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:wayaak_delivery/app/core/helpers/helpers.dart';
import 'package:wayaak_delivery/app/core/widgets/global_textfield.dart';
import 'package:wayaak_delivery/app/data/constants/constants.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
import 'package:wayaak_delivery/app/modules/profile/controllers/profile_controller.dart';
import 'package:wayaak_delivery/app/modules/profile/widgets/doc_image_card.dart';

class CarFields extends GetWidget<ProfileController> {
  const CarFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: Get.width,
          child: 'Car information'.tr.subtitle(),
        ),
        const SizedBox(height: 5),
        Obx(() {
          if (controller.authController.isvehicleCategoriesLoading.value) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                  ).shimmer(),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsetsDirectional.only(end: 20),
                      height: 12,
                    ).shimmer(),
                  ),
                  const SizedBox(width: 30),
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 16,
                  ).shimmer(),
                ],
              ),
            ).decorate(padding: 10);
          } else {
            if (controller.authController.vehicleCategoriesTypes.isEmpty) {
              return 'No data found'.tr.body();
            } else {
              return DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 15)
                      .copyWith(end: 25),
                  isExpanded: true,
                  value: controller.vehicleId.value,
                  borderRadius: BorderRadius.circular(15),
                  elevation: 2,
                  hint: 'Select your vehicle type'.tr.bodyMedium(),
                  alignment: Alignment.center,
                  items: List.generate(
                    controller.authController.vehicleCategoriesTypes.length,
                    (index) => DropdownMenuItem(
                      alignment: Alignment.center,
                      value: controller
                          .authController.vehicleCategoriesTypes[index].id!,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 32,
                            child:
                                '${Constants.baseUrl}storage/${controller.authController.vehicleCategoriesTypes[index].image}'
                                    .image(),
                          ),
                          const SizedBox(width: 15),
                          '${controller.authController.vehicleCategoriesTypes[index].name}'
                              .body(
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    controller.vehicleId.value = value!;
                    controller.authController.getVehiclesType(value);
                  },
                ).decorate(padding: 2),
              );
            }
          }
        }),
        const SizedBox(height: 5),
        Obx(
          () {
            if (controller.authController.isvehicleTypesLoading.value) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20,
                    ).shimmer(),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: const EdgeInsetsDirectional.only(end: 20),
                        height: 12,
                      ).shimmer(),
                    ),
                    const SizedBox(width: 30),
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 16,
                    ).shimmer(),
                  ],
                ),
              ).decorate(padding: 10);
            } else {
              if (controller.authController.vehicleTypes.isEmpty) {
                return const SizedBox();
              } else {
                return DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    padding:
                        const EdgeInsetsDirectional.symmetric(horizontal: 15)
                            .copyWith(end: 25),
                    isExpanded: true,
                    value: controller.vehicleTypeId.value,
                    borderRadius: BorderRadius.circular(15),
                    elevation: 2,
                    hint: 'Select your vehicle model'.tr.bodyMedium(),
                    alignment: Alignment.center,
                    items: List.generate(
                      controller.authController.vehicleTypes.length,
                      (index) => DropdownMenuItem(
                        alignment: Alignment.center,
                        value:
                            controller.authController.vehicleTypes[index].id!,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 32,
                              child:
                                  '${Constants.baseUrl}storage/${controller.authController.vehicleTypes[index].image}'
                                      .image(),
                            ),
                            const SizedBox(width: 15),
                            '${controller.authController.vehicleTypes[index].name}'
                                .body(
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      controller.vehicleTypeId.value = value!;
                    },
                  ).decorate(padding: 2),
                );
              }
            }
          },
        ),
        const SizedBox(height: 10),
        GlobalTextField(
          controller: controller.vehicleModelYearController,
          textInputFormatters: [
            LengthLimitingTextInputFormatter(4),
            FilteringTextInputFormatter.digitsOnly,
          ],
          hintText: 'Car model year'.tr,
          prefixIcon: 'calendar',
          onTap: () async {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Center(child: "Select Year".tr.titleSmall()),
                  content: SizedBox(
                    height: 300,
                    width: 300,
                    child: YearPicker(
                      firstDate: DateTime(1990),
                      lastDate: DateTime(2024),
                      currentDate: DateTime.now(),
                      selectedDate: controller.vehicleModelYear.value != 0
                          ? DateTime(controller.vehicleModelYear.value)
                          : DateTime.now(),
                      onChanged: (DateTime dateTime) {
                        controller.vehicleModelYear.value = dateTime.year;

                        controller.vehicleModelYearController.text =
                            dateTime.year.toString();

                        Get.back();
                      },
                    ),
                  ),
                );
              },
            );
          },
          inputType: TextInputType.datetime,
          textInputAction: TextInputAction.next,
          onSaved: (val) => controller.vehicleModelYear.value = int.parse(val!),
          validator: (String? val) {
            if (val!.isEmpty) {
              return 'Please enter your vehicles model year'.tr;
            } else if (val.length > 4 || val.length < 4) {
              return 'Please enter valid year'.tr;
            } else {
              return null;
            }
          },
        ),
        const SizedBox(height: 5),
        GlobalTextField(
          controller: controller.licenseExpiryController,
          hintText: 'Driving License Expiry'.tr,
          prefixIcon: 'car',
          onTap: () async {
            DateTime? result = await showDatePicker(
              context: context,
              firstDate: DateTime(2024),
              lastDate: DateTime(2100),
            );

            controller.licenseExpiryController.text =
                DateFormat('yyyy-MM-dd').format(result!);
          },
          inputType: TextInputType.datetime,
          textInputAction: TextInputAction.next,
          onSaved: (val) => controller.licenseExpiry.value = val!,
          validator: (String? val) {
            if (val!.isEmpty) {
              return 'Please enter your Driving license expiry'.tr;
            } else {
              return null;
            }
          },
        ),
        const SizedBox(height: 5),
        GlobalTextField(
          controller: controller.vehiclePlateController,
          hintText: 'Vehicle metal plate'.tr,
          prefixIcon: 'smart-car',
          textInputFormatters: [
            LengthLimitingTextInputFormatter(10),
            WordSeparatorInputFormatter(),
          ],
          inputType: TextInputType.text,
          textInputAction: TextInputAction.next,
          onSaved: (val) {
            var com = val!.replaceAll('-', '');
            controller.vehicleMetalPlate.value = com;
          },
          validator: (String? val) {
            if (val!.isEmpty) {
              return 'Please enter your Vehicle metal plate'.tr;
            } else {
              return null;
            }
          },
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: Get.width,
          child: 'Media'.tr.subtitle(),
        ),
        const SizedBox(height: 5),
        if (controller.profile.value.data != null) ...{
          if (controller.vehicleId.value !=
              controller.profile.value.data!.driver!.vehicle!.category!.id) ...{
            Row(
              children: [
                'You should add documents for this vehicle'.tr.caption(),
              ],
            ),
          },
        },
        const SizedBox(height: 5),
        Obx(() {
          if (controller.isCarPhotoUpdated.value) {
            return DocImageCard(
              imageName: 'Vehicle Photo'.tr,
              isLink: false,
              imagePath: controller.carPhoto.value.path,
              onEditTap: () {
                ImagePicker picker = ImagePicker();
                controller.appServices.pickImage(
                  () async {
                    final imageSelected = await picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 50,
                    );
                    if (imageSelected != null) {
                      controller.carPhoto.value = File(imageSelected.path);
                      controller.changeCarPhoto(imageSelected.path);
                      controller.isCarPhotoUpdated.value = true;
                      Get.log(
                          "Vehicle Photo :: ggg ${controller.carPhoto.value}");
                    }
                    Get.back();
                  },
                  () async {
                    final imageSelected = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 50,
                    );
                    if (imageSelected != null) {
                      controller.carPhoto.value = File(imageSelected.path);
                      controller.changeCarPhoto(imageSelected.path);
                      controller.isCarPhotoUpdated.value = true;
                    }
                    Get.back();
                  },
                );
              },
            );
          } else {
            return DocImageCard(
              key: const ValueKey('dsassss'),
              imageName: 'Vehicle Photo'.tr,
              isLink: true,
              imagePath: controller.appServices.profileModel.value.data!.driver!
                      .vehicle!.vehiclePhoto ??
                  "",
              onEditTap: () {
                ImagePicker picker = ImagePicker();
                controller.appServices.pickImage(
                  () async {
                    final imageSelected = await picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 50,
                    );
                    if (imageSelected != null) {
                      controller.carPhoto.value = File(imageSelected.path);
                      controller.changeCarPhoto(imageSelected.path);
                      controller.isCarPhotoUpdated.value = true;
                      Get.log(
                          "Vehicle Photo :: ffff ${controller.carPhoto.value}");
                    }
                    Get.back();
                  },
                  () async {
                    final imageSelected = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 50,
                    );
                    if (imageSelected != null) {
                      controller.carPhoto.value = File(imageSelected.path);
                      controller.changeCarPhoto(imageSelected.path);
                      controller.isCarPhotoUpdated.value = true;
                    }
                    Get.back();
                  },
                );
              },
            );
          }
        }),
        const SizedBox(height: 5),
        Obx(() {
          if (controller.isFrontPhotoUpdated.value) {
            return DocImageCard(
              imageName: 'Vehicle License (Front)'.tr,
              isLink: false,
              imagePath: controller.frontLicensePhoto.value.path,
              onEditTap: () {
                ImagePicker picker = ImagePicker();
                controller.appServices.pickImage(
                  () async {
                    final imageSelected = await picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 50,
                    );
                    if (imageSelected != null) {
                      controller.frontLicensePhoto.value =
                          File(imageSelected.path);
                      controller.changeFrontPhoto(imageSelected.path);
                      controller.isFrontPhotoUpdated.value = true;
                    }
                    Get.back();
                  },
                  () async {
                    final imageSelected = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 50,
                    );
                    if (imageSelected != null) {
                      controller.frontLicensePhoto.value =
                          File(imageSelected.path);
                      controller.changeFrontPhoto(imageSelected.path);
                      controller.isFrontPhotoUpdated.value = true;
                    }
                    Get.back();
                  },
                );
              },
            );
          } else {
            return DocImageCard(
              key: const ValueKey('dsassssssfreg'),
              imageName: 'Vehicle License (Front)'.tr,
              isLink: true,
              imagePath: controller.appServices.profileModel.value.data!.driver!
                      .vehicle!.frontLicense ??
                  "",
              onEditTap: () {
                ImagePicker picker = ImagePicker();
                controller.appServices.pickImage(
                  () async {
                    final imageSelected = await picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 50,
                    );
                    if (imageSelected != null) {
                      controller.frontLicensePhoto.value =
                          File(imageSelected.path);
                      controller.changeFrontPhoto(imageSelected.path);
                      controller.isFrontPhotoUpdated.value = true;
                      Get.log(
                          "Vehicle Photo :: ffff ${controller.carPhoto.value}");
                    }
                    Get.back();
                  },
                  () async {
                    final imageSelected = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 50,
                    );
                    if (imageSelected != null) {
                      controller.frontLicensePhoto.value =
                          File(imageSelected.path);
                      controller.changeFrontPhoto(imageSelected.path);
                      controller.isFrontPhotoUpdated.value = true;
                    }
                    Get.back();
                  },
                );
              },
            );
          }
        }),
        const SizedBox(height: 5.01),
        Obx(() {
          if (controller.isBackPhotoUpdated.value) {
            return DocImageCard(
              imageName: 'Vehicle License (Back)'.tr,
              isLink: false,
              imagePath: controller.backLicensePhoto.value.path,
              onEditTap: () {
                ImagePicker picker = ImagePicker();
                controller.appServices.pickImage(
                  () async {
                    final imageSelected = await picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 50,
                    );
                    if (imageSelected != null) {
                      controller.backLicensePhoto.value =
                          File(imageSelected.path);
                      controller.changeBackPhoto(imageSelected.path);
                      controller.isBackPhotoUpdated.value = true;
                    }
                    Get.back();
                  },
                  () async {
                    final imageSelected = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 50,
                    );
                    if (imageSelected != null) {
                      controller.backLicensePhoto.value =
                          File(imageSelected.path);
                      controller.changeBackPhoto(imageSelected.path);
                      controller.isBackPhotoUpdated.value = true;
                    }
                    Get.back();
                  },
                );
              },
            );
          } else {
            return DocImageCard(
              key: const ValueKey('dsasrewsssfreg'),
              imageName: 'Vehicle License (Back)'.tr,
              isLink: true,
              imagePath: controller.appServices.profileModel.value.data!.driver!
                      .vehicle!.backLicense ??
                  "",
              onEditTap: () {
                ImagePicker picker = ImagePicker();
                controller.appServices.pickImage(
                  () async {
                    final imageSelected = await picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 50,
                    );
                    if (imageSelected != null) {
                      controller.backLicensePhoto.value =
                          File(imageSelected.path);
                      controller.changeBackPhoto(imageSelected.path);
                      controller.isBackPhotoUpdated.value = true;
                      Get.log(
                          "Vehicle Photo :: ffff ${controller.carPhoto.value}");
                    }
                    Get.back();
                  },
                  () async {
                    final imageSelected = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 50,
                    );
                    if (imageSelected != null) {
                      controller.backLicensePhoto.value =
                          File(imageSelected.path);
                      controller.changeBackPhoto(imageSelected.path);
                      controller.isBackPhotoUpdated.value = true;
                    }
                    Get.back();
                  },
                );
              },
            );
          }
        }),
      ],
    );
  }
}
