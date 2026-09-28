import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wayaak_delivery/app/core/helpers/helpers.dart';
import 'package:wayaak_delivery/app/core/theme/theme.dart';
import 'package:wayaak_delivery/app/core/widgets/shimmers/notification_card_shimmer.dart';
import 'package:wayaak_delivery/app/data/constants/constants.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
import 'package:wayaak_delivery/app/data/models/requests_model/datum.dart';
import 'package:wayaak_delivery/app/modules/home/widgets/goodealz_details_dialog.dart';
import 'package:wayaak_delivery/app/modules/home/widgets/request_details_dialog.dart';
import 'package:wayaak_delivery/app/modules/notification/widgets/notifications_card.dart';
import 'package:wayaak_delivery/app/routes/app_routes.dart';
import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Notifications'.tr.titleSmall(color: Colors.black),
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Transform.flip(
            flipX: Get.locale == const Locale('ar'),
            child: 'Arrow Back'.iconColored(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => controller.clearNotifications(),
            child: "Clear All".tr.caption(
                  color: Constants.accent,
                  weight: FontWeight.bold,
                ),
          ),
        ],
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
      ),
      body: Obx(() {
        if (controller.isNotificationsLoading.value) {
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => const NotificationCardShimmer(),
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemCount: 5,
          );
        } else {
          if (controller.notificationsList.isEmpty) {
            return Center(child: 'No data found'.tr.body());
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                await controller.getNotifications();
              },
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => InkWell(
                  onTap: () async {
                    if (controller.notificationsList[index].orderNum != null &&
                        controller.notificationsList[index].type ==
                            'new-user-order') {
                      controller.appServices.orderNum.value =
                          controller.notificationsList[index].orderNum!;
                      Ui.loadingDialog();
                      await controller.orderDetailsController.getOrderDetails();
                      Get.back();
                      RequestsDatum data = controller
                          .orderDetailsController.orderDetailsData.value;
                      await controller.homeController
                          .getDeliveryCost(
                        data.orderNum!,
                        double.parse(calculateDistance2(
                          currentLoc: LatLng(
                            double.parse(
                              data.currentLocation!.latitude!,
                            ),
                            double.parse(
                              data.currentLocation!.longitude!,
                            ),
                          ),
                          destination: LatLng(
                            double.parse(
                              data.destinationLocation!.latitude!,
                            ),
                            double.parse(
                              data.destinationLocation!.longitude!,
                            ),
                          ),
                        ).toStringAsFixed(2)),
                      )
                          .then((v) {
                        Get.bottomSheet(
                          BottomSheet(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            backgroundColor: Colors.transparent,
                            enableDrag: true,
                            onClosing: () {},
                            builder: (context) => RequestDetailsDialog(
                              order: data,
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
                      });
                    } else if (controller.notificationsList[index].orderNum !=
                            null &&
                        controller.notificationsList[index].type ==
                            'new-goodealz-order') {
                      controller.appServices.orderNum.value =
                          controller.notificationsList[index].orderNum!;
                      Ui.loadingDialog();
                      await controller.orderDetailsController
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
                            order: controller.orderDetailsController
                                .goodealzDetailsData.value,
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
                    } else if (controller.notificationsList[index].orderNum !=
                            null &&
                        controller.notificationsList[index].type ==
                            'accept-offer') {
                      controller.appServices.orderNum.value =
                          controller.notificationsList[index].orderNum!;
                      controller.appServices.orderNum.refresh();
                      controller.orderDetailsController.getOrderDetails();
                      Get.log(
                          "Order Num :: ${controller.appServices.orderNum.value}");
                      Get.toNamed(Routes.orderDetails);
                    } else if (controller.notificationsList[index].type ==
                        'chat') {
                      Get.back();
                      Get.toNamed(Routes.chat);
                    } else if (controller.notificationsList[index].type ==
                        'admin-reply-ticket') {
                      if (controller.notificationsList[index].ticketNum !=
                          null) {
                        controller.supportController.ticketReplies.value = [];
                        controller.supportController.getTicketReplies(
                            controller.notificationsList[index].ticketNum!);
                        Get.toNamed(Routes.ticketChat,
                            arguments:
                                controller.notificationsList[index].ticketNum!);
                      }
                    } else if (controller.notificationsList[index].type ==
                            'confirm-withdrawel' ||
                        controller.notificationsList[index].type ==
                            'transfer-profit') {
                      Get.toNamed(Routes.profits);
                    }
                  },
                  borderRadius: BorderRadius.circular(15),
                  child: NotificationsCard(
                      notification: controller.notificationsList[index]),
                ),
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemCount: controller.notificationsList.length,
              ),
            );
          }
        }
      }),
    );
  }
}
