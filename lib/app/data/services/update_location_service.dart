import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wayaak_delivery/app/data/constants/constants.dart';
import 'package:wayaak_delivery/app/data/services/app_services.dart';

class UpdateLocationService extends GetxService {
  Timer? _timer;
  Timer? _trackTimer;
  final AppServices appService = Get.find<AppServices>();
  final GetConnect connect = GetConnect();

  void startPolling() {
    _timer =
        Timer.periodic(const Duration(seconds: 25), (_) => _updateLocation());
  }

  void startTracking(String orderNum) {
    _trackTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _updateTracking(orderNum),
    );
  }

  void stopPolling() {
    _timer?.cancel();
  }

  void stopTracking() {
    _trackTimer?.cancel();
  }

  Future<void> _updateLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high, distanceFilter: 10),
      );
      double lat = position.latitude;
      double lng = position.longitude;

      final response = await connect.post(
        '${Constants.baseUrl}driver/update_location',
        {
          'latitude': lat,
          'longitude': lng,
        },
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${appService.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        debugPrint('Location updated: $lat, $lng');
      } else {
        debugPrint('Failed to update: ${response.statusText}');
      }
    } catch (e) {
      debugPrint('Error updating location: $e');
    }
  }

  Future<void> _updateTracking(String orderNum) async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high, distanceFilter: 10),
      );
      double lat = position.latitude;
      double lng = position.longitude;

      final response = await connect.post(
        '${Constants.baseUrl}driver/updated_location/$orderNum',
        {
          'latitude': lat,
          'longitude': lng,
        },
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${appService.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        debugPrint('Tracking updated: $lat, $lng');
      } else {
        debugPrint('Failed to update track: ${response.statusText}');
      }
    } catch (e) {
      debugPrint('Error updating tracking: $e');
    }
  }

  @override
  void onClose() {
    stopPolling();
    stopTracking();
    super.onClose();
  }
}
