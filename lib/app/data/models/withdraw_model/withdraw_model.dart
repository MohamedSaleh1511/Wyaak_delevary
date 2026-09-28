import 'data.dart';

class WithdrawModel {
  Data? data;
  String? message;
  int? status;

  WithdrawModel({this.data, this.message, this.status});

  factory WithdrawModel.fromJson(Map<String, dynamic> json) => WithdrawModel(
        data: json['data'] == null
            ? null
            : Data.fromJson(json['data'] as Map<String, dynamic>),
        message: json['message'] as String?,
        status: json['status'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'data': data?.toJson(),
        'message': message,
        'status': status,
      };
}
