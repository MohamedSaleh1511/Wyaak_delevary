import 'dart:io';

import 'package:get/get.dart';

class SignupSocialRequestModel {
  String? name;
  String? email;
  String? phone;
  String? socialMediaId;
  String? provider;
  File? driverPhoto;
  File? vehiclePhoto;
  File? frontLicense;
  File? backLicense;
  int? vehicleCategoryId;
  int? vehicleTypeId;
  String? vehicleMetalPlate;
  int? vehicleManufactureYear;
  String? licenseExpiryDate;

  SignupSocialRequestModel({
    this.socialMediaId,
    this.name,
    this.email,
    this.phone,
    this.provider,
    this.driverPhoto,
    this.vehiclePhoto,
    this.frontLicense,
    this.backLicense,
    this.vehicleCategoryId,
    this.vehicleTypeId,
    this.vehicleMetalPlate,
    this.vehicleManufactureYear,
    this.licenseExpiryDate,
  });
  Map<String, dynamic> toJson() => {
        'social_media_id': socialMediaId,
        'name': name,
        'email': email,
        'phone': phone,
        'provider': provider,
        'driver_photo': driverPhoto!.path.isEmpty
            ? null
            : MultipartFile(driverPhoto,
                filename: driverPhoto!.path.split('/').last),
        'vehicle_photo': vehiclePhoto!.path.isEmpty
            ? null
            : MultipartFile(vehiclePhoto,
                filename: vehiclePhoto!.path.split('/').last),
        'front_license': frontLicense!.path.isEmpty
            ? null
            : MultipartFile(frontLicense,
                filename: frontLicense!.path.split('/').last),
        'back_license': backLicense!.path.isEmpty
            ? null
            : MultipartFile(backLicense,
                filename: backLicense!.path.split('/').last),
        'vehicle_category_id': vehicleCategoryId,
        'vehicle_type_id': vehicleTypeId,
        'vehicle_metal_plate': vehicleMetalPlate,
        'vehicle_manufacture_year': vehicleManufactureYear,
        'license_expiry_date': licenseExpiryDate,
        'language': Get.locale == null ? 'en' : Get.locale!.languageCode,
      };
}
