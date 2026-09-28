import 'package:wayaak_delivery/app/core/enums/enums.dart';
import 'package:wayaak_delivery/app/data/models/requests_model/driver.dart';

import 'current_location.dart';
import 'destination_location.dart';
import 'product_image.dart';
import 'user.dart';
import 'vehicle_category.dart';

class RequestsDatum {
  int? id;
  VehicleCategory? vehicleCategory;
  String? orderNum;
  String? title;
  String? description;
  String? discountAmount;
  String? discountedPrice;
  String? shippingCost;
  String? totalPrice;
  OrderStatus? orderStatus;
  String? urgent;
  WayaakUser? user;
  OrderDetailsDriver? driver;
  List<ProductImage>? productImages;
  String? country;
  CurrentLocation? currentLocation;
  DestinationLocation? destinationLocation;
  String? paymentMethod;
  String? paymentStatus;
  DateTime? createdAt;
  DateTime? updatedAt;

  RequestsDatum({
    this.id,
    this.vehicleCategory,
    this.orderNum,
    this.title,
    this.description,
    this.discountAmount,
    this.discountedPrice,
    this.shippingCost,
    this.totalPrice,
    this.orderStatus,
    this.urgent,
    this.user,
    this.driver,
    this.productImages,
    this.country,
    this.currentLocation,
    this.destinationLocation,
    this.paymentMethod,
    this.paymentStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory RequestsDatum.fromJson(Map<String, dynamic> json) => RequestsDatum(
        id: json['id'] as int?,
        vehicleCategory: json['vehicle_category'] == null
            ? null
            : VehicleCategory.fromJson(
                json['vehicle_category'] as Map<String, dynamic>),
        orderNum: json['order_num'] as String?,
        title: json['title'] as String?,
        description: json['description'] as String?,
        discountAmount: json['discount_amount'].toString(),
        discountedPrice: json['discounted_price'].toString(),
        shippingCost: json['shipping_cost'].toString(),
        totalPrice: json['total_price'].toString(),
        orderStatus: OrderStatus.fromJson(json['order_status']),
        urgent: json['urgent'] as String?,
        user: json['user'] == null
            ? null
            : WayaakUser.fromJson(json['user'] as Map<String, dynamic>),
        driver: json['driver'] == null
            ? null
            : OrderDetailsDriver.fromJson(
                json['driver'] as Map<String, dynamic>),
        productImages: (json['product_images'] as List<dynamic>?)
            ?.map((e) => ProductImage.fromJson(e as Map<String, dynamic>))
            .toList(),
        country: json['country'] as String?,
        currentLocation: json['current_location'] == null
            ? null
            : CurrentLocation.fromJson(
                json['current_location'] as Map<String, dynamic>),
        destinationLocation: json['destination_location'] == null
            ? null
            : DestinationLocation.fromJson(
                json['destination_location'] as Map<String, dynamic>),
        paymentMethod: json['payment_method'].toString(),
        paymentStatus: json['payment_status'].toString(),
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
      );
}
