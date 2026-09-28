import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak_delivery/app/core/widgets/global_button.dart';
import 'package:wayaak_delivery/app/core/widgets/global_textfield.dart';
import 'package:wayaak_delivery/app/data/constants/constants.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
import 'package:wayaak_delivery/app/modules/home/controllers/home_controller.dart';

class AmountDialog extends GetWidget<HomeController> {
  final String orderNum;
  const AmountDialog({
    super.key,
    required this.orderNum,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      margin: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 10),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
      child: Form(
        key: controller.amountFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'Add your amount'.tr.titleSmall(),
            const SizedBox(height: 15),
            GlobalTextField(
              hintText: "Enter Amount".tr,
              prefixIcon: 'dollar-square',
              controller: controller.priceController,
              inputType: TextInputType.number,
              suffixText: controller.appServices.userCurrencyCode.value,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Please enter amount'.tr;
                } else if (controller.urgent.value == '1' &&
                    (double.parse(val) <
                        double.parse(controller.minCost.value))) {
                  return '${'amount less than minimum cost'.tr}  ${double.parse(controller.minCost.value).toStringAsFixed(2)}';
                } else if (controller.urgent.value == '0' &&
                    !(double.parse(val) >
                            double.parse(controller.minCost.value) &&
                        double.parse(val) <
                            double.parse(controller.maxCost.value))) {
                  return '${'amount not in the range'.tr} ${double.parse(controller.minCost.value).toStringAsFixed(2)} - ${double.parse(controller.maxCost.value).toStringAsFixed(2)}';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: GlobalButton(
                    onTap: () {
                      controller.priceController.text = '';
                      Get.back();
                    },
                    text: 'Cancel'.tr,
                    height: 60,
                    color: Constants.grey.withOpacity(0.2),
                    textColor: Constants.accent,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GlobalButton(
                    onTap: () {
                      if (controller.amountFormKey.currentState!.validate()) {
                        controller.amountFormKey.currentState!.save();
                        controller.addDeliveryCost(
                          orderNum,
                          controller.priceController.text,
                        );
                      }
                    },
                    text: 'Add'.tr,
                    height: 60,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
