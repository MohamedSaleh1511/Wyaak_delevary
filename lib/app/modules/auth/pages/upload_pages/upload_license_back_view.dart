import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:wayaak_delivery/app/core/enums/enums.dart';
import 'package:wayaak_delivery/app/core/helpers/helpers.dart';
import 'package:wayaak_delivery/app/core/theme/theme.dart';
import 'package:wayaak_delivery/app/core/widgets/global_appbar.dart';
import 'package:wayaak_delivery/app/core/widgets/global_button.dart';
import 'package:wayaak_delivery/app/core/widgets/global_textfield.dart';
import 'package:wayaak_delivery/app/core/widgets/upload_image_widget.dart';
import 'package:wayaak_delivery/app/core/widgets/uploaded_image_card.dart';
import 'package:wayaak_delivery/app/data/constants/constants.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
import 'package:wayaak_delivery/app/modules/auth/controllers/auth_controller.dart';

class UploadLicenseBackView extends GetView<AuthController> {
  const UploadLicenseBackView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlobalAppbar(title: ''),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(
                builder: (context, constraints) => Container(
                  height: 8,
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Constants.softGrey,
                  ),
                  alignment: AlignmentDirectional.centerStart,
                  child: Container(
                    height: 8,
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Get.theme.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              'Upload Your License of Car(Back side)'
                  .tr
                  .title(color: Colors.black),
              const SizedBox(height: 5),
              'Please complete your Profile'.tr.bodyMedium(),
              const SizedBox(height: 15),
              UploadImageWidget(
                onContainerTap: () async {
                  ImagePicker picker = ImagePicker();
                  XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 50,
                  );
                  if (image != null) {
                    controller.backLicence.value = File(image.path);
                  }
                },
                onTap: () async {
                  ImagePicker picker = ImagePicker();
                  controller.appServices.pickImage(
                    () async {
                      final imageSelected = await picker.pickImage(
                        source: ImageSource.camera,
                        imageQuality: 50,
                      );
                      if (imageSelected != null) {
                        controller.backLicence.value = File(imageSelected.path);
                      }
                      Get.back();
                    },
                    () async {
                      final imageSelected = await picker.pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 50,
                      );
                      if (imageSelected != null) {
                        controller.backLicence.value = File(imageSelected.path);
                      }
                      Get.back();
                    },
                  );
                },
              ),
              const SizedBox(height: 10),
              Obx(() {
                if (controller.backLicence.value.path.isEmpty) {
                  return const SizedBox();
                } else {
                  return UploadedImageCard(
                    imagePath: controller.backLicence.value.path,
                    onDeleteTap: () {
                      controller.backLicence.value = File("");
                    },
                  );
                }
              }),
              const SizedBox(height: 10),
              Form(
                key: controller.signup2FormKey,
                child: Column(
                  children: [
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
                              title: const Text("Select Year"),
                              content: SizedBox(
                                height: 300,
                                width: 300,
                                child: YearPicker(
                                  firstDate: DateTime(1990),
                                  lastDate: DateTime(2024),
                                  currentDate: DateTime.now(),
                                  selectedDate:
                                      controller.vehicleModelYear.value != 0
                                          ? DateTime(
                                              controller.vehicleModelYear.value)
                                          : DateTime.now(),
                                  onChanged: (DateTime dateTime) {
                                    controller.vehicleModelYear.value =
                                        dateTime.year;

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
                      onSaved: (val) =>
                          controller.vehicleModelYear.value = int.parse(val!),
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
                    const SizedBox(height: 5),
                    Obx(
                      () {
                        if (controller.isvehicleCategoriesLoading.value) {
                          return Lottie.asset('assets/lotties/dots-loader.json',
                              width: 80);
                        } else {
                          if (controller.vehicleCategoriesTypes.isEmpty) {
                            return 'No data found'.tr.body();
                          } else {
                            return DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                padding: const EdgeInsetsDirectional.symmetric(
                                        horizontal: 15)
                                    .copyWith(end: 25),
                                isExpanded: true,
                                value: controller.vehicleCategoryId.value
                                    .toString(),
                                borderRadius: BorderRadius.circular(15),
                                elevation: 2,
                                hint:
                                    'Select your vehicle type'.tr.bodyMedium(),
                                alignment: Alignment.center,
                                items: List.generate(
                                  controller.vehicleCategoriesTypes.length,
                                  (index) => DropdownMenuItem(
                                    alignment: Alignment.center,
                                    value: controller
                                        .vehicleCategoriesTypes[index].id!
                                        .toString(),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 32,
                                          child:
                                              '${Constants.baseUrl}storage/${controller.vehicleCategoriesTypes[index].image}'
                                                  .image(),
                                        ),
                                        const SizedBox(width: 15),
                                        '${controller.vehicleCategoriesTypes[index].name}'
                                            .body(
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  controller.vehicleCategoryId.value =
                                      int.parse(value!);
                                  controller.getVehiclesType(int.parse(value));
                                },
                              ).decorate(padding: 2),
                            );
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 5),
                    Obx(
                      () {
                        if (controller.isvehicleTypesLoading.value) {
                          return Lottie.asset('assets/lotties/dots-loader.json',
                              width: 80);
                        } else {
                          if (controller.vehicleTypes.isEmpty) {
                            return 'No data found'.tr.body();
                          } else {
                            return DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                padding: const EdgeInsetsDirectional.symmetric(
                                        horizontal: 15)
                                    .copyWith(end: 25),
                                isExpanded: true,
                                value:
                                    controller.vehicleTypeId.value.toString(),
                                borderRadius: BorderRadius.circular(15),
                                elevation: 2,
                                hint:
                                    'Select your vehicle model'.tr.bodyMedium(),
                                alignment: Alignment.center,
                                items: List.generate(
                                  controller.vehicleTypes.length,
                                  (index) => DropdownMenuItem(
                                    alignment: Alignment.center,
                                    value: controller.vehicleTypes[index].id!
                                        .toString(),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 32,
                                          child:
                                              '${Constants.baseUrl}storage/${controller.vehicleTypes[index].image}'
                                                  .image(),
                                        ),
                                        const SizedBox(width: 15),
                                        '${controller.vehicleTypes[index].name}'
                                            .body(
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  controller.vehicleTypeId.value =
                                      int.parse(value!);
                                },
                              ).decorate(padding: 2),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              GlobalButton(
                onTap: () {
                  if (controller.backLicence.value.path.isEmpty) {
                    Ui.errorGetBar(
                        message:
                            "Please add the back side of your car licence".tr);
                  } else {
                    if (controller.signup2FormKey.currentState!.validate()) {
                      controller.signup2FormKey.currentState!.save();
                      if (controller.appServices.registerType.value ==
                          RegisterType.normal) {
                        controller.register();
                      } else {
                        controller.registerSocial();
                      }
                    }
                  }
                },
                text: 'Complete'.tr,
                width: Get.width,
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
