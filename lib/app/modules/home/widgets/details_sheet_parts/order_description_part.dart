import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak_delivery/app/data/constants/constants.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';

class OrderDescriptionPart extends StatelessWidget {
  final String description;
  final String payment;
  const OrderDescriptionPart({
    super.key,
    required this.description,
    required this.payment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Constants.grey),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            'Order description'.tr.bodyMedium(
                  color: Colors.black,
                  weight: FontWeight.bold,
                ),
            const SizedBox(height: 5),
            description.bodyMedium(),
            const SizedBox(height: 10),
            'Order Payment Method'.tr.bodyMedium(
                  color: Colors.black,
                  weight: FontWeight.bold,
                ),
            const SizedBox(height: 5),
            payment.bodyMedium(),
          ],
        ),
      ),
    );
  }
}
