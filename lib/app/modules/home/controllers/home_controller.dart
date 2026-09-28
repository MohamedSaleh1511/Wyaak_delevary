import 'dart:async';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wayaak_delivery/app/core/enums/enums.dart';
import 'package:wayaak_delivery/app/core/theme/theme.dart';
import 'package:wayaak_delivery/app/data/models/delivery_cost_model/delivery_cost_model.dart';
import 'package:wayaak_delivery/app/data/models/goodealz_order_model/goodealz_order_model.dart';
import 'package:wayaak_delivery/app/data/models/no_data_response_model.dart';
import 'package:wayaak_delivery/app/data/models/profile_model/profile_model.dart';
import 'package:wayaak_delivery/app/data/services/app_services.dart';
import 'package:wayaak_delivery/app/data/services/socket_service.dart';
import 'package:wayaak_delivery/app/data/services/update_location_service.dart';
import 'package:wayaak_delivery/app/modules/home/providers/home_providers.dart';
import 'package:wayaak_delivery/app/modules/order_details/controllers/order_details_controller.dart';
import 'package:wayaak_delivery/app/modules/requests/controllers/requests_controller.dart';
import 'package:wayaak_delivery/app/modules/static_pages/controllers/static_pages_controller.dart';
import 'package:wayaak_delivery/app/modules/support/controllers/support_controller.dart';
import 'package:wayaak_delivery/app/routes/app_routes.dart';

import '../../../core/helpers/notification_helper.dart';

class HomeController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final StaticPagesController staticController =
      Get.find<StaticPagesController>();
  final RequestsController requestsController = Get.find<RequestsController>();
  final OrderDetailsController orderDetailsController =
      Get.find<OrderDetailsController>();

  Rx<RequestType> requestType = RequestType.wayaak.obs;

  final PageController homePageController = PageController(initialPage: 0);

  Rx<LatLng> currentPosition = const LatLng(0.0, 0.0).obs;

  final SupportController supportController = Get.find<SupportController>();
  final SocketServices socketServices = Get.find<SocketServices>();
  final AppServices appServices = Get.find<AppServices>();
  final UpdateLocationService updateLocationServices =
      Get.find<UpdateLocationService>();
  final HomeProviders provider = Get.find<HomeProviders>();

  final GlobalKey<FormState> amountFormKey = GlobalKey<FormState>();
  final TextEditingController priceController = TextEditingController();

  RxBool isAccepted = false.obs;

  Future<void> addDeliveryCost(String orderNum, String price) async {
    Ui.loadingDialog();
    Map<String, dynamic>? data =
        await provider.postAddCost(orderNum: orderNum, price: price);
    socketServices.broadcastAuthLoading.value = false;
    if (data != null) {
      if (data.containsKey('error')) {
        Get.back();
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          Get.back();
          Get.back();
          Get.back();
          Ui.successGetBar(message: "Cost has been sent");
          Get.back();
          priceController.text = '';
          Get.toNamed(Routes.waiting);
        } else if (data['code'] == 403 ||
            data['code'] == 404 ||
            data['code'] == 400) {
          Get.back();
          Ui.errorGetBar(message: data['data']['message']);
        } else {
          Get.back();
          Ui.errorGetBar(message: 'error occured');
        }
      }
    } else {
      Get.back();
      Ui.errorGetBar(message: 'error occured');
    }
  }

  getTheNotificationData() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    return initialMessage;
  }

  RxString minCost = ''.obs;
  RxString maxCost = ''.obs;
  RxString urgent = ''.obs;

  Future<void> getDeliveryCost(String orderNum, double distance) async {
    Ui.loadingDialog();
    Map<String, dynamic>? data = await provider.getDeliveryCostRestrictions(
      orderNum: orderNum,
      distance: distance,
    );
    Get.back();
    if (data != null) {
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          minCost.value = (data['data'] as DeliveryCostModel).data!.minCost!;
          maxCost.value = (data['data'] as DeliveryCostModel).data!.maxCost!;
          urgent.value = (data['data'] as DeliveryCostModel).data!.urgent!;
        }
      }
    }
  }

  // ANCHOR ----->  Log out Function
  logout() async {
    Ui.loadingDialog();
    await provider.postLogout();

    Get.back();
    Get.back();
    Get.offAllNamed(Routes.login);
    appServices.removeUserData();
  }

// ANCHOR ----->  Log out Function
  deleteAccount() async {
    Ui.loadingDialog();
    Map<String, dynamic>? data = await provider.deleteAccount();
    if (data!['data'] == null) {
      Get.back();
      Ui.errorGetBar(
          message: 'Error has been occured, Please try again later later'.tr);
    } else {
      Get.back();
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          Get.offAllNamed(Routes.login);
        } else {
          Ui.errorGetBar(
              message:
                  'Error has been occured, Please try again later later'.tr);
        }
      }
    }
  }

// ANCHOR ----->  Log out Function
  switchNotification(bool val) async {
    Map<String, dynamic>? data = await provider.changeNotification(val);
    if (data!['data'] == null) {
    } else {
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          appServices.saveNotifiable(val);
        } else {
          Ui.errorGetBar(message: 'Error in changing the status'.tr);
        }
      }
    }
  }

  RxBool updateLocationLoading = false.obs;

// ANCHOR ----->  Upda Function
  updateLocation(double latitude, double longitude) async {
    updateLocationLoading.value = true;
    Map<String, dynamic>? data =
        await provider.updateLocation(latitude, longitude);
    if (data!['data'] == null) {
      updateLocationLoading.value = false;
    } else {
      updateLocationLoading.value = false;
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          appServices.profileModel.value = data['data'] as ProfileModel;
        }
      }
    }
  }

// ANCHOR ----->  Upda Function
  chooseGoodealzOrder(String orderNum) async {
    Ui.loadingDialog();
    Map<String, dynamic>? data =
        await provider.getChooseGoodealzOrder(orderNum: orderNum);
    if (data == null) {
      Get.back();
      Ui.errorGetBar(message: 'Internal Server Error');
    } else {
      Get.back();
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          appServices.goodealzOrderModel.value =
              data['data'] as GoodealzOrderModel;
          appServices.orderNum.value =
              (data['data'] as GoodealzOrderModel).data!.orderNum!;
          Get.back();
          Get.toNamed(Routes.goodealzDetails);
          Ui.successGetBar(message: 'This Order is yours'.tr);
        } else {
          Ui.errorGetBar(
              message: '${(data['data'] as NoDataResponseModel).message}');
        }
      }
    }
  }

  getProfileData() async {
    appServices.isProfileLoading.value = true;
    Map<String, dynamic>? data = await provider.getProfile();

    if (data != null) {
      appServices.isProfileLoading.value = false;
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          appServices.profileModel.value = data['data'] as ProfileModel;
        } else {
          Ui.errorGetBar(message: 'error occured on getting profile data');
        }
      }
    } else {
      appServices.isProfileLoading.value = false;
      Ui.errorGetBar(message: 'error occured');
    }
  }

  handleSocket() async {
    await socketServices.requestSocketConnection(appServices.userId.value);
    Future.delayed(const Duration(milliseconds: 800), () {
      socketServices.subscribe('private-new-order.${appServices.userId.value}');
    });
  }

  @override
  void onReady() async {
    super.onReady();
    RemoteMessage? message = await getTheNotificationData();
    if (message != null) {
      log('Initial Message Received: ${message.data}');
      NotificationsHelper.handleNotificationCallback(message);
    }
    handleSocket();
    getProfileData();
    updateLocationServices.startPolling();
  }

  @override
  void onClose() {
    super.onClose();
    socketServices
        .unsubscribeChannel('private-new-order.${appServices.userId.value}');
  }
}
