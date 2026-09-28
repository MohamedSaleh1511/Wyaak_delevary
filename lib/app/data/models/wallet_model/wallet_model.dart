import 'data.dart';

class WalletModel {
  Data? data;
  String? message;
  int? status;

  WalletModel({this.data, this.message, this.status});

  factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
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
