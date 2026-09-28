import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pinput/pinput.dart';
import 'package:wayaak_delivery/app/core/enums/enums.dart';
import 'package:wayaak_delivery/app/core/theme/theme.dart';
import 'package:wayaak_delivery/app/core/widgets/global_button.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
import 'package:wayaak_delivery/app/data/models/chat_messages_model/chat_messages_model.dart';
import 'package:wayaak_delivery/app/data/models/chat_messages_model/messages.dart';
import 'package:wayaak_delivery/app/data/models/goodealz_details_model/goodealz_details_model.dart';
import 'package:wayaak_delivery/app/data/models/goodealz_requests_model/datum.dart';
import 'package:wayaak_delivery/app/data/models/no_data_response_model.dart';
import 'package:wayaak_delivery/app/data/models/order_details_model/order_details_model.dart';
import 'package:wayaak_delivery/app/data/models/requests_model/datum.dart';
import 'package:wayaak_delivery/app/data/services/app_services.dart';
import 'package:wayaak_delivery/app/data/services/socket_service.dart';
import 'package:wayaak_delivery/app/modules/chat/controllers/chat_controller.dart';
import 'package:wayaak_delivery/app/modules/order_details/providers/order_details_provider.dart';
import 'package:wayaak_delivery/app/routes/app_routes.dart';

class OrderDetailsController extends GetxController {
  final OrderDetailsProvider provider = Get.find<OrderDetailsProvider>();
  final AppServices appServices = Get.find<AppServices>();
  final SocketServices socketServices = Get.find<SocketServices>();
  final ChatController chatController = Get.find<ChatController>();

  Rx<LatLng> driverLiveLocation = const LatLng(0.0, 0.0).obs;

  RxBool isOrderDetailsLoading = false.obs;
  Rx<RequestsDatum> orderDetailsData = RequestsDatum().obs;
  getOrderDetails() async {
    if (appServices.orderNum.value.isNotEmpty) {
      isOrderDetailsLoading.value = true;
      Map<String, dynamic>? data =
          await provider.getOrderDetails(appServices.orderNum.value);
      isOrderDetailsLoading.value = false;
      if (data != null) {
        if (data['code'] == 200) {
          orderDetailsData.value = (data['data'] as OrderDetailsModel).data!;
        }
      }
    }
  }

  RxBool isGoodealzDetailsLoading = false.obs;
  Rx<GoodealzDatum> goodealzDetailsData = GoodealzDatum().obs;
  getGoodealzDetails() async {
    if (appServices.orderNum.value.isNotEmpty) {
      isGoodealzDetailsLoading.value = true;
      Map<String, dynamic>? data =
          await provider.getGoodealzDetails(appServices.orderNum.value);
      isGoodealzDetailsLoading.value = false;
      if (data != null) {
        if (data.containsKey('error')) {
          Ui.errorGetBar(
              message: 'Connection Error, Check your network please'.tr);
        } else {
          if (data['code'] == 200) {
            goodealzDetailsData.value =
                (data['data'] as GoodealzDetailsModel).data!;
          }
        }
      }
    }
  }

  updateDriverStatus(bool iswayaakOrder) async {
    Ui.loadingDialog();
    Map<String, dynamic>? data =
        await provider.updateOrderStatus(appServices.orderNum.value);
    Get.back();
    if (data != null) {
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          Ui.successGetBar(
              message: iswayaakOrder
                  ? 'Status updated, wait for the OTP from the user'.tr
                  : 'Order delivered successfully'.tr);
          isOtpSent.value = true;
          isOtpSent.refresh();
        } else {
          Ui.errorGetBar(message: 'error occured in order details');
        }
      }
    } else {
      Ui.errorGetBar(message: 'error occured in order details');
    }
  }

  RxBool isOtpSent = false.obs;
  final TextEditingController pinController = TextEditingController();

  deliveryConfirmationFlow() async {
    Get.generalDialog(
      transitionDuration: const Duration(milliseconds: 700),
      transitionBuilder: (context, animation, secondaryAnimation, child) =>
          child.dialogTransition(animation),
      pageBuilder: (context, animation, secondaryAnimation) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 15),
              "Add delivered code".tr.titleSmall(),
              const SizedBox(height: 25),
              Center(
                child: Pinput(
                  controller: pinController,
                  onCompleted: (value) {},
                  onSubmitted: (value) {},
                  length: 6,
                  submittedPinTheme: PinTheme(
                    height: 50,
                    width: 50,
                    textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(100)),
                      border:
                          Border.all(color: const Color(0xFFB5B5B5), width: 2),
                    ),
                  ),
                  errorPinTheme: PinTheme(
                    height: 50,
                    width: 50,
                    textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Get.theme.colorScheme.error,
                        fontWeight: FontWeight.bold),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border:
                          Border.all(color: const Color(0xFFB5B5B5), width: 2),
                    ),
                  ),
                  defaultPinTheme: PinTheme(
                    height: 50,
                    width: 50,
                    textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border:
                          Border.all(color: const Color(0xFFB5B5B5), width: 2),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              GlobalButton(
                onTap: () {
                  if (pinController.text.isEmpty) {
                    Ui.errorGetBar(message: "Please enter your PIN".tr);
                  } else {
                    confirmDelivered();
                  }
                },
                text: "Confirm".tr,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }

  confirmDelivered() async {
    Ui.loadingDialog();
    Map<String, dynamic>? data = await provider.confirmDelivery(
      appServices.orderNum.value,
      pinController.text,
    );
    Get.back();
    if (data != null) {
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
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
                        'Congratulations for compeleting your trip successfully'
                            .tr
                            .body(color: Colors.black, center: true),
                  ),
                  const SizedBox(height: 20),
                  GlobalButton(
                    onTap: () {
                      Get.offAllNamed(Routes.main);
                      // Get.toNamed(Routes.otpCode);
                    },
                    text: "Done".tr,
                    width: Get.width * 0.75,
                  ),
                  const SizedBox(height: 30),
                ],
              ).decorate(width: Get.width * 0.9),
            ),
          );
        } else {
          Ui.errorGetBar(message: 'error occured in order details');
        }
      }
    } else {
      Ui.errorGetBar(message: 'error occured in order details');
    }
  }

  RxInt chatId = 0.obs;
  Future getChatMessages(int userId) async {
    socketServices.isChatsMessagesLoading.value = true;
    Map<String, dynamic>? data = await provider.getChatWithDriverId(userId);
    if (data != null) {
      socketServices.isChatsMessagesLoading.value = false;
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          socketServices.messages.value = List.generate(
            (data['data'] as ChatMessagesModel).data!.messages!.length,
            (index) => Messages(
              status: MesssageStatus.sent,
              isAttachmentPath: false,
              message:
                  (data['data'] as ChatMessagesModel).data!.messages![index],
            ),
          );
          chatId.value = (data['data'] as ChatMessagesModel).data!.id!;
        } else if (data['code'] == 404) {
          Ui.errorGetBar(
              message: (data['data'] as NoDataResponseModel).message!);
        } else {
          Ui.errorGetBar(message: 'error occured on getting chat messages');
        }
      }
    } else {
      socketServices.isChatsMessagesLoading.value = false;
      Ui.errorGetBar(message: 'error occured on getting chat messages');
    }
  }

  Rx<Set<Polyline>> polylines = Rx({});

  RxBool orderTracked = false.obs;

  drawPolylines({required LatLng loc1, required LatLng loc2}) async {
    polylines.value.add(Polyline(
      polylineId: PolylineId(loc1.toString()),
      visible: true,
      width: 5,
      points: [
        loc1,
        loc2,
      ],
      color: Colors.deepPurpleAccent,
    ));
  }

  @override
  void onReady() {
    super.onReady();
    getOrderDetails();
  }
}
