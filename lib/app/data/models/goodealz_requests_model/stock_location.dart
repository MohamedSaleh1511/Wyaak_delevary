class StockLocation {
  String? name;
  String? latitude;
  String? longitude;

  StockLocation({this.name, this.latitude, this.longitude});

  factory StockLocation.fromJson(Map<String, dynamic> json) {
    return StockLocation(
      name: json['name'] as String?,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
      };
}
