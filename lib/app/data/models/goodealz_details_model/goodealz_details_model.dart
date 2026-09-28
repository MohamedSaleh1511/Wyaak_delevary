import 'package:wayaak_delivery/app/data/models/goodealz_requests_model/datum.dart';

class GoodealzDetailsModel {
  GoodealzDatum? data;
  String? message;
  int? status;

  GoodealzDetailsModel({this.data, this.message, this.status});

  factory GoodealzDetailsModel.fromJson(Map<String, dynamic> json) {
    return GoodealzDetailsModel(
      data: json['data'] == null
          ? null
          : GoodealzDatum.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
      status: json['status'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data?.toJson(),
        'message': message,
        'status': status,
      };
}
