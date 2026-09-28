import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animarker/flutter_map_marker_animation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' hide LocationAccuracy;
import 'package:lottie/lottie.dart' hide Marker;
import 'package:wayaak_delivery/app/core/helpers/helpers.dart';
import 'package:wayaak_delivery/app/modules/home/controllers/home_controller.dart';

class GoogleMapPart extends StatefulWidget {
  const GoogleMapPart({super.key});

  @override
  State<GoogleMapPart> createState() => _GoogleMapPartState();
}

class _GoogleMapPartState extends State<GoogleMapPart> {
  final locationController = Location();

  final HomeController homeController = Get.find<HomeController>();

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Uint8List? markerIcon;

  Map<PolylineId, Polyline> polylines = {};

  double bearing = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await initializeMap());

    getMarkerIcon();
  }

  getMarkerIcon() async {
    markerIcon = await getBytesFromAsset('assets/images/markercar.png', 24);
  }

  Future<void> initializeMap() async {
    await fetchLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 17,
      child: Obx(
        () => homeController.currentPosition.value.latitude == 0.0
            ? UnconstrainedBox(
                child:
                    Lottie.asset('assets/lotties/dots-loader.json', width: 80))
            : Animarker(
                curve: Curves.easeInOut,
                rippleRadius: 0.2,
                rippleColor: Get.theme.primaryColor,
                rippleDuration: const Duration(milliseconds: 2500),
                shouldAnimateCamera: true,
                zoom: 19,
                useRotation: true,
                mapId: _controller.future.then<int>((value) => value.mapId),
                duration: const Duration(milliseconds: 2000),
                markers: {
                  RippleMarker(
                    ripple: true,
                    markerId: const MarkerId('currentLocation'),
                    icon: markerIcon == null
                        ? BitmapDescriptor.defaultMarker
                        : BitmapDescriptor.bytes(markerIcon!),
                    anchor: const Offset(0.5, 0.5),
                    position: homeController.currentPosition.value,
                    infoWindow: InfoWindow(title: 'Driver Location'.tr),
                  ),
                },
                child: GoogleMap(
                  onMapCreated: (controller) {
                    _controller.complete(controller);
                  },
                  initialCameraPosition: CameraPosition(
                    target: homeController.currentPosition.value,
                    zoom: 19,
                  ),
                  compassEnabled: true,
                  mapType: MapType.normal,
                  zoomControlsEnabled: false,
                ),
              ),
      ),
    );
  }

  Future<void> fetchLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await locationController.requestService();
    } else {
      return;
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationController.onLocationChanged.listen((currentLocation) async {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        homeController.currentPosition.value = LatLng(
          currentLocation.latitude!,
          currentLocation.longitude!,
        );
        bearing = currentLocation.heading!;
        _controller.future.then(
          (value) => value.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(
                currentLocation.latitude!,
                currentLocation.longitude!,
              ),
            ),
          ),
        );
      }
    });
  }
}

Future<Position> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  // Check for location permissions
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permissions are permanently denied.');
  }

  // Get current location
  return await Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    ),
  );
}
