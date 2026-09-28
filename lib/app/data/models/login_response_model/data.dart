import 'driver.dart';

class Data {
  Driver? driver;
  String? accessToken;

  Data({this.driver, this.accessToken});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        driver: json['driver'] == null
            ? null
            : Driver.fromJson(json['driver'] as Map<String, dynamic>),
        accessToken: json['access_token'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'driver': driver?.toJson(),
        'access_token': accessToken,
      };
}
