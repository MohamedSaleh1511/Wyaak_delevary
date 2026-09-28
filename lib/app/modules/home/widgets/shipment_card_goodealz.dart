import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak_delivery/app/core/helpers/helpers.dart';
import 'package:wayaak_delivery/app/data/constants/constants.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
import 'package:wayaak_delivery/app/data/models/goodealz_requests_model/datum.dart';
import 'package:wayaak_delivery/app/data/services/app_services.dart';

class ShipmentCardGoodealz extends StatelessWidget {
  final bool isThereStatus;
  final GoodealzDatum? goodealzData;
  ShipmentCardGoodealz({
    super.key,
    this.isThereStatus = true,
    this.goodealzData,
  });

  final AppServices appServices = Get.find<AppServices>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                child: 'order'.iconColored(),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    '${goodealzData?.title}'.subtitle(),
                    '${'Order id:'.tr} ${goodealzData?.orderNum}'.bodyMedium(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              height: 100,
              child: Row(
                children: [
                  Column(
                    children: [
                      'dot'
                          .iconColored(color: Get.theme.primaryColor, size: 20),
                      const Expanded(
                        child: DottedLine(
                          direction: Axis.vertical,
                        ),
                      ),
                      'dot'.iconColored(color: Constants.grey, size: 20),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            'From:'.tr.caption(color: Constants.grey),
                            GestureDetector(
                              onTap: () {
                                launch(Uri.parse(
                                    'https://www.google.com/maps/search/?api=1&query=${goodealzData?.stockLocation!.latitude!},${goodealzData?.stockLocation!.longitude!}'));
                              },
                              child:
                                  '${goodealzData?.stockLocation == null ? "" : goodealzData?.stockLocation!.name}'
                                      .bodyMedium(color: Colors.black),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            'Shipping to:'.tr.caption(color: Constants.grey),
                            '${goodealzData?.destinationLocation!.title}'
                                .bodyMedium(color: Colors.black, maxLines: 1),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          if (isThereStatus == true)
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  "Status:".tr.bodyMedium(),
                  // goodealzData?.orderStatus!.getStatus(),
                  "${goodealzData?.orderStatus!}".caption(),
                ],
              ),
            ),
        ],
      ),
    ).decorate(color: Constants.softGrey, padding: 15, shadow: false);
  }
}
