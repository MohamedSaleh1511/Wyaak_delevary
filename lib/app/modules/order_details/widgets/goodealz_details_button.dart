import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wayaak_delivery/app/core/enums/enums.dart';
import 'package:wayaak_delivery/app/core/helpers/helpers.dart';
import 'package:wayaak_delivery/app/core/theme/theme.dart';
import 'package:wayaak_delivery/app/core/widgets/global_button.dart';
import 'package:wayaak_delivery/app/data/models/goodealz_order_model/data.dart';
import 'package:wayaak_delivery/app/modules/order_details/controllers/order_details_controller.dart';

class GoodealzDetailsButton extends GetWidget<OrderDetailsController> {
  final GoodealzData data;
  const GoodealzDetailsButton({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (data.orderStatus! == OrderStatus.driverAccepted) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: GlobalButton(
            onTap: () {
              double distance = calculateDistance2(
                currentLoc: controller.driverLiveLocation.value,
                destination: LatLng(
                  double.parse(
                    data.destinationLocation!.latitude!,
                  ),
                  double.parse(
                    data.destinationLocation!.longitude!,
                  ),
                ),
              );
              log('Distance :: $distance');
              log('Distance :: ${controller.driverLiveLocation.value}');
              if (distance < 1) {
                controller.updateDriverStatus(false);
              } else {
                Ui.errorGetBar(
                    message: "You haven't reached the destination yet".tr);
              }
            },
            text: 'Update order status'.tr,
            color: Get.theme.primaryColor,
            width: Get.width,
          ),
        );
      } else {
        return const SizedBox();
      }
    });
  }
}
