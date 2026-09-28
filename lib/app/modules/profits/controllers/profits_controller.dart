import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak_delivery/app/core/theme/theme.dart';
import 'package:wayaak_delivery/app/data/models/no_data_response_model.dart';
import 'package:wayaak_delivery/app/data/models/wallet_model/wallet_model.dart';
import 'package:wayaak_delivery/app/data/models/withdraw_model/withdraw_model.dart';
import 'package:wayaak_delivery/app/data/services/app_services.dart';
import 'package:wayaak_delivery/app/modules/profits/providers/profits_provider.dart';

class ProfitsController extends GetxController {
  final ProfitsProviders provider = Get.find<ProfitsProviders>();
  final AppServices appServices = Get.find<AppServices>();

  RxString amount = ''.obs;
  RxString subject = ''.obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RxBool isWalletLoading = false.obs;
  Rx<WalletModel> wallet = WalletModel().obs;
  getWalletData() async {
    isWalletLoading.value = true;

    Map<String, dynamic>? data = await provider.getWallet();

    if (data != null) {
      isWalletLoading.value = false;
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          wallet.value = data['data'] as WalletModel;
        } else {
          NoDataResponseModel model = data['data'] as NoDataResponseModel;
          Ui.errorGetBar(message: model.message!);
        }
      }
    } else {
      isWalletLoading.value = false;
      Ui.errorGetBar(message: 'Internal Server Error'.tr);
    }
  }

  withdraw() async {
    Ui.loadingDialog();
    Map<String, dynamic>? data =
        await provider.postWithdraw(amount.value, subject.value);

    if (data != null) {
      Get.back();
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          Ui.successGetBar(message: (data['data'] as WithdrawModel).message!);
        } else {
          NoDataResponseModel model = data['data'] as NoDataResponseModel;
          Ui.errorGetBar(message: model.message!);
        }
      }
    } else {
      Get.back();
      Ui.errorGetBar(message: 'Internal Server Error'.tr);
    }
  }

  @override
  void onReady() {
    super.onReady();
    getWalletData();
  }
}
