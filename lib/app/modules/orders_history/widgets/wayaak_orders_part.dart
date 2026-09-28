import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:wayaak_delivery/app/core/enums/enums.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
import 'package:wayaak_delivery/app/modules/home/controllers/home_controller.dart';
import 'package:wayaak_delivery/app/modules/home/widgets/request_details_dialog.dart';
import 'package:wayaak_delivery/app/modules/home/widgets/shipment_card.dart';
import 'package:wayaak_delivery/app/modules/orders_history/controllers/orders_history_controller.dart';
import 'package:wayaak_delivery/app/routes/app_routes.dart';

class WayaakOrdersPart extends GetWidget<OrdersHistoryController> {
  const WayaakOrdersPart({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isWayaakOrdersLoading.value) {
        return UnconstrainedBox(
            child: Center(
                child: Lottie.asset('assets/lotties/dots-loader.json',
                    width: 80)));
      } else {
        if (controller.wayaakOrders.isEmpty) {
          return SingleChildScrollView(
              child: Center(child: "No data found".tr.bodyMedium()));
        } else {
          return RefreshIndicator(
            onRefresh: () async {
              controller.getWayaakOrders();
            },
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: GestureDetector(
                  onTap: () {
                    if (controller.wayaakOrders[i].orderStatus ==
                        OrderStatus.driverAccepted) {
                      controller.appServices.orderNum.value =
                          controller.wayaakOrders[i].orderNum!;
                      Get.find<HomeController>()
                          .orderDetailsController
                          .getOrderDetails();
                      Get.toNamed(Routes.orderDetails);
                    } else {
                      Get.bottomSheet(
                        BottomSheet(
                          backgroundColor: Colors.transparent,
                          enableDrag: true,
                          onClosing: () {},
                          builder: (context) => RequestDetailsDialog(
                            order: controller.wayaakOrders[i],
                            isFromOrderDetails: false,
                          ),
                        ),
                        enterBottomSheetDuration:
                            const Duration(milliseconds: 300),
                        exitBottomSheetDuration:
                            const Duration(milliseconds: 300),
                        isScrollControlled: true,
                      );
                    }
                  },
                  child: ShipmentCard(
                    isThereStatus: false,
                    data: controller.wayaakOrders[i],
                  ),
                ),
              ),
              itemCount: controller.wayaakOrders.length,
            ),
          );
        }
      }
    });
  }
}
