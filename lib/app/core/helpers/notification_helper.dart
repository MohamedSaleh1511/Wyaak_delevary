import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wayaak_delivery/app/core/helpers/helpers.dart';
import 'package:wayaak_delivery/app/core/theme/theme.dart';
import 'package:wayaak_delivery/app/data/constants/constants.dart';
import 'package:wayaak_delivery/app/data/models/requests_model/datum.dart';
import 'package:wayaak_delivery/app/data/services/app_services.dart';
import 'package:wayaak_delivery/app/data/services/socket_service.dart';
import 'package:wayaak_delivery/app/modules/chat/controllers/chat_controller.dart';
import 'package:wayaak_delivery/app/modules/chat/providers/chat_providers.dart';
import 'package:wayaak_delivery/app/modules/home/controllers/home_controller.dart';
import 'package:wayaak_delivery/app/modules/home/widgets/goodealz_details_dialog.dart';
import 'package:wayaak_delivery/app/modules/home/widgets/request_details_dialog.dart';
import 'package:wayaak_delivery/app/routes/app_routes.dart';
import 'package:wayaak_delivery/main.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationsHelper {
  static Future<void> initialize() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationsSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.initialize(
      initializationsSettings,
      onDidReceiveNotificationResponse: (payload) async {
        log('On Message Clicked 1 ====> ${payload.payload!}');
        log('On Message Clicked 3 ====> ${jsonDecode(payload.payload!)}');

        Map<String, dynamic> data = jsonDecode(payload.payload!);

        if (data.isNotEmpty) {
          if (data['type'] == 'new-order') {
            Ui.loadingDialog();
            Get.find<AppServices>().orderNum.value =
                "${jsonDecode((data['order']))['order_num']}";
            RequestsDatum dataa =
                RequestsDatum.fromJson(jsonDecode((data['order'])));
            await Get.put(HomeController())
                .getDeliveryCost(
              dataa.orderNum!,
              double.parse(calculateDistance2(
                currentLoc: LatLng(
                  double.parse(dataa.currentLocation!.latitude!),
                  double.parse(dataa.currentLocation!.longitude!),
                ),
                destination: LatLng(
                  double.parse(dataa.destinationLocation!.latitude!),
                  double.parse(dataa.destinationLocation!.longitude!),
                ),
              ).toStringAsFixed(2)),
            )
                .then((v) {
              Get.back();
              Get.bottomSheet(
                BottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  backgroundColor: Colors.transparent,
                  enableDrag: true,
                  onClosing: () {},
                  builder: (context) => RequestDetailsDialog(order: dataa),
                ),
                enterBottomSheetDuration: const Duration(
                  milliseconds: 300,
                ),
                exitBottomSheetDuration: const Duration(
                  milliseconds: 300,
                ),
                isScrollControlled: true,
              );
            });
          } else if (data['type'] == 'new-goodealz-order') {
            Get.find<AppServices>().orderNum.value =
                "${jsonDecode((data['order']))['order_num']}";
            Ui.loadingDialog();
            await Get.find<HomeController>()
                .orderDetailsController
                .getGoodealzDetails();
            Get.back();

            Get.bottomSheet(
              BottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                backgroundColor: Colors.transparent,
                enableDrag: true,
                onClosing: () {},
                builder: (context) => GoodealzDetailsDialog(
                  order: Get.find<HomeController>()
                      .orderDetailsController
                      .goodealzDetailsData
                      .value,
                ),
              ),
              enterBottomSheetDuration: const Duration(
                milliseconds: 300,
              ),
              exitBottomSheetDuration: const Duration(
                milliseconds: 300,
              ),
              isScrollControlled: true,
            );
          } else if (data['type'] == 'chat') {
            Get.find<SocketServices>().chatChannelName.value =
                "private-chat.${data['chat_id']}";
            Get.find<SocketServices>()
                .subscribe("private-chat.${data['chat_id']}");
            Get.put(ChatController())
                .getChatMessages(int.parse(data['chat_id']));
            Get.toNamed(Routes.chatMessages, arguments: [
              data['sender_avatar'],
              data['sender_name'],
              int.parse(data['sender_id']),
              data['chat_id'],
            ]);
          } else if (data['type'] == 'confirm-withdrawel') {
            Get.toNamed(Routes.profits);
          } else if (data['type'] == 'assign-order') {
            Get.find<HomeController>().chooseGoodealzOrder(data['order_num']);
          } else {
            Get.toNamed(Routes.notification);
          }
        }
        return;
      },
    );
  }

  static AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
    enableLights: true,
    ledColor: Constants.primary,
    showBadge: true,
  );

  static show(RemoteMessage message) async {
    log('Notification Payload ==> ${message.toMap()}');
    log('Order Num ==> ${message.data['order_num']}');
    log('Notification Payload ==> ${message.toMap()}');
    log('Current Route ==> ${Get.currentRoute}');
    if ((Get.currentRoute == Routes.chatMessages &&
        message.data['type'] == 'chat')) {
    } else {
      if (message.data['type'] == 'chat') {
        Get.put(ChatController()).getAllChats();
      }
      await flutterLocalNotificationsPlugin.show(
        2,
        message.notification!.title,
        message.notification!.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            importance: Importance.max,
            priority: Priority.max,
            enableLights: true,
            category: AndroidNotificationCategory.message,
            ledColor: Constants.primary,
            audioAttributesUsage: AudioAttributesUsage.notification,
            ledOnMs: 2,
            ledOffMs: 2,
          ),
        ),
        payload: jsonEncode(message.data),
      );
    }

    switch (message.data['type']) {
      // case 'new-order':
      //   await Get.put<HomeController>(HomeController())
      //       .requestsController
      //       .getWayaakRequests();
      //   break;
      // case 'new-goodealz-order':
      //   await Get.put<HomeController>(HomeController())
      //       .requestsController
      //       .getGoodeelzRequests();
      //   break;
      case 'accept-offer':
        Get.find<AppServices>().orderNum.value = "${message.data['order_num']}";
        Get.put<HomeController>(HomeController())
            .orderDetailsController
            .getOrderDetails();
        Get.offNamed(Routes.orderDetails);
        break;
      case 'decline-offer':
        Get.offNamedUntil(Routes.main, (route) => false);
        break;
      default:
    }
  }

  static showLocalNotification(String title) async {
    await flutterLocalNotificationsPlugin.show(
      3,
      "Congratulations!".tr,
      'you have reached the destination'.tr,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          importance: Importance.max,
          priority: Priority.max,
          enableLights: true,
          category: AndroidNotificationCategory.message,
          ledColor: Constants.primary,
          audioAttributesUsage: AudioAttributesUsage.notification,
          ledOnMs: 2,
          ledOffMs: 2,
        ),
      ),
    );
  }

  static handleNotificationCallback(RemoteMessage message) async {
    Get.find<AppServices>().bgNotification.value = true;
    if (message.data.isNotEmpty) {
      if (message.data['type'] == 'new-order') {
        Ui.loadingDialog();
        Get.find<AppServices>().orderNum.value =
            "${jsonDecode((message.data['order']))['order_num']}";
        RequestsDatum dataa =
            RequestsDatum.fromJson(jsonDecode((message.data['order'])));
        await Get.put(HomeController())
            .getDeliveryCost(
          dataa.orderNum!,
          double.parse(
            calculateDistance2(
              currentLoc: LatLng(
                double.parse(dataa.currentLocation!.latitude!),
                double.parse(dataa.currentLocation!.longitude!),
              ),
              destination: LatLng(
                double.parse(dataa.destinationLocation!.latitude!),
                double.parse(dataa.destinationLocation!.longitude!),
              ),
            ).toStringAsFixed(2),
          ),
        )
            .then((v) {
          Get.back();
          Get.bottomSheet(
            BottomSheet(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              backgroundColor: Colors.transparent,
              enableDrag: true,
              onClosing: () {},
              builder: (context) => RequestDetailsDialog(order: dataa),
            ),
            enterBottomSheetDuration: const Duration(
              milliseconds: 300,
            ),
            exitBottomSheetDuration: const Duration(
              milliseconds: 300,
            ),
            isScrollControlled: true,
          );
        });
      } else if (message.data['type'] == 'new-goodealz-order') {
        Get.find<AppServices>().orderNum.value =
            "${jsonDecode((message.data['order']))['order_num']}";
        Ui.loadingDialog();
        await Get.find<HomeController>()
            .orderDetailsController
            .getGoodealzDetails();
        Get.back();

        Get.bottomSheet(
          BottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            backgroundColor: Colors.transparent,
            enableDrag: true,
            onClosing: () {},
            builder: (context) => GoodealzDetailsDialog(
              order: Get.find<HomeController>()
                  .orderDetailsController
                  .goodealzDetailsData
                  .value,
            ),
          ),
          enterBottomSheetDuration: const Duration(
            milliseconds: 300,
          ),
          exitBottomSheetDuration: const Duration(
            milliseconds: 300,
          ),
          isScrollControlled: true,
        );
      } else if (message.data['type'] == 'chat') {
        Get.find<SocketServices>().chatChannelName.value =
            "private-chat.${message.data['chat_id']}";
        Get.find<SocketServices>()
            .subscribe("private-chat.${message.data['chat_id']}");
        Get.lazyPut<ChatProvider>(() => ChatProvider());
        Get.put(ChatController())
            .getChatMessages(int.parse(message.data['chat_id']));
        Get.toNamed(Routes.chatMessages, arguments: [
          message.data['sender_avatar'],
          message.data['sender_name'],
          int.parse(message.data['sender_id']),
          message.data['chat_id'],
        ]);
      } else if (message.data['type'] == 'confirm-withdrawel') {
        Get.toNamed(Routes.profits);
      } else {
        Get.toNamed(Routes.notification);
      }
    } else {
      Get.toNamed(Routes.notification);
    }
  }
}

@pragma('vm:entry-point')
Future<void> notificationsBackgroundHandler(RemoteMessage message) async {
  await initServices();
  log('Notification Payload ==> ${message.toMap()}');
  NotificationsHelper.handleNotificationCallback(message);
}
