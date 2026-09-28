import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wayaak_delivery/app/core/helpers/helpers.dart';
import 'package:wayaak_delivery/app/core/helpers/notification_helper.dart';
import 'package:wayaak_delivery/app/modules/order_details/controllers/order_details_controller.dart';
import 'dart:ui' as ui;
import 'dart:developer';
import 'dart:math' as math;

class GoodealzDetailsMap extends StatefulWidget {
  final LatLng sourceLocation;
  final LatLng destinationLocation;

  const GoodealzDetailsMap({
    super.key,
    required this.sourceLocation,
    required this.destinationLocation,
  });

  @override
  createState() => _LiveTrackingMapState();
}

class _LiveTrackingMapState extends State<GoodealzDetailsMap> {
  final OrderDetailsController orderDetailsController =
      Get.find<OrderDetailsController>();
  double bearing = 0.0;
  GoogleMapController? mapController;
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  Set<Marker> markers = {};
  LatLng? currentDriverLocation;
  StreamSubscription<Position>? locationSubscription;
  BitmapDescriptor? customDriverIcon;
  BitmapDescriptor? customDestinationIcon;

  // Store distances and ETAs
  Map<String, double> distances = {};
  Map<String, Duration> estimatedTimes = {};
  LatLng? previousDriverLocation;
  late Timer timer;

  final _mapKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await updateInFirst();
      await _loadCustomMarkers();
      // initializeMap();
      _addFixedLocationMarkers();
      _listenToDriverLocation();
      await updatePolylines();
    });
  }

  updateInFirst() {
    Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    )).then((v) {
      setState(() {
        currentDriverLocation = LatLng(v.latitude, v.longitude);
      });

      double distance = calculateDistance2(
        currentLoc: currentDriverLocation!,
        destination: LatLng(
          widget.destinationLocation.latitude,
          widget.destinationLocation.longitude,
        ),
      );

      if (distance < 1) {
        NotificationsHelper.show(const RemoteMessage());
      }
      _updateDriverMarker(LatLng(v.latitude, v.longitude));
    });
  }

  Future<BitmapDescriptor> _createCustomMarkerBitmap(String assetPath,
      {int size = 40}) async {
    try {
      // Load the image file
      final ByteData imageData = await rootBundle.load(assetPath);
      final Uint8List uint8List = imageData.buffer.asUint8List();

      // Create ImageCodec
      final ui.Codec codec = await ui.instantiateImageCodec(
        uint8List,
        targetHeight: size,
      );

      // Get the first frame
      final ui.FrameInfo fi = await codec.getNextFrame();

      // Convert to byte data
      final ByteData? byteData = await fi.image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        throw Exception('Failed to convert image to byte data');
      }

      final Uint8List resizedImageData = byteData.buffer.asUint8List();

      return BitmapDescriptor.bytes(resizedImageData);
    } catch (e) {
      debugPrint('Error creating custom marker: $e');
      // Fallback to default marker if custom one fails
      return BitmapDescriptor.defaultMarker;
    }
  }

// Modified marker loading function
  Future<void> _loadCustomMarkers() async {
    try {
      // Make sure to use proper path and verify assets are included in pubspec.yaml
      customDriverIcon =
          await _createCustomMarkerBitmap('assets/images/markercar.png');

      customDestinationIcon =
          await _createCustomMarkerBitmap('assets/images/map_flag.png');

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('Error loading custom markers: $e');
    }
  }

  void _addFixedLocationMarkers() {
    markers.add(
      Marker(
        markerId: const MarkerId('Source'),
        position: widget.sourceLocation,
        icon: customDestinationIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(
          title: 'Source Loc',
          snippet: _getMarkerSnippet('Source'),
        ),
      ),
    );

    markers.add(
      Marker(
        markerId: const MarkerId('destination2'),
        position: widget.destinationLocation,
        icon: customDestinationIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: InfoWindow(
          title: 'Destination Loc',
          snippet: _getMarkerSnippet('destination2'),
        ),
      ),
    );
  }

  double _calculateBearing(LatLng from, LatLng to) {
    final double lat1 = from.latitude * math.pi / 180;
    final double lon1 = from.longitude * math.pi / 180;
    final double lat2 = to.latitude * math.pi / 180;
    final double lon2 = to.longitude * math.pi / 180;

    final double dLon = lon2 - lon1;

    final double y = math.sin(dLon) * math.cos(lat2);
    final double x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    final double bearing = math.atan2(y, x);
    return (bearing * 180 / math.pi + 360) % 360; // Convert to degrees
  }

  void _updateCamera(LatLng newLocation) {
    if (mapController == null) return;

    mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: newLocation,
          zoom: 15,
          bearing: bearing, // Rotate the camera to match the car's direction
        ),
      ),
    );
  }

  String _getMarkerSnippet(String destinationId) {
    final distance = distances[destinationId];
    final eta = estimatedTimes[destinationId];
    if (distance == null || eta == null) return 'Calculating...';

    return 'Distance: ${distance.toStringAsFixed(1)} km\n'
        'ETA: ${eta.inMinutes} mins';
  }

  void _updateDriverMarker(LatLng newLocation) {
    try {
      markers
          .removeWhere((marker) => marker.markerId == const MarkerId('driver'));

      markers.add(
        Marker(
          markerId: const MarkerId('driver'),
          position: newLocation,
          rotation: bearing,
          icon: customDriverIcon ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          flat: true,
          anchor: const Offset(0.5, 0.5),
          infoWindow: InfoWindow(
            title: 'Driver',
            snippet: 'Heading: ${bearing.toStringAsFixed(1)}°',
          ),
        ),
      );
      log('Driver marker updated successfully with bearing: $bearing');
    } catch (e) {
      log('Error updating driver marker: $e');
    }
  }

///////////////////////////////////////////////////////////////////////////////////
  void _listenToDriverLocation() {
    locationSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen((newLocation) {
      setState(() {
        orderDetailsController.driverLiveLocation.value =
            LatLng(newLocation.latitude, newLocation.longitude);
        previousDriverLocation = currentDriverLocation;
        currentDriverLocation =
            LatLng(newLocation.latitude, newLocation.longitude);

        if (previousDriverLocation != null) {
          bearing = _calculateBearing(
            previousDriverLocation!,
            currentDriverLocation!,
          );
          log('Calculated bearing: $bearing degrees');
        }

        _updateDriverMarker(
            LatLng(newLocation.latitude, newLocation.longitude));

        _updateCamera(LatLng(newLocation.latitude, newLocation.longitude));

        updatePolylines();
      });
    });
  }

  LatLngBounds calculateBounds(List<LatLng> positions) {
    double minLat = positions[0].latitude;
    double maxLat = positions[0].latitude;
    double minLng = positions[0].longitude;
    double maxLng = positions[0].longitude;

    for (var pos in positions) {
      if (pos.latitude < minLat) minLat = pos.latitude;
      if (pos.latitude > maxLat) maxLat = pos.latitude;
      if (pos.longitude < minLng) minLng = pos.longitude;
      if (pos.longitude > maxLng) maxLng = pos.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  Future<void> updatePolylines() async {
    if (currentDriverLocation == null) {
      Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      )).then((v) {
        setState(() {
          currentDriverLocation = LatLng(v.latitude, v.longitude);
          orderDetailsController.driverLiveLocation.value =
              LatLng(v.latitude, v.longitude);
        });
      });
    }

    // Get routes for both destinations
    final routes = await Future.wait([
      getRouteDetails(currentDriverLocation!, widget.sourceLocation, 'Source'),
      getRouteDetails(
          currentDriverLocation!, widget.destinationLocation, 'destination2'),
    ]);

    setState(() {
      // Update polylines and calculations for both routes
      for (var route in routes) {
        if (route.points.isNotEmpty) {
          addPolyline(
            'poly${route.id}',
            route.points,
            route.id == 'Source' ? Colors.red : Colors.blue,
          );

          // Update distances and ETAs
          distances[route.id] = route.distance;
          estimatedTimes[route.id] = route.duration;

          // Update marker snippets
          updateMarkerInfo(route.id);
        }
      }
    });
  }

  void updateMarkerInfo(String destinationId) {
    final markerId = MarkerId(destinationId);
    final existingMarker = markers.firstWhere(
      (m) => m.markerId == markerId,
      orElse: () => throw Exception('Marker not found'),
    );

    markers.remove(existingMarker);
    markers.add(existingMarker.copyWith(
      infoWindowParam: InfoWindow(
        title:
            'Destination ${destinationId.substring(destinationId.length - 1)}',
        snippet: _getMarkerSnippet(destinationId),
      ),
    ));
  }

  Future<RouteDetails> getRouteDetails(
      LatLng origin, LatLng destination, String id) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: 'AIzaSyAE0PTLuDwCLMCAdakZ3l6lEM6C7BJz3bc',
      request: PolylineRequest(
        origin: PointLatLng(origin.latitude, origin.longitude),
        destination: PointLatLng(destination.latitude, destination.longitude),
        mode: TravelMode.driving,
      ),
    );
    List<LatLng> points = result.points
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();

    // Calculate distance in kilometers
    double distance = calculateDistance(points);

    // Estimate duration (assuming average speed of 40 km/h)
    Duration duration = Duration(minutes: (distance / 40 * 60).round());

    return RouteDetails(
      id: id,
      points: points,
      distance: distance,
      duration: duration,
    );
  }

  double calculateDistance(List<LatLng> points) {
    double totalDistance = 0;
    for (int i = 0; i < points.length - 1; i++) {
      totalDistance += calculatePointDistance(
        points[i].latitude,
        points[i].longitude,
        points[i + 1].latitude,
        points[i + 1].longitude,
      );
    }
    return totalDistance;
  }

  double calculatePointDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    double dLat = toRadians(lat2 - lat1);
    double dLon = toRadians(lon2 - lon1);

    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(toRadians(lat1)) *
            math.cos(toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  double toRadians(double degree) {
    return degree * math.pi / 180;
  }

  void addPolyline(String id, List<LatLng> points, Color color) {
    PolylineId polylineId = PolylineId(id);
    Polyline polyline = Polyline(
      polylineId: polylineId,
      color: color,
      points: points,
      width: 3,
      patterns: [PatternItem.dash(20), PatternItem.gap(10)],
    );
    polylines[polylineId] = polyline;
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      key: _mapKey,
      initialCameraPosition: CameraPosition(
        target: widget.sourceLocation,
        zoom: 18,
      ),
      markers: markers,
      polylines: Set<Polyline>.of(polylines.values),
      onMapCreated: (GoogleMapController controller) {
        mapController = controller;
      },
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      mapToolbarEnabled: true,
      zoomControlsEnabled: true,
    );
  }

  @override
  void dispose() {
    locationSubscription?.cancel();
    mapController?.dispose();
    // timer.cancel();
    super.dispose();
  }
}

class RouteDetails {
  final String id;
  final List<LatLng> points;
  final double distance;
  final Duration duration;

  RouteDetails({
    required this.id,
    required this.points,
    required this.distance,
    required this.duration,
  });
}
