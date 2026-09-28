import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wayaak_delivery/app/core/enums/enums.dart';
import 'package:wayaak_delivery/app/core/helpers/helpers.dart';
import 'package:wayaak_delivery/app/core/theme/theme.dart';
import 'package:wayaak_delivery/app/core/widgets/global_button.dart';
import 'package:wayaak_delivery/app/data/constants/constants.dart';
import 'package:wayaak_delivery/app/data/models/requests_model/datum.dart';
import 'package:wayaak_delivery/app/data/services/update_location_service.dart';
import 'package:wayaak_delivery/app/modules/order_details/controllers/order_details_controller.dart';

class OrderDetailsButton extends StatefulWidget {
  final RequestsDatum data;
  const OrderDetailsButton({super.key, required this.data});

  @override
  State<OrderDetailsButton> createState() => _OrderDetailsButtonState();
}

class _OrderDetailsButtonState extends State<OrderDetailsButton> {
  final OrderDetailsController controller = Get.find<OrderDetailsController>();
  final UpdateLocationService updateLocationService =
      Get.find<UpdateLocationService>();
  bool showConfirmDeliveryButton = false;
  @override
  Widget build(BuildContext context) {
    if (widget.data.orderStatus! == OrderStatus.driverAccepted) {
      if (showConfirmDeliveryButton) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: GlobalButton(
            onTap: () {
              controller.deliveryConfirmationFlow();
              updateLocationService.stopTracking();
            },
            text: 'Confirm Delivery'.tr,
            color: Constants.green,
            width: Get.width,
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: GlobalButton(
            onTap: () {
              double distance = calculateDistance2(
                currentLoc: controller.driverLiveLocation.value,
                destination: LatLng(
                  double.parse(
                    widget.data.destinationLocation!.latitude!,
                  ),
                  double.parse(
                    widget.data.destinationLocation!.longitude!,
                  ),
                ),
              );
              log('Distance :: $distance');
              log('Distance :: ${controller.driverLiveLocation.value}');
              if (distance < 1) {
                controller.updateDriverStatus(true);
                setState(() {
                  showConfirmDeliveryButton = true;
                });
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
      }
    } else {
      return const SizedBox();
    }
  }
}
