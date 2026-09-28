import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak_delivery/app/data/constants/constants.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
import 'package:wayaak_delivery/app/modules/home/controllers/home_controller.dart';

class MinMaxPricePart extends GetWidget<HomeController> {
  final String minCost;
  final String maxCost;
  final String urgent;
  final String totalPrice;
  const MinMaxPricePart({
    super.key,
    required this.minCost,
    required this.maxCost,
    required this.urgent,
    this.totalPrice = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Constants.grey),
        borderRadius: BorderRadius.circular(80),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                (totalPrice.isEmpty ? 'Min Cost' : 'Total Price').tr.caption(),
                if (totalPrice.isEmpty)
                  '${minCost.isEmpty ? '' : double.parse(minCost).toStringAsFixed(2)} ${controller.appServices.userCurrencyCode.value.tr}'
                      .body(color: Colors.black, weight: FontWeight.bold)
                else
                  '${totalPrice.isEmpty ? '' : double.parse(totalPrice).toStringAsFixed(2)} ${controller.appServices.userCurrencyCode.value.tr}'
                      .body(color: Colors.black, weight: FontWeight.bold),
              ],
            ),
          ),
          if (urgent == '0' || totalPrice.isEmpty) ...{
            const SizedBox(height: 40, child: VerticalDivider()),
            Expanded(
              child: Column(
                children: [
                  'Max Cost'.tr.caption(),
                  '${maxCost.isEmpty ? '' : double.parse(maxCost).toStringAsFixed(2)} ${controller.appServices.userCurrencyCode.value.tr}'
                      .body(color: Colors.black, weight: FontWeight.bold),
                ],
              ),
            ),
          },
        ],
      ),
    );
  }
}
