import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:wayaak_delivery/app/core/helpers/helpers.dart';
import 'package:wayaak_delivery/app/data/constants/constants.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';

class OrderTipsPart extends StatelessWidget {
  final DateTime createdAt;
  final String distanceTrip;
  final String distanceToUser;
  const OrderTipsPart({
    super.key,
    required this.createdAt,
    required this.distanceTrip,
    required this.distanceToUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Constants.grey),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    'calendar'.iconColored(color: Get.theme.primaryColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          'Date'.tr.bodyMedium(
                                color: Colors.black,
                                weight: FontWeight.bold,
                              ),
                          const SizedBox(height: 5),
                          UnconstrainedBox(
                            alignment: AlignmentDirectional.center,
                            child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: DateFormat('dd/MM/y')
                                    .format(createdAt)
                                    .caption()),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    'map'.iconColored(color: Get.theme.primaryColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          'Distance trip'.tr.bodyMedium(
                                color: Colors.black,
                                weight: FontWeight.bold,
                              ),
                          const SizedBox(height: 5),
                          UnconstrainedBox(
                            alignment: AlignmentDirectional.center,
                            child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: distanceTrip.caption()),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    'clock'.iconColored(color: Get.theme.primaryColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          'Time'.tr.bodyMedium(
                                color: Colors.black,
                                weight: FontWeight.bold,
                              ),
                          const SizedBox(height: 5),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: convertUtcToLocal(createdAt).caption(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    'route-square'.iconColored(color: Get.theme.primaryColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          'Distance to user'.tr.bodyMedium(
                                color: Colors.black,
                                weight: FontWeight.bold,
                              ),
                          const SizedBox(height: 5),
                          UnconstrainedBox(
                            alignment: AlignmentDirectional.center,
                            child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: distanceToUser.caption()),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
