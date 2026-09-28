class Stock {
  String? name;
  String? latitude;
  String? longitude;

  Stock({this.name, this.latitude, this.longitude});

  factory Stock.fromJson(Map<String, dynamic> json) => Stock(
        name: json['name'] as String?,
        latitude: json['latitude'] as String?,
        longitude: json['longitude'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
      };
}
