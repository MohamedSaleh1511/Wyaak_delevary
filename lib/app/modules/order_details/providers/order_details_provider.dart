import 'package:get/get.dart';
import 'package:wayaak_delivery/app/data/models/chat_messages_model/chat_messages_model.dart';
import 'package:wayaak_delivery/app/data/models/global_response_model.dart';
import 'package:wayaak_delivery/app/data/models/goodealz_details_model/goodealz_details_model.dart';
import 'package:wayaak_delivery/app/data/models/no_data_response_model.dart';
import 'package:wayaak_delivery/app/data/models/order_details_model/order_details_model.dart';
import 'package:wayaak_delivery/app/data/providers/api_provider.dart';
import 'package:wayaak_delivery/app/data/services/app_services.dart';

class OrderDetailsProvider extends ApiProvider {
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

  // NOTE :- Get Order Details
  Future<Map<String, dynamic>?> getGoodealzDetails(String orderNum) async {
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
            : GoodealzDetailsModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Get Update Order Status
  Future<Map<String, dynamic>?> updateOrderStatus(String orderNum) async {
    Response res = await get('driver/order_updated/$orderNum', headers: {
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

  // NOTE :- Post Cancel Order
  Future<Map<String, dynamic>?> getChatWithDriverId(int driverId) async {
    Response res = await get('driver/get_chat/$driverId', headers: {
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

  // NOTE :- Get Update Order Status
  Future<Map<String, dynamic>?> confirmDelivery(
      String orderNum, String otpCode) async {
    Response res = await post('driver/confirm_delivery/$orderNum', {
      'delivered_code': otpCode,
    }, headers: {
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
