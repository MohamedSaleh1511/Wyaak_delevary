import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
import 'package:wayaak_delivery/app/modules/home/controllers/home_controller.dart';
import 'package:wayaak_delivery/app/modules/home/widgets/goodealz_details_dialog.dart';
import 'package:wayaak_delivery/app/modules/home/widgets/shipment_card_goodealz.dart';

class GoodealzRequestsPart extends GetView<HomeController> {
  final ScrollController? scrollController;
  const GoodealzRequestsPart({super.key, this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.requestsController.isGodeelzRequestsLoading.value) {
        return UnconstrainedBox(
            child: Center(
                child: Lottie.asset('assets/lotties/dots-loader.json',
                    width: 80)));
      } else {
        if (controller
            .requestsController.socketServices.godeelzRequests.isEmpty) {
          return SingleChildScrollView(
              controller: scrollController,
              child: Center(child: "No data found".tr.bodyMedium()));
        } else {
          return RefreshIndicator(
            onRefresh: () async {
              controller.requestsController.getGoodeelzRequests();
            },
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              controller: scrollController,
              itemBuilder: (context, i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: GestureDetector(
                  onTap: () {
                    Get.bottomSheet(
                      BottomSheet(
                        backgroundColor: Colors.transparent,
                        enableDrag: true,
                        onClosing: () {},
                        builder: (context) => GoodealzDetailsDialog(
                          order: controller.requestsController.socketServices
                              .godeelzRequests[i],
                        ),
                      ),
                      enterBottomSheetDuration:
                          const Duration(milliseconds: 300),
                      exitBottomSheetDuration:
                          const Duration(milliseconds: 300),
                      isScrollControlled: true,
                    );
                  },
                  child: ShipmentCardGoodealz(
                    isThereStatus: false,
                    goodealzData: controller
                        .requestsController.socketServices.godeelzRequests[i],
                  ),
                ),
              ),
              itemCount: controller
                  .requestsController.socketServices.godeelzRequests.length,
            ),
          );
        }
      }
    });
  }
}
