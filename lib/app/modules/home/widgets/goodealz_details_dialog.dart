import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wayaak_delivery/app/core/helpers/helpers.dart';
import 'package:wayaak_delivery/app/core/widgets/global_button.dart';
import 'package:wayaak_delivery/app/data/constants/constants.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
import 'package:wayaak_delivery/app/data/models/goodealz_requests_model/datum.dart';
import 'package:wayaak_delivery/app/modules/home/controllers/home_controller.dart';
import 'package:wayaak_delivery/app/modules/home/widgets/details_sheet_parts/goodealz_prices_part.dart';
import 'package:wayaak_delivery/app/modules/home/widgets/details_sheet_parts/order_images_part.dart';
import 'package:wayaak_delivery/app/modules/home/widgets/details_sheet_parts/order_tips_part.dart';
import 'package:wayaak_delivery/app/modules/home/widgets/details_sheet_parts/user_data_part.dart';
import 'package:wayaak_delivery/app/modules/home/widgets/shipment_card_goodealz.dart';

class GoodealzDetailsDialog extends GetView<HomeController> {
  final GoodealzDatum order;
  final bool isFromOrderDetails;
  const GoodealzDetailsDialog({
    super.key,
    required this.order,
    this.isFromOrderDetails = true,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                const SizedBox(height: 25),
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
                ShipmentCardGoodealz(isThereStatus: false, goodealzData: order),
                const SizedBox(height: 12),
                UserSheetDataPart(
                  avatar: '',
                  phone: order.user!.phone ?? '',
                  name: order.user!.name!,
                ),
                const SizedBox(height: 12),
                OrderTipsPart(
                  distanceToUser: '${calculateDistance2(
                    destination: LatLng(
                        double.parse(order.stockLocation!.latitude!),
                        double.parse(order.stockLocation!.longitude!)),
                    currentLoc: controller.currentPosition.value,
                  ).toStringAsFixed(2)} Km',
                  distanceTrip: '${calculateDistance2(
                    currentLoc: LatLng(
                        double.parse(order.stockLocation!.latitude!),
                        double.parse(order.stockLocation!.longitude!)),
                    destination: LatLng(
                      double.parse(order.destinationLocation!.latitude!),
                      double.parse(order.destinationLocation!.longitude!),
                    ),
                  ).toStringAsFixed(2)} Km',
                  createdAt: order.createdAt!,
                ),
                const SizedBox(height: 12),
                OrderImagesPart(
                  images: order.productImages!
                      .map((e) => e.productImage ?? "")
                      .toList(),
                  imagesLength: order.productImages!.length,
                ),
                const SizedBox(height: 12),
                GoodealzPricesPart(
                  discountedPrice: order.discountedPrice!,
                  shippingCost: order.shippingCost!,
                  totalPrice: order.totalPrice!,
                  currency: controller.appServices.userCurrencyCode.value,
                ),
                const SizedBox(height: 30),
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
                            controller.chooseGoodealzOrder(order.orderNum!);
                          },
                          text: 'Choose Order'.tr,
                        ),
                      ),
                    },
                  ],
                ),
                const SizedBox(height: 5),
              ],
            ),
          ).decorate(radius: 0);
        },
      ),
    );
  }
}
