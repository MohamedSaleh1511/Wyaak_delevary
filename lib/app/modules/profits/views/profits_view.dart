import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:lottie/lottie.dart';
import 'package:wayaak_delivery/app/core/enums/enums.dart';
import 'package:wayaak_delivery/app/core/helpers/helpers.dart';
import 'package:wayaak_delivery/app/core/widgets/global_appbar.dart';
import 'package:wayaak_delivery/app/core/widgets/global_button.dart';
import 'package:wayaak_delivery/app/core/widgets/global_textfield.dart';
import 'package:wayaak_delivery/app/data/constants/constants.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
import '../controllers/profits_controller.dart';

class ProfitsView extends GetView<ProfitsController> {
  const ProfitsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppbar(title: "Wallet".tr),
      body: Obx(() {
        if (controller.isWalletLoading.value) {
          return Center(
            child: Lottie.asset('assets/lotties/dots-loader.json', width: 80),
          );
        } else {
          if (controller.wallet.value.data == null) {
            return Center(child: "No data found".tr.bodyMedium());
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              physics: const BouncingScrollPhysics(),
              child: Center(
                child: Column(
                  children: [
                    Column(
                      children: [
                        "Last update".tr.caption(color: Colors.white70),
                        const SizedBox(height: 5),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: convertUtcToLocalWallet(
                                  controller.wallet.value.data!.lastUpdate!)
                              .bodyMedium(color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        '${controller.wallet.value.data!.balance} ${controller.appServices.userCurrencyCode.value.tr}'
                            .headline(color: Colors.white),
                        const SizedBox(height: 20),
                        '${controller.wallet.value.data!.earningHistory!.length} ${'Requests'.tr}'
                            .tr
                            .bodyMedium(color: Colors.white),
                        const SizedBox(height: 30),
                        GlobalButton(
                          onTap: () {
                            Get.generalDialog(
                              transitionDuration:
                                  const Duration(milliseconds: 700),
                              transitionBuilder: (context, animation,
                                      secondaryAnimation, child) =>
                                  child.dialogTransition(animation),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      Dialog(
                                child: Form(
                                  key: controller.formKey,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(height: 30),
                                        "Withdraw Money".tr.titleSmall(),
                                        const SizedBox(height: 15),
                                        GlobalTextField(
                                          hintText: 'Enter Amount'.tr,
                                          prefixIcon: 'dollar-square',
                                          suffixText: controller.appServices
                                              .userCurrencyCode.value.tr,
                                          textInputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            NumberInputFormatter(),
                                          ],
                                          validator: (val) {
                                            if (val!.isEmpty) {
                                              return 'Please enter your amount'
                                                  .tr;
                                            } else {
                                              return null;
                                            }
                                          },
                                          onSaved: (val) =>
                                              controller.amount.value = val!,
                                        ),
                                        const SizedBox(height: 15),
                                        GlobalButton(
                                          onTap: () async {
                                            if (controller.formKey.currentState!
                                                .validate()) {
                                              controller.formKey.currentState!
                                                  .save();
                                              controller.subject.value =
                                                  "I want to withdraw ${controller.amount.value.isEmpty ? '0' : controller.amount.value} ${controller.appServices.userCurrencyCode.value} from my wallet";
                                              Get.back();
                                              controller.withdraw();
                                            }
                                          },
                                          text: 'Withdraw'.tr,
                                          width: Get.width * 0.75,
                                        ),
                                        const SizedBox(height: 30),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          width: double.infinity,
                          text: 'Withdraw Money'.tr,
                          color: Colors.white,
                          textColor: Get.theme.primaryColor,
                          height: 40,
                        ),
                      ],
                    ).decorate(
                      color: Get.theme.primaryColor,
                      width: Get.width,
                      padding: 28,
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          'Earning History'.tr.subtitle(),
                          '${controller.wallet.value.data!.transactionsCount} ${'transactions'.tr}'
                              .tr
                              .caption(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (controller
                        .wallet.value.data!.earningHistory!.isEmpty) ...{
                      Center(child: "No history yet".tr.bodyMedium()),
                    } else ...{
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => Row(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                'date card'.iconColored(
                                  color: Get.theme.colorScheme.secondary,
                                  size: 65,
                                ),
                                Positioned(
                                  top: 2.8,
                                  child: DateFormat('MMM')
                                      .format(controller.wallet.value.data!
                                          .earningHistory![index].date!)
                                      .caption(
                                        color: Colors.white,
                                        weight: FontWeight.bold,
                                      ),
                                ),
                                Positioned(
                                  bottom: 8,
                                  child: DateFormat('dd')
                                      .format(controller.wallet.value.data!
                                          .earningHistory![index].date!)
                                      .title(color: Colors.white),
                                ),
                              ],
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (controller.wallet.value.data!
                                          .earningHistory![index].status ==
                                      WalletStatus.charged)
                                    'Earning'.tr.body()
                                  else
                                    'Withdraw'.tr.body(),
                                  '${controller.wallet.value.data!.earningHistory![index].profit} ${controller.appServices.userCurrencyCode.value.tr}'
                                      .subtitle(weight: FontWeight.bold),
                                  const SizedBox(height: 5),
                                  if (controller.wallet.value.data!
                                          .earningHistory![index].status ==
                                      WalletStatus.charged)
                                    '${'Order Number'.tr} ${controller.wallet.value.data!.earningHistory![index].orderNum}'
                                        .bodyMedium(),
                                ],
                              ),
                            ),
                            controller.wallet.value.data!.earningHistory![index]
                                .status!
                                .toJson()
                                .tr
                                .caption(
                                  color: controller.wallet.value.data!
                                              .earningHistory![index].status ==
                                          WalletStatus.charged
                                      ? Constants.green
                                      : controller
                                                  .wallet
                                                  .value
                                                  .data!
                                                  .earningHistory![index]
                                                  .status ==
                                              WalletStatus.pending
                                          ? Get.theme.colorScheme.secondary
                                          : Get.theme.primaryColor,
                                  weight: FontWeight.bold,
                                ),
                          ],
                        ).decorate(padding: 12),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemCount: controller
                            .wallet.value.data!.earningHistory!.length,
                      ),
                    },
                  ],
                ),
              ),
            );
          }
        }
      }),
    );
  }
}
