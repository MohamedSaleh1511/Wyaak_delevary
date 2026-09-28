import 'package:get/get.dart';
import 'package:wayaak_delivery/app/core/theme/theme.dart';
import 'package:wayaak_delivery/app/data/models/static_pages_model/static_pages_model.dart';
import 'package:wayaak_delivery/app/modules/static_pages/providers/static_pages_provider.dart';

class StaticPagesController extends GetxController {
  final StaticPagesProviders provider = Get.find<StaticPagesProviders>();

  RxBool loading = false.obs;
  Rx<StaticPagesModel> privacyModel = StaticPagesModel().obs;
  Rx<StaticPagesModel> termsModel = StaticPagesModel().obs;
  Rx<StaticPagesModel> aboutModel = StaticPagesModel().obs;

  getPrivacyPolicy() async {
    loading.value = true;
    final response = await provider.getPrivacyPolicy();
    if (response != null) {
      loading.value = false;
      if (response.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (response['code'] == 200) {
          privacyModel.value = response['data'] as StaticPagesModel;
        } else {
          Ui.errorGetBar(message: 'Error occured');
        }
      }
    } else {
      loading.value = false;
      Ui.errorGetBar(message: 'Error occured');
    }
  }

  getTerms() async {
    loading.value = true;
    final response = await provider.getTermsAndConditions();
    if (response != null) {
      loading.value = false;
      if (response.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (response['code'] == 200) {
          termsModel.value = response['data'] as StaticPagesModel;
        } else {
          Ui.errorGetBar(message: 'Error occured');
        }
      }
    } else {
      loading.value = false;
      Ui.errorGetBar(message: 'Error occured');
    }
  }

  getAbout() async {
    loading.value = true;
    final response = await provider.getAboutUs();
    if (response != null) {
      loading.value = false;
      if (response.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (response['code'] == 200) {
          aboutModel.value = response['data'] as StaticPagesModel;
        } else {
          Ui.errorGetBar(message: 'Error occured');
        }
      }
    } else {
      loading.value = false;
      Ui.errorGetBar(message: 'Error occured');
    }
  }
}
