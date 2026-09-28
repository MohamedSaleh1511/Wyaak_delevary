import 'datum.dart';

class RequestsModel {
  List<RequestsDatum>? data;
  String? message;
  int? status;

  RequestsModel({this.data, this.message, this.status});

  factory RequestsModel.fromJson(Map<String, dynamic> json) => RequestsModel(
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => RequestsDatum.fromJson(e as Map<String, dynamic>))
            .toList(),
        message: json['message'] as String?,
        status: json['status'] as int?,
      );
}
