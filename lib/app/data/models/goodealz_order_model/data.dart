import 'package:wayaak_delivery/app/core/enums/enums.dart';
import 'package:wayaak_delivery/app/data/models/goodealz_requests_model/destination_location.dart';
import 'package:wayaak_delivery/app/data/models/goodealz_requests_model/product_image.dart';
import 'package:wayaak_delivery/app/data/models/goodealz_requests_model/stock_location.dart';
import 'package:wayaak_delivery/app/data/models/requests_model/driver.dart';
import 'user.dart';

class GoodealzData {
  int? id;
  dynamic vehicleCategory;
  String? orderNum;
  String? title;
  String? subtotal;
  String? discountedPrice;
  String? shippingCost;
  String? totalPrice;
  OrderStatus? orderStatus;
  User? user;
  OrderDetailsDriver? driver;
  List<GoodealzProductImage>? productImages;
  String? country;
  String? city;
  StockLocation? stock;
  DestinationLocation? destinationLocation;
  DateTime? createdAt;

  GoodealzData({
    this.id,
    this.vehicleCategory,
    this.orderNum,
    this.title,
    this.subtotal,
    this.discountedPrice,
    this.shippingCost,
    this.totalPrice,
    this.orderStatus,
    this.user,
    this.driver,
    this.productImages,
    this.country,
    this.city,
    this.stock,
    this.destinationLocation,
    this.createdAt,
  });

  factory GoodealzData.fromJson(Map<String, dynamic> json) => GoodealzData(
        id: json['id'] as int?,
        vehicleCategory: json['vehicle_category'] as dynamic,
        orderNum: json['order_num'] as String?,
        title: json['title'] as String?,
        subtotal: json['subtotal'].toString(),
        discountedPrice: json['discounted_price'] as String?,
        shippingCost: json['shipping_cost'] as String?,
        totalPrice: json['total_price'] as String?,
        orderStatus: OrderStatus.fromJson(json['order_status'].toString()),
        user: json['user'] == null
            ? null
            : User.fromJson(json['user'] as Map<String, dynamic>),
        driver: json['driver'] == null
            ? null
            : OrderDetailsDriver.fromJson(
                json['driver'] as Map<String, dynamic>),
        productImages: (json['product_images'] as List<dynamic>?)
            ?.map(
                (e) => GoodealzProductImage.fromJson(e as Map<String, dynamic>))
            .toList(),
        country: json['country'] as String?,
        city: json['city'] as String?,
        stock: json['stock'] == null
            ? null
            : StockLocation.fromJson(json['stock'] as Map<String, dynamic>),
        destinationLocation: json['destination_location'] == null
            ? null
            : DestinationLocation.fromJson(
                json['destination_location'] as Map<String, dynamic>),
        createdAt: DateTime.parse(json['created_at'].toString()),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'vehicle_category': vehicleCategory,
        'order_num': orderNum,
        'title': title,
        'subtotal': subtotal,
        'discounted_price': discountedPrice,
        'shipping_cost': shippingCost,
        'total_price': totalPrice,
        'order_status': orderStatus,
        'user': user?.toJson(),
        'driver': driver?.toJson(),
        'product_images': productImages?.map((e) => e.toJson()).toList(),
        'country': country,
        'city': city,
        'stock': stock?.toJson(),
        'destination_location': destinationLocation?.toJson(),
      };
}
