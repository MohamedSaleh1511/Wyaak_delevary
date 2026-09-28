import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:wayaak_delivery/app/core/enums/enums.dart';
import 'package:wayaak_delivery/app/core/widgets/global_appbar.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
import 'package:wayaak_delivery/app/data/models/requests_model/datum.dart';
import 'package:wayaak_delivery/app/modules/order_details/controllers/order_details_controller.dart';
import 'package:wayaak_delivery/app/modules/order_details/widgets/locations_data_part.dart';
import 'package:wayaak_delivery/app/modules/order_details/widgets/order_data_part.dart';
import 'package:wayaak_delivery/app/modules/order_details/widgets/order_det_button.dart';
import 'package:wayaak_delivery/app/modules/order_details/widgets/order_images_part.dart';
import 'package:wayaak_delivery/app/modules/order_details/widgets/user_data_part.dart';
import 'package:wayaak_delivery/app/modules/order_details/widgets/order_details_map.dart';
import 'package:wayaak_delivery/app/modules/order_details/widgets/vehicle_data.dart';

class OrderDetailsView extends GetView<OrderDetailsController> {
  const OrderDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppbar(title: 'Order details'.tr),
      body: Obx(
        () {
          if (controller.isOrderDetailsLoading.value) {
            return Center(
              child: Lottie.asset('assets/lotties/dots-loader.json', width: 80),
            );
          } else {
            if (controller.orderDetailsData.value.orderNum == null) {
              return Center(child: "Error Occured".bodyMedium());
            } else {
              RequestsDatum data = controller.orderDetailsData.value;
              return Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 9 / 16,
                    child: LiveTrackingMap(
                      sourceLocation: LatLng(
                        double.parse(data.currentLocation!.latitude ?? '0.0'),
                        double.parse(data.currentLocation!.longitude ?? '0.0'),
                      ),
                      destinationLocation: LatLng(
                        double.parse(
                            data.destinationLocation!.latitude ?? '0.0'),
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
                                UserDataPart(user: data.user!),
                                const SizedBox(height: 12.01),
                              },
                              LocationsDataPart(
                                sourceLocation: data.currentLocation!.title!,
                                destinationLocation:
                                    data.destinationLocation!.title!,
                              ),
                              const SizedBox(height: 12),
                              OrderDataPart(
                                orderNum: data.orderNum!,
                                title: data.title,
                                description: data.description!,
                                price: data.totalPrice!,
                                orderStatus: data.orderStatus!,
                                currency: controller
                                    .appServices.userCurrencyCode.value,
                              ),
                              const SizedBox(height: 12),
                              OrderImagesPart(
                                images: data.productImages!,
                              ),
                              const SizedBox(height: 18),
                              if (data.orderStatus! ==
                                  OrderStatus.driverAccepted)
                                OrderDetailsButton(data: data),
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
          }
        },
      ),
    );
  }
}
