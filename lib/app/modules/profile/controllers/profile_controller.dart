import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak_delivery/app/core/theme/theme.dart';
import 'package:wayaak_delivery/app/data/models/global_response_model.dart';
import 'package:wayaak_delivery/app/data/models/no_data_response_model.dart';
import 'package:wayaak_delivery/app/data/models/profile_model/profile_model.dart';
import 'package:wayaak_delivery/app/data/services/app_services.dart';
import 'package:wayaak_delivery/app/modules/auth/controllers/auth_controller.dart';
import 'package:wayaak_delivery/app/modules/profile/providers/profile_providers.dart';

class ProfileController extends GetxController {
  final ProfileProviders provider = Get.find<ProfileProviders>();
  final AppServices appServices = Get.find<AppServices>();
  final AuthController authController = Get.find<AuthController>();

  Rx<DateTime> isws = DateTime.now().obs;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController passworfController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ExpansionTileController vehicleController = ExpansionTileController();
  final GlobalKey<FormState> changePassFormKey = GlobalKey<FormState>();
  final TextEditingController licenseExpiryController = TextEditingController();
  final TextEditingController vehiclePlateController = TextEditingController();
  final TextEditingController vehicleModelYearController =
      TextEditingController();

  RxBool updateVehicleData = false.obs;

  // ANCHOR -----> Form Fields
  RxString oldPassword = ''.obs;
  RxString password = ''.obs;
  RxString passConfirm = ''.obs;
  RxBool isOldPassObsecure = true.obs;
  RxBool isPassObsecure = true.obs;
  RxBool isConfirmPassObsecure = true.obs;
  RxString gender = ''.obs;
  RxString vehiclePlate = ''.obs;
  RxString licenseExpiry = ''.obs;
  RxInt vehicleModelYear = 0.obs;
  Rx<File> avatar = File('').obs;
  Rx<File> carPhoto = File('').obs;
  RxBool isCarPhotoUpdated = false.obs;
  RxBool isFrontPhotoUpdated = false.obs;
  RxBool isBackPhotoUpdated = false.obs;
  Rx<File> frontLicensePhoto = File('').obs;
  Rx<File> backLicensePhoto = File('').obs;
  RxString vehicleMetalPlate = ''.obs;
  RxString vehicleManufactureYear = ''.obs;
  RxString licenseExpiryDate = ''.obs;
  RxBool driverNewPhoto = false.obs;
  Rx<int> vehicleId = 1.obs;
  Rx<int> vehicleTypeId = 1.obs;

  changeCarPhoto(String path) {
    carPhoto.value = File(path);
    isCarPhotoUpdated.value = true;
    carPhoto.refresh();
    isCarPhotoUpdated.refresh();
  }

  changeFrontPhoto(String path) {
    frontLicensePhoto.value = File(path);
    isFrontPhotoUpdated.value = true;
    frontLicensePhoto.refresh();
    isFrontPhotoUpdated.refresh();
  }

  changeBackPhoto(String path) {
    backLicensePhoto.value = File(path);
    isBackPhotoUpdated.value = true;
    backLicensePhoto.refresh();
    isBackPhotoUpdated.refresh();
  }

  updateProfileData() async {
    Ui.loadingDialog();
    Map<String, dynamic>? data = await provider.postUpdateProfile(
      name: fullNameController.text,
      email: emailController.text,
      birthDate: birthDateController.text,
      avatar: avatar.value,
      gender: gender.value,
      vehicleCategoryId: vehicleId.value,
      vehicleTypeId: vehicleTypeId.value,
      carPhoto: carPhoto.value,
      frontLicense: frontLicensePhoto.value,
      backLicense: backLicensePhoto.value,
      vehicleMetalPlate: vehiclePlateController.text,
      vehicleManufactureYear: vehicleModelYearController.text,
      licenceExpiryDate: licenseExpiryController.text,
    );

    if (data != null) {
      Get.back();
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          Get.back();
          appServices.profileModel.value = data['data'] as ProfileModel;
          appServices.saveUserImage(
              appServices.profileModel.value.data!.driver!.driverPhoto!);
          appServices
              .saveUserName(appServices.profileModel.value.data!.driver!.name!);
          Ui.successGetBar(message: appServices.profileModel.value.message!);
        } else {
          GlobalResponseModel model = data['data'] as GlobalResponseModel;
          Ui.errorGetBar(message: model.message!);
        }
      }
    } else {
      Get.back();
      Ui.errorGetBar(message: 'Internal Server Error'.tr);
    }
  }

  RxBool isProfileLoading = false.obs;
  Rx<ProfileModel> profile = ProfileModel().obs;
  getProfile() async {
    isProfileLoading.value = true;
    Map<String, dynamic>? data = await provider.getProfile();

    if (data != null) {
      isProfileLoading.value = false;
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          profile.value = data['data'] as ProfileModel;
          vehicleId.value = (data['data'] as ProfileModel)
              .data!
              .driver!
              .vehicle!
              .category!
              .id!;
          gender.value =
              (data['data'] as ProfileModel).data!.driver!.gender ?? 'male';
          if ((data['data'] as ProfileModel).data!.driver!.vehicle!.type !=
              null) {
            vehicleTypeId.value =
                (data['data'] as ProfileModel).data!.driver!.vehicle!.type!.id!;
          }
          fullNameController.text =
              (data['data'] as ProfileModel).data!.driver!.name!;
          emailController.text =
              (data['data'] as ProfileModel).data!.driver!.email!;
          birthDateController.text =
              (data['data'] as ProfileModel).data!.driver!.birthDate ?? '';
          licenseExpiryController.text = (data['data'] as ProfileModel)
              .data!
              .driver!
              .vehicle!
              .licenseExpiryDate!;
          vehicleModelYearController.text = (data['data'] as ProfileModel)
              .data!
              .driver!
              .vehicle!
              .vehicleManufactureYear!;
          vehiclePlate.value = (data['data'] as ProfileModel)
              .data!
              .driver!
              .vehicle!
              .vehicleMetalPlate!;
          vehiclePlateController.text = (data['data'] as ProfileModel)
              .data!
              .driver!
              .vehicle!
              .vehicleMetalPlate!;
          authController.getVehiclesType(vehicleId.value);
          isCarPhotoUpdated.value = false;
          isFrontPhotoUpdated.value = false;
          isBackPhotoUpdated.value = false;
        } else {
          NoDataResponseModel model = data['data'] as NoDataResponseModel;
          Ui.errorGetBar(message: model.message!.tr);
        }
      }
    } else {
      isProfileLoading.value = false;
      Ui.errorGetBar(message: 'Internal Server Error'.tr);
    }
  }

  // ANCHOR ----->  Forget Password Function
  resetPassword() async {
    Ui.loadingDialog();
    Get.log("Phooooooooooooone :: ${appServices.userPhone.value}");
    Map<String, dynamic>? data = await provider.postResetPassword(
        oldPassword.value, password.value, password.value);
    if (data == null) {
      Get.back();
      Ui.errorGetBar(message: 'Internal Server Error'.tr);
    } else {
      Get.back();
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          Get.back();
          Ui.successGetBar(message: 'password changed successfully'.tr);
        } else {
          Ui.errorGetBar(
              message: (data['data'] as NoDataResponseModel).message!);
        }
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
    getProfile();
  }

  @override
  void onClose() {
    super.onClose();
    birthDateController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    licenseExpiryController.dispose();
    vehiclePlateController.dispose();
    vehicleModelYearController.dispose();
    passworfController.dispose();
  }
}
