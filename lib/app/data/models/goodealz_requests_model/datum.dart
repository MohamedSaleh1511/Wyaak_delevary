import 'package:wayaak_delivery/app/core/enums/enums.dart';
import 'package:wayaak_delivery/app/data/models/goodealz_order_model/user.dart';
import 'package:wayaak_delivery/app/data/models/goodealz_requests_model/stock_location.dart';

import 'destination_location.dart';
import 'product_image.dart';

class GoodealzDatum {
  int? id;
  String? orderNum;
  String? title;
  String? subtotal;
  String? discountedPrice;
  String? shippingCost;
  String? totalPrice;
  OrderStatus? orderStatus;
  User? user;
  dynamic driver;
  List<GoodealzProductImage>? productImages;
  StockLocation? stockLocation;
  DestinationLocation? destinationLocation;
  DateTime? createdAt;

  GoodealzDatum({
    this.id,
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
    this.destinationLocation,
    this.stockLocation,
    this.createdAt,
  });

  factory GoodealzDatum.fromJson(Map<String, dynamic> json) => GoodealzDatum(
        id: json['id'] as int?,
        orderNum: json['order_num'] as String?,
        title: json['title'] as String?,
        subtotal: json['subtotal'].toString(),
        discountedPrice: json['discounted_price'].toString(),
        shippingCost: json['shipping_cost'].toString(),
        totalPrice: json['total_price'].toString(),
        orderStatus: OrderStatus.fromJson(json['order_status'].toString()),
        user: json['user'] == null
            ? null
            : User.fromJson(json['user'] as Map<String, dynamic>),
        driver: json['driver'] as dynamic,
        productImages: (json['product_images'] as List<dynamic>?)
            ?.map(
                (e) => GoodealzProductImage.fromJson(e as Map<String, dynamic>))
            .toList(),
        destinationLocation: json['destination_location'] == null
            ? null
            : DestinationLocation.fromJson(
                json['destination_location'] as Map<String, dynamic>),
        stockLocation: json['stock'] == null
            ? null
            : StockLocation.fromJson(json['stock'] as Map<String, dynamic>),
        createdAt: DateTime.parse(json['created_at'].toString()),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'order_num': orderNum,
        'title': title,
        'subtotal': subtotal,
        'discounted_price': discountedPrice,
        'shipping_cost': shippingCost,
        'total_price': totalPrice,
        'order_status': orderStatus,
        'user': user?.toJson(),
        'driver': driver,
        'product_images': productImages?.map((e) => e.toJson()).toList(),
        'stock': stockLocation?.toJson(),
        'destination_location': destinationLocation?.toJson(),
      };
}
