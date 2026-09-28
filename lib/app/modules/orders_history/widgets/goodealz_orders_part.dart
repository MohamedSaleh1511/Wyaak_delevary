import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:wayaak_delivery/app/core/enums/enums.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
import 'package:wayaak_delivery/app/modules/home/widgets/goodealz_details_dialog.dart';
import 'package:wayaak_delivery/app/modules/home/widgets/shipment_card_goodealz.dart';
import 'package:wayaak_delivery/app/modules/orders_history/controllers/orders_history_controller.dart';
import 'package:wayaak_delivery/app/routes/app_routes.dart';

class GoodealzOrdersPart extends GetWidget<OrdersHistoryController> {
  const GoodealzOrdersPart({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isGoodealzOrdersLoading.value) {
        return UnconstrainedBox(
            child: Center(
                child: Lottie.asset('assets/lotties/dots-loader.json',
                    width: 80)));
      } else {
        if (controller.goodealzOrders.isEmpty) {
          return SingleChildScrollView(
              child: Center(child: "No data found".tr.bodyMedium()));
        } else {
          return RefreshIndicator(
            onRefresh: () async {
              controller.getGoodealzOrders();
            },
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: GestureDetector(
                  onTap: () async {
                    if (controller.goodealzOrders[i].orderStatus ==
                        OrderStatus.driverAccepted) {
                      await controller.getGoodealzOrderDetails(
                          controller.goodealzOrders[i].orderNum!);
                      controller.appServices.orderNum.value =
                          controller.goodealzOrders[i].orderNum!;
                      Get.toNamed(Routes.goodealzDetails);
                    } else {
                      Get.bottomSheet(
                        BottomSheet(
                          backgroundColor: Colors.transparent,
                          enableDrag: true,
                          onClosing: () {},
                          builder: (context) => GoodealzDetailsDialog(
                            order: controller.goodealzOrders[i],
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
                  child: ShipmentCardGoodealz(
                    isThereStatus: false,
                    goodealzData: controller.goodealzOrders[i],
                  ),
                ),
              ),
              itemCount: controller.goodealzOrders.length,
            ),
          );
        }
      }
    });
  }
}
