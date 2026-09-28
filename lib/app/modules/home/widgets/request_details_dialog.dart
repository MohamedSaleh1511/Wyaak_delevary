import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:wayaak_delivery/app/core/helpers/helpers.dart';
import 'package:wayaak_delivery/app/core/widgets/global_button.dart';
import 'package:wayaak_delivery/app/data/constants/constants.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
import 'package:wayaak_delivery/app/data/models/requests_model/datum.dart';
import 'package:wayaak_delivery/app/modules/home/controllers/home_controller.dart';
import 'package:wayaak_delivery/app/modules/home/widgets/details_sheet_parts/amount_dialog.dart';
import 'package:wayaak_delivery/app/modules/home/widgets/details_sheet_parts/min_max_price_part.dart';
import 'package:wayaak_delivery/app/modules/home/widgets/details_sheet_parts/order_description_part.dart';
import 'package:wayaak_delivery/app/modules/home/widgets/details_sheet_parts/order_images_part.dart';
import 'package:wayaak_delivery/app/modules/home/widgets/details_sheet_parts/order_tips_part.dart';
import 'package:wayaak_delivery/app/modules/home/widgets/details_sheet_parts/user_data_part.dart';
import 'package:wayaak_delivery/app/modules/home/widgets/shipment_card.dart';

class RequestDetailsDialog extends GetView<HomeController> {
  final RequestsDatum order;
  final bool isFromOrderDetails;
  const RequestDetailsDialog(
      {super.key, required this.order, this.isFromOrderDetails = true});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.orderDetailsController.isOrderDetailsLoading.value) {
          return Center(
            child: Lottie.asset('assets/lotties/dots-loader.json', width: 80),
          );
        } else {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                const SizedBox(height: 35),
                'Order Details'.tr.title(color: Colors.black),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    "Status:".tr.bodyMedium(),
                    order.orderStatus!.getStatus(
                      color: Constants.secondary.withOpacity(0.2),
                      textColor: Constants.secondary,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ShipmentCard(isThereStatus: false, data: order),
                const SizedBox(height: 12),
                UserSheetDataPart(
                  avatar: order.user!.avatar ?? '',
                  phone: order.user!.phone!,
                  name: order.user!.name!,
                ),
                const SizedBox(height: 12),
                MinMaxPricePart(
                  minCost: controller.minCost.value,
                  maxCost: controller.maxCost.value,
                  urgent: controller.urgent.value,
                  totalPrice: "",
                ),
                const SizedBox(height: 12),
                OrderTipsPart(
                  distanceToUser: '${calculateDistance2(
                    destination: LatLng(
                        double.parse(order.currentLocation!.latitude!),
                        double.parse(order.currentLocation!.longitude!)),
                    currentLoc: controller.currentPosition.value,
                  ).toStringAsFixed(2)} Km',
                  distanceTrip: '${calculateDistance2(
                    currentLoc: LatLng(
                        double.parse(order.currentLocation!.latitude!),
                        double.parse(order.currentLocation!.longitude!)),
                    destination: LatLng(
                      double.parse(order.destinationLocation!.latitude!),
                      double.parse(order.destinationLocation!.longitude!),
                    ),
                  ).toStringAsFixed(2)} Km',
                  createdAt: order.createdAt!,
                ),
                const SizedBox(height: 12),
                OrderDescriptionPart(
                    description: order.description!,
                    payment: order.paymentMethod ?? ""),
                const SizedBox(height: 12),
                OrderImagesPart(
                  images: order.productImages!.map((e) => e.image!).toList(),
                  imagesLength: order.productImages!.length,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: GlobalButton(
                        onTap: () => Get.back(),
                        text: 'Cancel'.tr,
                        textColor: Get.theme.colorScheme.error,
                        color: Colors.transparent,
                      ),
                    ),
                    if (isFromOrderDetails) ...{
                      const SizedBox(width: 8),
                      Expanded(
                        child: GlobalButton(
                          onTap: () {
                            Get.bottomSheet(
                              BottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                backgroundColor: Colors.transparent,
                                enableDrag: false,
                                onClosing: () {
                                  controller.priceController.text = '';
                                },
                                builder: (context) =>
                                    AmountDialog(orderNum: order.orderNum!),
                              ),
                              enterBottomSheetDuration:
                                  const Duration(milliseconds: 250),
                              exitBottomSheetDuration:
                                  const Duration(milliseconds: 250),
                              isScrollControlled: false,
                            );
                          },
                          text: 'Send Request'.tr,
                        ),
                      ),
                    },
                  ],
                ),
                const SizedBox(height: 5),
              ],
            ),
          ).decorate(radius: 0);
        }
      },
    );
  }
}
