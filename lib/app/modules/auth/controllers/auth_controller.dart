import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak_delivery/app/core/enums/enums.dart';
import 'package:wayaak_delivery/app/core/theme/theme.dart';
import 'package:wayaak_delivery/app/core/widgets/global_button.dart';
import 'package:wayaak_delivery/app/core/widgets/global_phone_field.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
import 'package:wayaak_delivery/app/data/models/auth/signup_model.dart';
import 'package:wayaak_delivery/app/data/models/auth/signup_social_model.dart';
import 'package:wayaak_delivery/app/data/models/global_response_model.dart';
import 'package:wayaak_delivery/app/data/models/login_response_model/login_response_model.dart';
import 'package:wayaak_delivery/app/data/models/no_data_response_model.dart';
import 'package:wayaak_delivery/app/data/models/vehicles_category_model/datum.dart';
import 'package:wayaak_delivery/app/data/models/vehicles_category_model/vehicles_category_model.dart';
import 'package:wayaak_delivery/app/data/services/app_services.dart';
import 'package:wayaak_delivery/app/modules/auth/providers/auth_provider.dart';
import 'package:wayaak_delivery/app/modules/static_pages/controllers/static_pages_controller.dart';
import 'package:wayaak_delivery/app/routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthProviders authProvider = Get.find<AuthProviders>();
  final AppServices appServices = Get.find<AppServices>();
  final StaticPagesController staticPagesController =
      Get.find<StaticPagesController>();
  RxString otpCode = ''.obs;

  // ANCHOR -----> Form Keys
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signup2FormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> forgetPassFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> resetPassFormKey = GlobalKey<FormState>();

  // ANCHOR -----> Text Editing Controllers
  final TextEditingController passController = TextEditingController();
  final TextEditingController passSignupController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController licenseExpiryController = TextEditingController();
  final TextEditingController vehicleModelYearController =
      TextEditingController();

  // ANCHOR -----> Form Fields
  RxString fullName = ''.obs;
  RxString email = ''.obs;
  RxString password = ''.obs;
  RxString passConfirm = ''.obs;
  RxString phone = ''.obs;
  RxString latitude = ''.obs;
  RxString longitude = ''.obs;
  Rx<File> driverPhoto = File('').obs;
  Rx<File> carPhoto = File('').obs;
  Rx<File> frontLicence = File('').obs;
  Rx<File> backLicence = File('').obs;
  Rx<int> vehicleCategoryId = 1.obs;
  Rx<int> vehicleTypeId = 1.obs;
  RxString deviceToken = ''.obs;
  RxInt vehicleModelYear = 0.obs;
  RxString licenseExpiry = ''.obs;
  RxString vehicleMetalPlate = ''.obs;
  RxString socialId = ''.obs;
  RxString socialProvider = ''.obs;

  // ANCHOR ----->  Variables
  RxBool isChecked = false.obs;
  RxBool isPassObsecure = true.obs;
  RxBool isConfirmPassObsecure = true.obs;

  // FirebaseMessaging? firebaseMessaging = FirebaseMessaging.instance;

  // ANCHOR ----->  Register Function
  register() async {
    Ui.loadingDialog();

    Get.log('beginnnnnnnnnnnnnnnnnnnnnnnnnnnn');
    Get.log('Name : ${fullName.value}');
    Get.log('Email : ${email.value}');
    Get.log('Phone : ${phone.value}');
    Get.log('Longitude : ${longitude.value}');
    Get.log('Latitude : ${latitude.value}');

    Map<String, dynamic>? registerModel =
        await authProvider.postRegister(SignupRequestModel(
      name: fullName.value,
      password: password.value,
      phone: phone.value,
      email: email.value,
      latitude: latitude.value,
      longitude: longitude.value,
      driverPhoto: driverPhoto.value,
      vehiclePhoto: carPhoto.value,
      frontLicense: frontLicence.value,
      backLicense: backLicence.value,
      vehicleCategoryId: vehicleCategoryId.value,
      vehicleManufactureYear: vehicleModelYear.value,
      licenseExpiryDate: licenseExpiry.value,
      vehicleMetalPlate: vehicleMetalPlate.value,
      vehicleTypeId: vehicleTypeId.value,
    ));
    Get.log('enddddddddddddddddddddddddddddd');
    if (registerModel == null) {
      Get.back();
      Ui.errorGetBar(message: 'Internal Server Error'.tr);
    } else {
      if (registerModel.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (registerModel['code'] == 200) {
          Get.back();
          Get.generalDialog(
            transitionDuration: const Duration(milliseconds: 700),
            transitionBuilder:
                (context, animation, secondaryAnimation, child) =>
                    child.dialogTransition(animation),
            pageBuilder: (context, animation, secondaryAnimation) =>
                UnconstrainedBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 30),
                  'successfully'.iconColored(size: Get.width * 0.45),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child:
                        'Thanks for registration, We will send text message notification for verifying your phone'
                            .tr
                            .bodyMedium(center: true),
                  ),
                  const SizedBox(height: 20),
                  GlobalButton(
                    onTap: () {
                      Get.back();
                      Get.toNamed(Routes.otpCode);
                    },
                    text: "Enter OTP".tr,
                    width: Get.width * 0.75,
                  ),
                  const SizedBox(height: 30),
                ],
              ).decorate(width: Get.width * 0.9),
            ),
          );
        } else {
          Get.back();
          if (registerModel['code'] == 400) {
            GlobalResponseModel errorModel =
                registerModel['data'] as GlobalResponseModel;
            Ui.errorGetBar(message: errorModel.message!.tr);
          } else {
            Ui.errorGetBar(message: 'Internal Server Error'.tr);
          }
        }
      }
    }
  }

  // ANCHOR ----->  Register Function
  registerSocial() async {
    Ui.loadingDialog();

    Get.log('beginnnnnnnnnnnnnnnnnnnnnnnnnnnn');
    Get.log('Name : ${fullName.value}');
    Get.log('Email : ${email.value}');
    Get.log('Phone : ${phone.value}');
    Get.log('Longitude : ${longitude.value}');
    Get.log('Latitude : ${latitude.value}');

    Map<String, dynamic>? registerModel =
        await authProvider.postSocialRegister(SignupSocialRequestModel(
      name: fullName.value,
      phone: phone.value,
      email: email.value,
      driverPhoto: driverPhoto.value,
      vehiclePhoto: carPhoto.value,
      frontLicense: frontLicence.value,
      backLicense: backLicence.value,
      vehicleCategoryId: vehicleCategoryId.value,
      vehicleManufactureYear: vehicleModelYear.value,
      licenseExpiryDate: licenseExpiry.value,
      vehicleMetalPlate: vehicleMetalPlate.value,
      vehicleTypeId: vehicleTypeId.value,
      provider: socialProvider.value,
      socialMediaId: socialId.value,
    ));
    Get.log('enddddddddddddddddddddddddddddd');
    if (registerModel == null) {
      Get.back();
      Ui.errorGetBar(message: 'Internal Server Error'.tr);
    } else {
      if (registerModel.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (registerModel['code'] == 200) {
          Get.back();
          Get.generalDialog(
            transitionDuration: const Duration(milliseconds: 700),
            transitionBuilder:
                (context, animation, secondaryAnimation, child) =>
                    child.dialogTransition(animation),
            pageBuilder: (context, animation, secondaryAnimation) =>
                UnconstrainedBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 30),
                  'successfully'.iconColored(size: Get.width * 0.45),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child:
                        'Thanks for registration, We will send text message notification for verifying your phone'
                            .tr
                            .bodyMedium(center: true),
                  ),
                  const SizedBox(height: 20),
                  GlobalButton(
                    onTap: () {
                      Get.back();
                      Get.toNamed(Routes.otpCode);
                    },
                    text: "Enter OTP".tr,
                    width: Get.width * 0.75,
                  ),
                  const SizedBox(height: 30),
                ],
              ).decorate(width: Get.width * 0.9),
            ),
          );
        } else {
          Get.back();

          GlobalResponseModel errorModel =
              registerModel['data'] as GlobalResponseModel;
          Ui.errorGetBar(message: errorModel.message!.tr);
        }
      }
    }
  }

  // ANCHOR ----->  Social Register Function
  socialAuth({
    String? name,
    String? emaill,
    String? socialMediaId,
    String? provider,
  }) async {
    Ui.loadingDialog();
    Map<String, dynamic>? registerModel = await authProvider.postSocialLogin(
      socialMediaId: socialMediaId,
      provider: provider,
    );
    if (registerModel == null) {
      Get.back();
      Ui.errorGetBar(message: 'Internal Server Error'.tr);
    } else {
      if (registerModel.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (registerModel['code'] == 200) {
          Get.back();
          LoginResponseModel loginModel =
              registerModel['data'] as LoginResponseModel;
          Ui.successGetBar(message: 'login success'.tr);
          Get.offNamedUntil(Routes.main, (route) => false)!;
          if (remember.value) {
            appServices.saveAccessToken(loginModel.data!.accessToken!);
            appServices.saveUserId(loginModel.data!.driver!.id!);
            appServices.saveUserName(loginModel.data!.driver!.name!);
            appServices.saveUserImage(loginModel.data!.driver!.driverPhoto!);
            appServices.saveUserPhone(loginModel.data!.driver!.phone!);
            appServices
                .saveNotifiable(loginModel.data!.driver!.notifiable == 1);
          } else {
            appServices.accessToken.value = loginModel.data!.accessToken!;
            appServices.userName.value = loginModel.data!.driver!.name!;
            appServices.userImage.value = loginModel.data!.driver!.driverPhoto!;
            appServices.userPhone.value = loginModel.data!.driver!.phone!;
            appServices.userId.value = loginModel.data!.driver!.id!;
            appServices.userNotifiable.value =
                loginModel.data!.driver!.notifiable == 1;
          }
        } else if (registerModel['code'] == 404 ||
            registerModel['code'] == 403) {
          Get.back();
          Get.generalDialog(
            transitionDuration: const Duration(milliseconds: 700),
            transitionBuilder:
                (context, animation, secondaryAnimation, child) =>
                    child.dialogTransition(animation),
            pageBuilder: (context, animation, secondaryAnimation) => Dialog(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 30),
                  "Enter your phone number".tr.titleSmall(),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: GlobalPhoneField(
                      onChanged: (val) => phone.value = val.completeNumber,
                      onSaved: (val) {
                        phone.value = val!.completeNumber;
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  GlobalButton(
                    onTap: () async {
                      if (phone.value.isNotEmpty) {
                        driverPhoto.value = File('');
                        carPhoto.value = File('');
                        frontLicence.value = File('');
                        backLicence.value = File('');

                        passController.text = '';
                        passSignupController.text = '';
                        confirmPassController.text = '';
                        otpController.text = '';
                        licenseExpiryController.text = '';
                        vehicleModelYearController.text = '';

                        fullName.value = name!;
                        email.value = emaill!;

                        Get.back();
                        Ui.loadingDialog();
                        Get.back();
                        appServices.registerType.value = RegisterType.social;
                        Get.toNamed(Routes.setLocation);
                      }
                    },
                    text: 'sign up'.tr,
                    width: Get.width * 0.75,
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        } else if (registerModel['code'] == 400 ||
            registerModel['code'] == 403 ||
            registerModel['code'] == 401) {
          Get.back();
          Ui.errorGetBar(message: registerModel['data'].message.toString().tr);
        } else {
          Get.back();
          Ui.errorGetBar(
              message:
                  'Error has been occured, Please try again later later'.tr);
        }
      }
    }
  }

// ANCHOR ----->  Login Function
  RxBool remember = false.obs;
  RxBool terms = false.obs;
  login() async {
    Ui.loadingDialog();
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    Map<String, dynamic>? data = await authProvider.postLogin(
        phone.value, password.value, fcmToken ?? '');
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
          LoginResponseModel loginModel = data['data'] as LoginResponseModel;
          Ui.successGetBar(message: 'login success'.tr);
          Get.offNamedUntil(Routes.main, (route) => false)!;
          if (remember.value) {
            appServices.saveAccessToken(loginModel.data!.accessToken!);
            appServices.saveUserId(loginModel.data!.driver!.id!);
            appServices.saveUserName(loginModel.data!.driver!.name!);
            appServices.saveUserImage(loginModel.data!.driver!.driverPhoto!);
            appServices.saveUserPhone(loginModel.data!.driver!.phone!);
            appServices
                .saveNotifiable(loginModel.data!.driver!.notifiable == 1);
          } else {
            appServices.accessToken.value = loginModel.data!.accessToken!;
            appServices.userName.value = loginModel.data!.driver!.name!;
            appServices.userImage.value = loginModel.data!.driver!.driverPhoto!;
            appServices.userPhone.value = loginModel.data!.driver!.phone!;
            appServices.userId.value = loginModel.data!.driver!.id!;
            appServices.userNotifiable.value =
                loginModel.data!.driver!.notifiable == 1;
          }
        } else if (data['code'] == 400 ||
            data['code'] == 403 ||
            data['code'] == 401) {
          Ui.errorGetBar(message: data['data'].message.toString().tr);
        } else {
          Ui.errorGetBar(
              message:
                  'Error has been occured, Please try again later later'.tr);
        }
      }
    }
  }

  RxBool isvehicleCategoriesLoading = false.obs;
  RxList<VehicleCategoryDatum> vehicleCategoriesTypes =
      <VehicleCategoryDatum>[].obs;
  getVehiclesCategory() async {
    isvehicleCategoriesLoading.value = true;
    Map<String, dynamic>? data = await authProvider.getVehicleCategories();
    isvehicleCategoriesLoading.value = false;
    if (data != null) {
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          vehicleCategoriesTypes.value =
              (data['data'] as VehiclesCategoryModel).data!;
        } else {
          GlobalResponseModel model = (data['data'] as GlobalResponseModel);
          Ui.errorGetBar(message: model.message!.tr);
        }
      }
    } else {
      Ui.errorGetBar(message: 'Internal Server Error'.tr);
    }
  }

  RxBool isvehicleTypesLoading = false.obs;
  RxList<VehicleCategoryDatum> vehicleTypes = <VehicleCategoryDatum>[].obs;
  getVehiclesType(int vehicleCategoryId) async {
    isvehicleTypesLoading.value = true;
    Map<String, dynamic>? data =
        await authProvider.getVehicleTypes(vehicleCategoryId);
    isvehicleTypesLoading.value = false;
    if (data != null) {
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          vehicleTypes.value = (data['data'] as VehiclesCategoryModel).data!;
        } else {
          NoDataResponseModel model = (data['data'] as NoDataResponseModel);
          Ui.errorGetBar(message: model.message!.tr);
        }
      }
    } else {
      Ui.errorGetBar(message: 'Internal Server Error'.tr);
    }
  }

  // ANCHOR ----->  Verify OTP Function
  verifyOtp() async {
    Ui.loadingDialog();
    Map<String, dynamic>? data =
        await authProvider.postVerify(phone.value, otpCode.value);
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
          NoDataResponseModel loginModel = data['data'] as NoDataResponseModel;
          Get.offNamedUntil(Routes.login, (route) => false)!;
          Ui.successGetBar(message: loginModel.message!.tr);
        } else if (data['code'] == 400) {
          Ui.errorGetBar(message: data['data'].message.toString().tr);
        } else {
          Ui.errorGetBar(
              message: 'Error has been occured, Please try again later'.tr);
        }
      }
    }
  }

// ANCHOR ----->  Forget Password Function
  forgetPassword() async {
    Ui.loadingDialog();
    NoDataResponseModel? data = await authProvider
        .getForgetPassword(phone.value.replaceAll('+', '%2B'));
    if (data == null) {
      Get.back();
      Ui.errorGetBar(message: 'Internal Server Error'.tr);
    } else {
      if (data.status != 200) {
        Get.back();
        Get.log("message :: ${'${data.message}'.tr}");
        Get.log("message2 :: ${'Something went wrong.'.tr}");
        Ui.errorGetBar(message: data.message!.tr);
      } else {
        Get.back();
        appServices.otpType.value = OtpType.forgetPass;
        Get.toNamed(Routes.otpCode);
        Ui.successGetBar(message: 'code has been sent to your phone'.tr);
      }
    }
  }

// ANCHOR ----->  Forget Password Function
  resetCode() async {
    Ui.loadingDialog();
    Map<String, dynamic>? data =
        await authProvider.postCheckResetCode(phone.value, otpCode.value);

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
          Ui.successGetBar(message: 'code is success'.tr);
          Get.toNamed(Routes.resetPass);
        } else {
          Ui.errorGetBar(
              message: 'Error has been occured, Please try again later'.tr);
        }
      }
    }
  }

// ANCHOR ----->  Forget Password Function
  resetPassword() async {
    Ui.loadingDialog();
    Map<String, dynamic>? data = await authProvider.postResetPassword(
        phone.value, password.value, passConfirm.value);
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
          Ui.successGetBar(message: 'password changed successfully'.tr);
          Get.offAllNamed(Routes.login);
        } else {
          Ui.errorGetBar(
              message:
                  'Error has been occured, Please try again later later'.tr);
        }
      }
    }
  }

  RxList<int> modelYears = <int>[].obs;
  void generateYears() {
    int currentYear = DateTime.now().year;
    for (int year = 1990; year <= currentYear; year++) {
      modelYears.add(year);
    }
  }

  @override
  void onReady() {
    super.onReady();
    appServices.setCurrentLocation();
    getVehiclesCategory();
    generateYears();
  }
}
