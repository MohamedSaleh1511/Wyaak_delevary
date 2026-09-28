import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayaak_delivery/app/core/theme/theme.dart';
import 'package:wayaak_delivery/app/core/widgets/global_appbar.dart';
import 'package:wayaak_delivery/app/core/widgets/global_button.dart';
import 'package:wayaak_delivery/app/core/widgets/upload_image_widget.dart';
import 'package:wayaak_delivery/app/core/widgets/uploaded_image_card.dart';
import 'package:wayaak_delivery/app/data/constants/constants.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
import 'package:wayaak_delivery/app/modules/auth/controllers/auth_controller.dart';
import 'package:wayaak_delivery/app/routes/app_routes.dart';

class UploadCarImageView extends GetView<AuthController> {
  const UploadCarImageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlobalAppbar(title: ''),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
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
                    width: constraints.maxWidth * 0.50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Get.theme.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              'Upload Your Car photo'.tr.title(color: Colors.black),
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
                    controller.carPhoto.value = File(image.path);
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
                        controller.carPhoto.value = File(imageSelected.path);
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
                      }
                      Get.back();
                    },
                  );
                },
              ),
              const SizedBox(height: 10),
              Obx(() {
                if (controller.carPhoto.value.path.isEmpty) {
                  return const SizedBox();
                } else {
                  return UploadedImageCard(
                    imagePath: controller.carPhoto.value.path,
                    onDeleteTap: () {
                      controller.carPhoto.value = File("");
                    },
                  );
                }
              }),
              const Spacer(),
              GlobalButton(
                onTap: () {
                  if (controller.carPhoto.value.path.isEmpty) {
                    Ui.errorGetBar(message: "Please add your car image".tr);
                  } else {
                    Get.toNamed(Routes.uploadLicenseFront);
                  }
                },
                text: 'Next'.tr,
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
