import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak_delivery/app/data/constants/constants.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';

class GoodealzPricesPart extends StatelessWidget {
  final String discountedPrice;
  final String shippingCost;
  final String totalPrice;
  final String currency;
  const GoodealzPricesPart({
    super.key,
    required this.discountedPrice,
    required this.shippingCost,
    required this.totalPrice,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Constants.grey),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            children: [
              'dollar-square'
                  .iconColored(color: Get.theme.primaryColor, size: 30),
              const SizedBox(width: 8),
              'Order Price'
                  .tr
                  .bodyMedium(color: Colors.black, weight: FontWeight.bold),
            ],
          ),
          const SizedBox(height: 8),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       'Discounted Price'.tr.bodyMedium(),
          //       '$discountedPrice ${currency.tr}'.button(color: Colors.black87),
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       'Shipping Cost'.tr.bodyMedium(),
          //       '$shippingCost ${currency.tr}'.button(color: Colors.black87),
          //     ],
          //   ),
          // ),
          // const Divider(
          //   endIndent: 8,
          //   indent: 8,
          //   height: 20,
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                'Total Price'.tr.bodyMedium(),
                '$totalPrice ${currency.tr}'.button(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
