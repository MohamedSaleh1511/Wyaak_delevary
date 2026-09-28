import 'package:get/get.dart';
import 'package:wayaak_delivery/app/core/theme/theme.dart';
import 'package:wayaak_delivery/app/data/models/goodealz_order_model/goodealz_order_model.dart';
import 'package:wayaak_delivery/app/data/models/goodealz_requests_model/datum.dart';
import 'package:wayaak_delivery/app/data/models/goodealz_requests_model/goodealz_requests_model.dart';
import 'package:wayaak_delivery/app/data/models/requests_model/datum.dart';
import 'package:wayaak_delivery/app/data/models/requests_model/requests_model.dart';
import 'package:wayaak_delivery/app/data/services/app_services.dart';
import 'package:wayaak_delivery/app/data/services/socket_service.dart';
import 'package:wayaak_delivery/app/modules/chat/controllers/chat_controller.dart';
import 'package:wayaak_delivery/app/modules/orders_history/providers/orders_history_provider.dart';

class OrdersHistoryController extends GetxController {
  final OrdersHistoryProvider provider = Get.find<OrdersHistoryProvider>();
  final AppServices appServices = Get.find<AppServices>();
  final SocketServices socketServices = Get.find<SocketServices>();
  final ChatController chatController = Get.find<ChatController>();

  RxBool isWayaakOrdersLoading = false.obs;
  RxList<RequestsDatum> wayaakOrders = <RequestsDatum>[].obs;
  getGoodealzOrders() async {
    isWayaakOrdersLoading.value = true;
    Map<String, dynamic>? data = await provider.getWayaakOrders();
    isWayaakOrdersLoading.value = false;
    if (data != null) {
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          wayaakOrders.value = (data['data'] as RequestsModel).data!;
        }
      }
    }
  }

  RxBool isGoodealzOrdersLoading = false.obs;
  RxList<GoodealzDatum> goodealzOrders = <GoodealzDatum>[].obs;
  getWayaakOrders() async {
    isGoodealzOrdersLoading.value = true;
    Map<String, dynamic>? data = await provider.getGoodealzOrders();
    isGoodealzOrdersLoading.value = false;
    if (data != null) {
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          goodealzOrders.value = (data['data'] as GoodealzRequestsModel).data!;
        }
      }
    }
  }

  getGoodealzOrderDetails(String orderNum) async {
    Ui.loadingDialog();
    Map<String, dynamic>? data =
        await provider.getGoodealsOrderDetails(orderNum);
    Get.back();
    if (data != null) {
      if (data['code'] == 200) {
        appServices.goodealzOrderModel.value =
            data['data'] as GoodealzOrderModel;
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
    getGoodealzOrders();
    getWayaakOrders();
  }
}
