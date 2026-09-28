import 'data.dart';

class GoodealzOrderModel {
  GoodealzData? data;
  String? message;
  int? status;

  GoodealzOrderModel({this.data, this.message, this.status});

  factory GoodealzOrderModel.fromJson(Map<String, dynamic> json) {
    return GoodealzOrderModel(
      data: json['data'] == null
          ? null
          : GoodealzData.fromJson(json['data'] as Map<String, dynamic>),
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
