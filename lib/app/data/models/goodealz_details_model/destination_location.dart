class DestinationLocation {
  String? title;
  String? latitude;
  String? longitude;

  DestinationLocation({this.title, this.latitude, this.longitude});

  factory DestinationLocation.fromJson(Map<String, dynamic> json) {
    return DestinationLocation(
      title: json['title'] as String?,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'latitude': latitude,
        'longitude': longitude,
      };
}
