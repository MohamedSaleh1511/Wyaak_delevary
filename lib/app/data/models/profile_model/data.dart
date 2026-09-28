import 'driver.dart';

class Data {
  Driver? driver;

  Data({this.driver});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        driver: json['driver'] == null
            ? null
            : Driver.fromJson(json['driver'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'driver': driver?.toJson(),
      };
}
