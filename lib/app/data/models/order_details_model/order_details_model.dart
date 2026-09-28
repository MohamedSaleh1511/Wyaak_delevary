import 'package:wayaak_delivery/app/data/models/requests_model/datum.dart';

class OrderDetailsModel {
  RequestsDatum? data;
  String? message;
  int? status;

  OrderDetailsModel({this.data, this.message, this.status});

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsModel(
      data: json['data'] == null
          ? null
          : RequestsDatum.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
      status: json['status'] as int?,
    );
  }
}
