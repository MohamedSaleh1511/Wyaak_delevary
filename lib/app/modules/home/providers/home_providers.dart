import 'package:get/get.dart';
import 'package:wayaak_delivery/app/data/models/delivery_cost_model/delivery_cost_model.dart';
import 'package:wayaak_delivery/app/data/models/global_response_model.dart';
import 'package:wayaak_delivery/app/data/models/goodealz_order_model/goodealz_order_model.dart';
import 'package:wayaak_delivery/app/data/models/no_data_response_model.dart';
import 'package:wayaak_delivery/app/data/models/profile_model/profile_model.dart';
import 'package:wayaak_delivery/app/data/providers/api_provider.dart';
import 'package:wayaak_delivery/app/data/services/app_services.dart';

class HomeProviders extends ApiProvider {
  // NOTE :- Get Profile
  Future<Map<String, dynamic>?> checkBroadcastAuth(
      {required String socketId, required String channelName}) async {
    Response res = await post('driver/broadcasting/auth', {
      "socket_id": socketId,
      "channel_name": channelName,
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
        'data': res.body,
      };
    }
  }

  // NOTE :- Get Profile
  Future<Map<String, dynamic>?> postAddCost(
      {required String orderNum, required String price}) async {
    Response res = await post('driver/order/$orderNum/send_amount', {
      "price": price,
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
        'data': res.body,
      };
    }
  }

  // NOTE :- Get Profile
  Future<Map<String, dynamic>?> getChooseGoodealzOrder(
      {required String orderNum}) async {
    Response res = await get('driver/choose_order/$orderNum', headers: {
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
            ? NoDataResponseModel.fromJson(res.body)
            : GoodealzOrderModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Get Profile
  Future<Map<String, dynamic>?> getDeliveryCostRestrictions(
      {required String orderNum, required double distance}) async {
    Response res = await post('driver/$orderNum/calculate_min_max', {
      "distance": distance,
    }, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Get.find<AppServices>().accessToken.value}',
    });
    Get.log("ssss ${distance} -- ${res.statusCode}");
    if (res.status.isServerError) {
      return null;
    } else if (res.status.connectionError) {
      return {'error': true};
    } else if (res.statusCode == 200 || res.statusCode == 201) {
      Get.log(" --- ${res.statusCode.toString()}");
      if (res.body is Map<String, dynamic>) {
        return {
          'code': res.statusCode!,
          'data': res.body is Map<String, dynamic>
              ? DeliveryCostModel.fromJson(res.body)
              : [],
        };
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  // NOTE :- Post Log out
  Future<Map<String, dynamic>?> postLogout() async {
    Response res = await post('driver/logout', {}, headers: {
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
        'data': (res.statusCode == 200)
            ? NoDataResponseModel.fromJson(res.body)
            : GlobalResponseModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Get Delete Account
  Future<Map<String, dynamic>?> deleteAccount() async {
    Response res = await get('driver/delete_account', headers: {
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
        'data': GlobalResponseModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Get Delete Account
  Future<Map<String, dynamic>?> changeNotification(bool status) async {
    Response res = await post('driver/notifications_status', {
      "status": status ? "on" : "off",
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
        'data': NoDataResponseModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Get update location
  Future<Map<String, dynamic>?> updateLocation(
      double latitude, double longitude) async {
    Response res = await post('driver/update_location', {
      "latitude": latitude,
      "longitude": longitude,
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
        'data': ProfileModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Get Profile
  Future<Map<String, dynamic>?> getProfile() async {
    Response res = await get('driver/my_profile', headers: {
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
            : ProfileModel.fromJson(res.body),
      };
    }
  }
}
