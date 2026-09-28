import 'datum.dart';

class GoodealzRequestsModel {
  List<GoodealzDatum>? data;
  String? message;
  int? status;

  GoodealzRequestsModel({this.data, this.message, this.status});

  factory GoodealzRequestsModel.fromJson(Map<String, dynamic> json) {
    return GoodealzRequestsModel(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => GoodealzDatum.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
      status: json['status'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data?.map((e) => e.toJson()).toList(),
        'message': message,
        'status': status,
      };
}
