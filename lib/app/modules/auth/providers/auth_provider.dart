import 'package:get/get.dart';
import 'package:wayaak_delivery/app/data/models/auth/signup_model.dart';
import 'package:wayaak_delivery/app/data/models/auth/signup_response_model.dart';
import 'package:wayaak_delivery/app/data/models/auth/signup_social_model.dart';
import 'package:wayaak_delivery/app/data/models/global_response_model.dart';
import 'package:wayaak_delivery/app/data/models/login_response_model/login_response_model.dart';
import 'package:wayaak_delivery/app/data/models/no_data_response_model.dart';
import 'package:wayaak_delivery/app/data/models/vehicles_category_model/vehicles_category_model.dart';
import 'package:wayaak_delivery/app/data/providers/api_provider.dart';

class AuthProviders extends ApiProvider {
  // NOTE :- Post Register
  Future<Map<String, dynamic>?> postRegister(SignupRequestModel data) async {
    Response res = await post('driver/register', FormData(data.toJson()));
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

  // NOTE :- Post Register
  Future<Map<String, dynamic>?> getVehicleCategories() async {
    Response res = await get('driver/vehicle_categories');
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
            : VehiclesCategoryModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Post Register
  Future<Map<String, dynamic>?> getVehicleTypes(int vehicleCategoryId) async {
    Response res =
        await get('driver/get_vehicle_category_types/$vehicleCategoryId');
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
            : VehiclesCategoryModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Post Update FCM Token
  Future<Map<String, dynamic>?> putFCMToken(String fcmToken) async {
    Response res = await post('driver/update_fcm', {"fcm_token": fcmToken});
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
            : SignupResponseModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Post Login
  Future<Map<String, dynamic>?> postLogin(
      String? phone, String? password, String? fcmToken) async {
    Response res = await post('driver/login', {
      'phone': phone,
      'password': password,
      'fcm_token': fcmToken,
      'language': Get.locale == null ? 'en' : Get.locale!.languageCode,
    }, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    if (res.status.isServerError) {
      return null;
    } else if (res.status.connectionError) {
      return {'error': true};
    } else {
      Get.log(res.statusCode.toString());
      return {
        'code': res.statusCode!,
        'data': (res.statusCode == 400)
            ? GlobalResponseModel.fromJson(res.body)
            : (res.statusCode == 403 || res.statusCode == 401)
                ? NoDataResponseModel.fromJson(res.body)
                : LoginResponseModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Post Verification Phone
  Future<Map<String, dynamic>?> postVerify(
      String? phone, String? loginCode) async {
    Response res = await post('driver/register/verify_phone',
        {'phone': phone, 'login_code': loginCode});
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

  // NOTE :- Get Forget Password
  Future<NoDataResponseModel?> getForgetPassword(String? phone) async {
    Response res = await get('driver/forgot_password?phone=$phone');
    if (res.status.isServerError || res.status.connectionError) {
      return null;
    } else {
      Get.log(res.statusCode.toString());
      return NoDataResponseModel.fromJson(res.body);
    }
  }

  // NOTE :- Post Check Reset Code
  Future<Map<String, dynamic>?> postCheckResetCode(
      String? phone, String? loginCode) async {
    Response res = await post('driver/check_reset_code',
        {'phone': phone, 'reset_password_code': loginCode});
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

  // NOTE :- Post Reset Password
  Future<Map<String, dynamic>?> postResetPassword(
    String? phone,
    String? password,
    String? passwordConfirmation,
  ) async {
    Response res = await post('driver/reset_password', {
      'phone': phone,
      'password': password,
      'password_confirmation': passwordConfirmation,
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

  // NOTE :- Post Social Register
  Future<Map<String, dynamic>?> postSocialRegister(
      SignupSocialRequestModel data) async {
    Response res =
        await post('driver/social/register', FormData(data.toJson()));
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

  // NOTE :- Post Social Register
  Future<Map<String, dynamic>?> postSocialLogin({
    String? socialMediaId,
    String? provider,
    String? fcmToken,
  }) async {
    Response res = await post('driver/social/login', {
      'social_media_id': socialMediaId,
      'provider': provider,
      "fcm_token": fcmToken,
      'language': Get.locale == null ? 'en' : Get.locale!.languageCode,
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
            : LoginResponseModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Post Login As Guest
  Future<Map<String, dynamic>?> postLoginAsGuest() async {
    Response res = await post('driver/login_as_guest', {});
    if (res.status.isServerError) {
      return null;
    } else if (res.status.connectionError) {
      return {'error': true};
    } else {
      Get.log(res.statusCode.toString());
      return {
        'code': res.statusCode!,
        'data': (res.statusCode == 400)
            ? GlobalResponseModel.fromJson(res.body)
            : NoDataResponseModel.fromJson(res.body),
      };
    }
  }
}
