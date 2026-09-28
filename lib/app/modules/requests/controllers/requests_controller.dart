import 'package:get/get.dart';
import 'package:wayaak_delivery/app/core/theme/theme.dart';
import 'package:wayaak_delivery/app/data/models/goodealz_requests_model/goodealz_requests_model.dart';
import 'package:wayaak_delivery/app/data/models/no_data_response_model.dart';
import 'package:wayaak_delivery/app/data/models/requests_model/requests_model.dart';
import 'package:wayaak_delivery/app/data/services/app_services.dart';
import 'package:wayaak_delivery/app/data/services/socket_service.dart';
import 'package:wayaak_delivery/app/modules/requests/providers/requests_provider.dart';
import 'package:wayaak_delivery/app/routes/app_routes.dart';

class RequestsController extends GetxController {
  RxString popVal = "wayaak Requests".obs;
  final RequestsProviders provider = Get.find<RequestsProviders>();
  final AppServices appServices = Get.find<AppServices>();
  final SocketServices socketServices = Get.find<SocketServices>();

  RxBool isWayaakRequestsLoading = false.obs;
  Future<void> getWayaakRequests() async {
    isWayaakRequestsLoading.value = true;
    Map<String, dynamic>? data = await provider.getWayaakRequests();
    isWayaakRequestsLoading.value = false;
    if (data != null) {
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          socketServices.wayaakRequests.value =
              (data['data'] as RequestsModel).data!;
        }
      }
    }
  }

  RxBool isGodeelzRequestsLoading = false.obs;
  Future<void> getGoodeelzRequests() async {
    isGodeelzRequestsLoading.value = true;
    Map<String, dynamic>? data = await provider.getGoodealzRequests();
    isGodeelzRequestsLoading.value = false;
    if (data != null) {
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          Get.log(
              "goodealz:  ${(data['data'] as GoodealzRequestsModel).data!}");
          socketServices.godeelzRequests.value =
              (data['data'] as GoodealzRequestsModel).data!;
        }
      }
    }
  }

  cancelOffer() async {
    Ui.loadingDialog();
    Map<String, dynamic>? data =
        await provider.cancelOffer(appServices.orderNum.value);
    Get.back();
    if (data != null) {
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          Ui.successGetBar(
              message: (data['data'] as NoDataResponseModel).message!);
          Get.offAllNamed(Routes.main);
        }
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
    Future.wait([getWayaakRequests(), getGoodeelzRequests()]);
  }
}
