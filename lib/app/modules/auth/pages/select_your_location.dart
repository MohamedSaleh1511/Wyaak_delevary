import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
import 'package:wayaak_delivery/app/modules/auth/controllers/auth_controller.dart';
import 'package:wayaak_delivery/app/routes/app_routes.dart';

class SelectYourLocation extends GetView<AuthController> {
  const SelectYourLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return MapLocationPicker(
      config: MapLocationPickerConfig(
        apiKey:
            "AIzaSyAE0PTLuDwCLMCAdakZ3l6lEM6C7BJz3bc", // PROBE: Check if apiKey is here
        // hideMoreOptions: true, // Likely missing or renamed
        // hideMapTypeButton: true, // Likely missing or renamed
        onNext: (GeocodingResult? result) {
          final location = result?.geometry?.location;
          if (location != null) {
            controller.latitude.value = location.lat.toString();
            controller.longitude.value = location.lng.toString();
          }
          Get.toNamed(Routes.uploadUserImage);
        },
        onSuggestionSelected: (dynamic result) {
          if (result != null) {
            // Handle suggestion if needed
          }
        },
      ),
      // onPicked: (GeocodingResult? result) {
      //   if (result != null && result.geometry.location != null) {
      //     controller.latitude.value = result.geometry.location!.lat.toString();
      //     controller.longitude.value = result.geometry.location!.lng.toString();
      //   }
      //   Get.toNamed(Routes.uploadUserImage);
      // },
    );
    // return Scaffold(
    //   appBar: GlobalAppbar(title: 'Select Your Location'.tr),
    //   body: OpenStreetMapSearchAndPick(
    //     locationPinIcon: Icons.pin_drop_rounded,
    //     locationPinText: '',
    //     locationPinIconColor: Get.theme.primaryColor,
    //     buttonTextStyle:
    //         const TextStyle(fontSize: 18, fontStyle: FontStyle.normal),
    //     buttonColor: Get.theme.primaryColor,
    //     buttonText: 'Select'.tr,
    //     onPicked: (pickedData) {
    //       controller.latitude.value = pickedData.latLong.latitude.toString();
    //       controller.longitude.value = pickedData.latLong.longitude.toString();
    //       Get.toNamed(Routes.uploadUserImage);
    //     },
    //   ),
    // );
  }
}
