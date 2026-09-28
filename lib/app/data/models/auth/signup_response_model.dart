class SignupResponseModel {
  dynamic data;
  String? message;
  int? status;

  SignupResponseModel({this.data, this.message, this.status});

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) {
    return SignupResponseModel(
      data: json['data'] as dynamic,
      message: json['message'] as String?,
      status: json['status'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data,
        'message': message,
        'status': status,
      };
}
