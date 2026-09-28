import 'package:get/get.dart';
import 'package:wayaak_delivery/app/data/models/global_response_model.dart';
import 'package:wayaak_delivery/app/data/models/goodealz_order_model/goodealz_order_model.dart';
import 'package:wayaak_delivery/app/data/models/goodealz_requests_model/goodealz_requests_model.dart';
import 'package:wayaak_delivery/app/data/models/requests_model/requests_model.dart';
import 'package:wayaak_delivery/app/data/providers/api_provider.dart';
import 'package:wayaak_delivery/app/data/services/app_services.dart';

class OrdersHistoryProvider extends ApiProvider {
  // NOTE :- Get Order Details
  Future<Map<String, dynamic>?> getWayaakOrders() async {
    Response res = await get('driver/my_orders', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Get.find<AppServices>().accessToken.value}',
    });
    if (res.status.isServerError) {
      return null;
    } else if (res.status.connectionError) {
      return {'error': true};
    } else {
      Get.log(res.statusCode.toString());
      return {
        'code': res.statusCode!,
        'data': (res.statusCode != 200)
            ? GlobalResponseModel.fromJson(res.body)
            : RequestsModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Get Order Details
  Future<Map<String, dynamic>?> getGoodealzOrders() async {
    Response res = await get('driver/my_external_orders', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Get.find<AppServices>().accessToken.value}',
    });
    if (res.status.isServerError) {
      return null;
    } else if (res.status.connectionError) {
      return {'error': true};
    } else {
      Get.log(res.statusCode.toString());
      return {
        'code': res.statusCode!,
        'data': (res.statusCode != 200)
            ? GlobalResponseModel.fromJson(res.body)
            : GoodealzRequestsModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Get Order Details
  Future<Map<String, dynamic>?> getGoodealsOrderDetails(String orderNum) async {
    Response res = await get('driver/external_order/$orderNum', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Get.find<AppServices>().accessToken.value}',
    });
    if (res.status.isServerError) {
      return null;
    } else if (res.status.connectionError) {
      return {'error': true};
    } else {
      Get.log(res.statusCode.toString());
      return {
        'code': res.statusCode!,
        'data': (res.statusCode != 200)
            ? GlobalResponseModel.fromJson(res.body)
            : GoodealzOrderModel.fromJson(res.body),
      };
    }
  }
}
