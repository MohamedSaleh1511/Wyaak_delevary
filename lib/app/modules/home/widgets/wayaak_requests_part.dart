import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:wayaak_delivery/app/core/helpers/helpers.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
import 'package:wayaak_delivery/app/data/models/requests_model/datum.dart';
import 'package:wayaak_delivery/app/modules/home/controllers/home_controller.dart';
import 'package:wayaak_delivery/app/modules/home/widgets/request_details_dialog.dart';
import 'package:wayaak_delivery/app/modules/home/widgets/shipment_card.dart';

class WayaakRequestsPart extends GetView<HomeController> {
  final ScrollController? scrollController;
  const WayaakRequestsPart({super.key, this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.requestsController.isWayaakRequestsLoading.value) {
        return UnconstrainedBox(
          child: Center(
            child: Lottie.asset('assets/lotties/dots-loader.json', width: 80),
          ),
        );
      } else {
        if (controller
            .requestsController.socketServices.wayaakRequests.isEmpty) {
          return SingleChildScrollView(
              child: Center(child: "No data found".tr.bodyMedium()));
        } else {
          return RefreshIndicator(
            onRefresh: () async {
              await controller.requestsController.getWayaakRequests();
            },
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              controller: scrollController,
              itemBuilder: (context, i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: GestureDetector(
                  onTap: () async {
                    RequestsDatum data = controller
                        .requestsController.socketServices.wayaakRequests[i];

                    await controller
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
                      controller.appServices.orderNum.value = controller
                          .requestsController
                          .socketServices
                          .wayaakRequests[i]
                          .orderNum!;
                      Get.bottomSheet(
                        BottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          backgroundColor: Colors.transparent,
                          enableDrag: true,
                          onClosing: () {},
                          builder: (context) => RequestDetailsDialog(
                            order: controller.requestsController.socketServices
                                .wayaakRequests[i],
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
                  },
                  child: ShipmentCard(
                    isThereStatus: false,
                    data: controller
                        .requestsController.socketServices.wayaakRequests[i],
                  ),
                ),
              ),
              itemCount: controller
                  .requestsController.socketServices.wayaakRequests.length,
            ),
          );
        }
      }
    });
  }
}
