import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wayaak_delivery/app/core/enums/enums.dart';
import 'package:wayaak_delivery/app/core/helpers/helpers.dart';
import 'package:wayaak_delivery/app/data/constants/constants.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
import 'package:wayaak_delivery/app/data/models/goodealz_order_model/goodealz_order_model.dart';
import 'package:wayaak_delivery/app/data/models/profile_model/profile_model.dart';
import 'package:wayaak_delivery/app/data/providers/shared_prefs.dart';

class AppServices extends GetxService {
  @override
  onInit() {
    super.onInit();
    getAccessToken();
    getUserId();
    getUserName();
    getUserImage();
    getUserPhone();
    // getNotificationOn();
    getfirsttime();
    getUserCurrency();
    getNotifiable();
  }

  /*--------------------------------------------------------------------------*/
  /*------------------------------  Variables  -------------------------------*/
  /*--------------------------------------------------------------------------*/

  Rx<GoodealzOrderModel> goodealzOrderModel = GoodealzOrderModel().obs;

  Rx<OtpType> otpType = OtpType.register.obs;

  RxBool bgNotification = false.obs;

  RxString countryCode = "EG".obs;

  RxString questionId = RxString('');

  // RxBool notificationsOn = RxBool(true);

  Rx<RegisterType> registerType = RegisterType.normal.obs;

  RxBool isProfileLoading = false.obs;
  Rx<ProfileModel> profileModel = ProfileModel().obs;

  Rx<RequestType> requestType = RequestType.wayaak.obs;
  RxString orderNum = ''.obs;

  RxString accessToken = RxString('');
  RxBool userNotifiable = RxBool(true);
  RxString userName = RxString('');
  RxString userImage = RxString('');
  RxString userCurrencyCode = RxString('');
  RxString userPhone = RxString('');
  RxInt userId = RxInt(0);
  RxString? pinCode;
  RxBool isFirstTime = true.obs;

  LatLng getDriverLocationFromString(String location) {
    RegExp regExp = RegExp(r'-?\d+(\.\d+)?');

    Iterable<RegExpMatch> matches = regExp.allMatches(location);

    List<double> numbers =
        matches.map((match) => double.parse(match.group(0)!)).toList();

    return LatLng(numbers[0], numbers[1]);
  }

  Future<Position> getCurrentLocation() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      return await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ));
    } else {
      await Permission.location.request();
      return await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ));
    }
  }

  Rx<Position> currentLocation = Position(
    longitude: 13.0,
    latitude: 13.0,
    timestamp: DateTime.now(),
    accuracy: 0.0,
    altitude: 0.0,
    heading: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0,
    altitudeAccuracy: 0.0,
    headingAccuracy: 0.0,
  ).obs;

  Future<void> setCurrentLocation() async {
    currentLocation.value = await getCurrentLocation();
    log('Current location : ${currentLocation.value}');
    await getPlaceMark();
  }

  Future<void> getPlaceMark() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        currentLocation.value.latitude, currentLocation.value.longitude);
    countryCode.value = placemarks[0].isoCountryCode!;
    saveCurrencyCode(getCurrencyCode(placemarks[0].isoCountryCode!)!);
  }

  /*--------------------------------------------------------------------------*/
  /*-------------------------  Control Toggle Bars  --------------------------*/
  /*--------------------------------------------------------------------------*/
  PageController pageController = PageController(initialPage: 0);
  RxInt currentPage = 0.obs;

  animateToPage(int page) {
    pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  pickImage(VoidCallback onCameraTap, VoidCallback onGalleryTap) async {
    Get.defaultDialog(
      title: 'Select Image'.tr,
      backgroundColor: Colors.white,
      titleStyle: Get.textTheme.titleMedium!.copyWith(
        color: Get.theme.primaryColor,
        fontWeight: FontWeight.bold,
        fontFamily: (Get.locale == const Locale('ar')) ? 'Almarai' : 'Poppin',
      ),
      middleText: 'Select an image from your device'.tr,
      middleTextStyle: Get.textTheme.bodyMedium!.copyWith(
        color: Colors.grey,
        fontFamily: (Get.locale == const Locale('ar')) ? 'Almarai' : 'Poppin',
      ),
      titlePadding: const EdgeInsets.all(20),
      actions: [
        TextButton(
          onPressed: onCameraTap,
          child: 'Camera'.tr.button(color: Constants.grey),
        ),
        TextButton(
          onPressed: onGalleryTap,
          child: 'Gallery'.tr.button(color: Constants.grey),
        ),
      ],
    );
  }

  /*--------------------------------------------------------------------------*/
  /*---------------------------  Save Functions  -----------------------------*/
  /*--------------------------------------------------------------------------*/

  void setIsFirstTime(bool val) async {
    isFirstTime = val.obs;
    SharedPrefsHelper.storeisFirstTime(val);
  }

  void saveAccessToken(String token) {
    accessToken = token.obs;
    SharedPrefsHelper.saveApiKeyToPrefs(token);
  }

  void saveNotifiable(bool notifiable) {
    userNotifiable = notifiable.obs;
    SharedPrefsHelper.saveUserNotifiable(notifiable);
  }

  void saveUserName(String name) {
    userName = name.obs;
    SharedPrefsHelper.saveUserName(name);
  }

  void saveUserImage(String image) {
    userImage = image.obs;
    SharedPrefsHelper.saveUserImg(image);
  }

  void saveCurrencyCode(String code) {
    userCurrencyCode = code.obs;
    SharedPrefsHelper.storeCurrencyCode(code);
  }

  void saveUserPhone(String phone) {
    userPhone = phone.obs;
    SharedPrefsHelper.saveUserPhone(phone);
  }

  void saveUserId(int id) {
    userId = id.obs;
    SharedPrefsHelper.saveUserIdToPrefs(id);
  }

  // void saveNotificationOn(bool status) {
  //   notificationsOn = status.obs;
  //   SharedPrefsHelper.saveNotificationStatus(status);
  // }

  /*--------------------------------------------------------------------------*/
  /*----------------------------  Get Functions  -----------------------------*/
  /*--------------------------------------------------------------------------*/

  void getAccessToken() async {
    String? data = await SharedPrefsHelper.getApiTokenFromPrefs();
    if (data != null) {
      accessToken = data.obs;
      debugPrint('tokennnnnnnnnnnnnnnnnn :: $accessToken');
    }
  }

  void getNotifiable() async {
    bool? data = await SharedPrefsHelper.getUserNotifiable();
    if (data != null) {
      userNotifiable = data.obs;
      debugPrint('tokennnnnnnnnnnnnnnnnn :: $userNotifiable');
    }
  }

  void getUserName() async {
    String? data = await SharedPrefsHelper.getUserName();
    if (data != null) {
      userName = data.obs;
      debugPrint('Naaaaaaaaaaaaaaaaaame :: $userName');
    }
  }

  void getUserImage() async {
    String? data = await SharedPrefsHelper.getUserImg();
    if (data != null) {
      userImage = data.obs;
      debugPrint('Imaaaaaaaaaaaaaaaaage :: $userImage');
    }
  }

  void getUserCurrency() async {
    String? data = await SharedPrefsHelper.getCurrencyCode();
    if (data != null) {
      userCurrencyCode = data.obs;
      debugPrint('Currenccccccccccyyyyy Code :: $userCurrencyCode');
    }
  }

  void getUserPhone() async {
    String? data = await SharedPrefsHelper.getUserPhone();
    if (data != null) {
      userPhone = data.obs;
      debugPrint('Imaaaaaaaaaaaaaaaaage :: $userPhone');
    }
  }

  void getUserId() async {
    int? data = await SharedPrefsHelper.getUserIdFromPrefs();
    if (data != null) {
      userId = data.obs;
      debugPrint('iddddddddddddddddddddddddd :: $userId');
    }
  }

  // void getNotificationOn() async {
  //   bool? data = await SharedPrefsHelper.getNotificationStatus();
  //   if (data != null) {
  //     notificationsOn = data.obs;
  //   }
  // }

  void getfirsttime() async {
    bool? data = await SharedPrefsHelper.getIsFirstTime();
    if (data != null) {
      isFirstTime = data.obs;
    }
  }

  /*--------------------------------------------------------------------------*/
  /*--------------------------  Remove User Data  ----------------------------*/
  /*--------------------------------------------------------------------------*/

  void removeUserData() async {
    accessToken.value = '';
    userId.value = 0;
    userName.value = '';
    userPhone.value = '';
    userImage.value = '';
    userNotifiable.value = true;
    SharedPrefsHelper.removeToken();
    SharedPrefsHelper.removeUserId();
    SharedPrefsHelper.removeUserName();
    SharedPrefsHelper.removeUserPhone();
    SharedPrefsHelper.removeUserImg();
    SharedPrefsHelper.removeNotificationStatus();
    SharedPrefsHelper.removeCurrency();
    SharedPrefsHelper.removeUserNotifiable();
  }
}
