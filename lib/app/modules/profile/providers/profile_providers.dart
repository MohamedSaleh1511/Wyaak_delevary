import 'dart:io';
import 'package:get/get.dart';
import 'package:wayaak_delivery/app/data/models/auth/signup_response_model.dart';
import 'package:wayaak_delivery/app/data/models/global_response_model.dart';
import 'package:wayaak_delivery/app/data/models/no_data_response_model.dart';
import 'package:wayaak_delivery/app/data/models/profile_model/profile_model.dart';
import 'package:wayaak_delivery/app/data/providers/api_provider.dart';
import 'package:wayaak_delivery/app/data/services/app_services.dart';

class ProfileProviders extends ApiProvider {
  // NOTE :- Post Update Profile
  Future<Map<String, dynamic>?> postUpdateProfile({
    String? name,
    String? email,
    String? gender,
    String? birthDate,
    File? avatar,
    File? carPhoto,
    File? frontLicense,
    File? backLicense,
    int? vehicleCategoryId,
    int? vehicleTypeId,
    String? vehicleMetalPlate,
    String? vehicleManufactureYear,
    String? licenceExpiryDate,
  }) async {
    Get.log("Driver Name : $name");
    Get.log("Driver Email : $email");
    Get.log("Driver Gender : $gender");
    Get.log("Driver Birthdate : $birthDate");
    Get.log("Driver avatar : ${avatar?.path}");
    Get.log("Driver carPhoto : ${carPhoto?.path}");
    Get.log("Driver frontLicense : ${frontLicense?.path}");
    Get.log("Driver backLicense : ${backLicense?.path}");
    Get.log("Driver Vehicle Category id : $vehicleCategoryId");
    Get.log("Driver Vehicle Type id : $vehicleTypeId");
    Get.log("Driver Vehicle Metal plate : $vehicleMetalPlate");
    Get.log("Driver Vehicle Model year : $vehicleManufactureYear");
    Get.log("Driver Vehicle Licence expiry date : $licenceExpiryDate");

    Response res = await post(
        'driver/update_profile',
        FormData({
          'name': name,
          'email': email,
          'gender': gender,
          'birth_date': birthDate,
          'vehicle_category_id': vehicleCategoryId,
          'vehicle_type_id': vehicleTypeId,
          'driver_photo': avatar!.path.isEmpty
              ? null
              : MultipartFile(avatar, filename: avatar.path.split('/').last),
          'vehicle_photo': carPhoto!.path.isEmpty
              ? null
              : MultipartFile(carPhoto,
                  filename: carPhoto.path.split('/').last),
          'front_license': frontLicense!.path.isEmpty
              ? null
              : MultipartFile(frontLicense,
                  filename: frontLicense.path.split('/').last),
          'back_license': backLicense!.path.isEmpty
              ? null
              : MultipartFile(backLicense,
                  filename: backLicense.path.split('/').last),
          'vehicle_metal_plate': vehicleMetalPlate,
          'vehicle_manufacture_year': vehicleManufactureYear,
          'license_expiry_date': licenceExpiryDate,
        }),
        headers: {
          'Authorization':
              'Bearer ${Get.find<AppServices>().accessToken.value}',
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

  // NOTE :- Post Reset Password
  Future<Map<String, dynamic>?> postResetPassword(
    String? oldPassword,
    String? password,
    String? passwordConfirmation,
  ) async {
    Response res = await post('driver/update_password', {
      'old_password': oldPassword,
      'password': password,
      'password_confirmation': passwordConfirmation,
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

  // NOTE :- Post Change Language
  Future<Map<String, dynamic>?> getChangeLanguage(String? language) async {
    Response res = await get('driver/change_language/$language', headers: {
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
        'data': (res.statusCode == 401)
            ? SignupResponseModel.fromJson(res.body)
            : GlobalResponseModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Post Change Language
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
            ? NoDataResponseModel.fromJson(res.body)
            : ProfileModel.fromJson(res.body),
      };
    }
  }
}
