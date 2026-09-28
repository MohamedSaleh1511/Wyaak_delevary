import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak_delivery/app/core/enums/enums.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';

class OrderDataPart extends StatelessWidget {
  final String? title;
  final String description;
  final String price;
  final String orderNum;
  final OrderStatus orderStatus;
  final String currency;
  const OrderDataPart({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    required this.orderNum,
    required this.orderStatus,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              "Order Num".tr.titleSmall(color: Colors.black),
              const SizedBox(width: 8),
              '#$orderNum'.body(
                color: Get.theme.colorScheme.primary,
                weight: FontWeight.bold,
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (title != null) ...[
            "Order Title".tr.titleSmall(color: Colors.black),
            const SizedBox(height: 2),
            (title ?? "").body(),
            const SizedBox(height: 8),
          ],
          "Order Description".tr.titleSmall(color: Colors.black),
          const SizedBox(height: 2),
          description.body(),
          const SizedBox(height: 8),
          Row(
            children: [
              "Order Price".tr.titleSmall(color: Colors.black),
              const SizedBox(width: 8),
              "$price $currency".body(color: Get.theme.colorScheme.primary),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              "Order Status".tr.titleSmall(color: Colors.black),
              const SizedBox(width: 8),
              orderStatus.getStatus(),
            ],
          ),
        ],
      ).decorate(padding: 18),
    );
  }
}
