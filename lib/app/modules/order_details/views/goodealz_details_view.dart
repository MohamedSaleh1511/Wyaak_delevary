import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wayaak_delivery/app/core/enums/enums.dart';
import 'package:wayaak_delivery/app/core/helpers/helpers.dart';
import 'package:wayaak_delivery/app/core/theme/theme.dart';
import 'package:wayaak_delivery/app/core/widgets/global_appbar.dart';
import 'package:wayaak_delivery/app/core/widgets/global_button.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
import 'package:wayaak_delivery/app/data/models/goodealz_order_model/data.dart';
import 'package:wayaak_delivery/app/modules/home/widgets/details_sheet_parts/goodealz_prices_part.dart';
import 'package:wayaak_delivery/app/modules/home/widgets/details_sheet_parts/user_data_part.dart';
import 'package:wayaak_delivery/app/modules/order_details/controllers/order_details_controller.dart';
import 'package:wayaak_delivery/app/modules/order_details/widgets/goodealz_details_map.dart';
import 'package:wayaak_delivery/app/modules/order_details/widgets/goodealz_images_part.dart';
import 'package:wayaak_delivery/app/modules/order_details/widgets/locations_data_part.dart';
import 'package:wayaak_delivery/app/modules/order_details/widgets/vehicle_data.dart';

class GoodealzDetailsView extends GetView<OrderDetailsController> {
  const GoodealzDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppbar(title: 'Order details'.tr),
      body: Obx(
        () {
          if (controller.appServices.goodealzOrderModel.value.data == null) {
            return Center(child: "Error Occured".bodyMedium());
          } else {
            GoodealzData data =
                controller.appServices.goodealzOrderModel.value.data!;
            return Stack(
              children: [
                AspectRatio(
                  aspectRatio: 9 / 16,
                  child: GoodealzDetailsMap(
                    sourceLocation: LatLng(
                      double.parse(data.stock!.latitude ?? '0.0'),
                      double.parse(data.stock!.longitude ?? '0.0'),
                    ),
                    destinationLocation: LatLng(
                      double.parse(data.destinationLocation!.latitude ?? '0.0'),
                      double.parse(
                          data.destinationLocation!.longitude ?? '0.0'),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: DraggableScrollableSheet(
                    minChildSize: 0.1,
                    maxChildSize: 1.0,
                    initialChildSize: 0.1,
                    snap: true,
                    snapAnimationDuration: const Duration(milliseconds: 300),
                    builder: (context, scrollController) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(15)),
                        color: Colors.white,
                      ),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 6,
                              width: 45,
                              margin: const EdgeInsets.symmetric(vertical: 10)
                                  .copyWith(top: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.grey.withOpacity(0.8),
                              ),
                            ),
                            "Drag to see order details".tr.body().shimmer(
                                  baseColor: Colors.black87,
                                  highlightColor: Colors.grey.shade300,
                                  duration: 2000,
                                ),
                            if (data.driver != null) ...{
                              VehicleDataPart(driver: data.driver!),
                              const SizedBox(height: 12),
                              UserSheetDataPart(
                                name: data.user!.name!,
                                avatar: '',
                                phone: data.user!.phone!,
                              ),
                              const SizedBox(height: 12.01),
                            },
                            LocationsDataPart(
                              sourceLocation: data.stock!.name!,
                              destinationLocation:
                                  data.destinationLocation!.title!,
                            ),
                            const SizedBox(height: 12),
                            GoodealzPricesPart(
                              discountedPrice: data.discountedPrice!,
                              shippingCost: data.shippingCost!,
                              totalPrice: data.totalPrice!,
                              currency:
                                  controller.appServices.userCurrencyCode.value,
                            ),
                            const SizedBox(height: 12),
                            GoodealzImagesPart(images: data.productImages!),
                            const SizedBox(height: 18),
                            if (data.orderStatus! ==
                                OrderStatus.driverAccepted) ...{
                              GlobalButton(
                                onTap: () {
                                  double distance = calculateDistance2(
                                    currentLoc:
                                        controller.driverLiveLocation.value,
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
                                        message:
                                            "You haven't reached the destination yet"
                                                .tr);
                                  }
                                },
                                text: 'Update order status'.tr,
                                color: Get.theme.primaryColor,
                                width: Get.width,
                              ),
                            } else ...{
                              const SizedBox(),
                            },
                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
