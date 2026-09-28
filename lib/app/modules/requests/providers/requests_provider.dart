import 'package:get/get.dart';
import 'package:wayaak_delivery/app/data/models/chat_messages_model/chat_messages_model.dart';
import 'package:wayaak_delivery/app/data/models/global_response_model.dart';
import 'package:wayaak_delivery/app/data/models/goodealz_requests_model/goodealz_requests_model.dart';
import 'package:wayaak_delivery/app/data/models/no_data_response_model.dart';
import 'package:wayaak_delivery/app/data/models/order_details_model/order_details_model.dart';
import 'package:wayaak_delivery/app/data/models/requests_model/requests_model.dart';
import 'package:wayaak_delivery/app/data/providers/api_provider.dart';
import 'package:wayaak_delivery/app/data/services/app_services.dart';

class RequestsProviders extends ApiProvider {
  // NOTE :- Get wayaak_delivery Requests
  Future<Map<String, dynamic>?> getWayaakRequests() async {
    Response res = await get('driver/wayak_requests', headers: {
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

  // NOTE :- Get Goodealz Requests
  Future<Map<String, dynamic>?> getGoodealzRequests() async {
    Response res = await get('driver/gooddealz_requests', headers: {
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
  Future<Map<String, dynamic>?> getOrderDetails(String orderNum) async {
    Response res = await get('driver/order/$orderNum', headers: {
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
            : OrderDetailsModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Post Cancel Order
  Future<Map<String, dynamic>?> getChatWithDriverId(int driverId) async {
    Response res = await get('api/get_chat/$driverId', headers: {
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
        'data': (res.statusCode == 404)
            ? NoDataResponseModel.fromJson(res.body)
            : ChatMessagesModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Get Order Details
  Future<Map<String, dynamic>?> cancelOffer(String orderNum) async {
    Response res = await get('driver/order/$orderNum/cancel_offer', headers: {
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
            : NoDataResponseModel.fromJson(res.body),
      };
    }
  }
}
