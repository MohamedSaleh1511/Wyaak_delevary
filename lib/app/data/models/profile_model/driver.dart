import 'vehicle.dart';

class Driver {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? gender;
  String? birthDate;
  String? language;
  String? driverPhoto;
  String? location;
  String? wallet;
  int? notifiable;
  String? fcmToken;
  String? rate;
  Vehicle? vehicle;

  Driver({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.gender,
    this.birthDate,
    this.language,
    this.driverPhoto,
    this.location,
    this.wallet,
    this.notifiable,
    this.fcmToken,
    this.rate,
    this.vehicle,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        id: json['id'] as int?,
        name: json['name'] as String?,
        email: json['email'] as String?,
        phone: json['phone'] as String?,
        gender: json['gender'] as String?,
        birthDate: json['birth_date'] as String?,
        language: json['language'] as String?,
        driverPhoto: json['driver_photo'] as String?,
        location: json['location'] as String?,
        wallet: json['wallet'].toString(),
        notifiable: json['notifiable'] as int?,
        fcmToken: json['fcm_token'] as String?,
        rate: json['rate'] as String?,
        vehicle: json['vehicle'] == null
            ? null
            : Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'gender': gender,
        'birth_date': birthDate,
        'language': language,
        'driver_photo': driverPhoto,
        'location': location,
        'wallet': wallet,
        'notifiable': notifiable,
        'fcm_token': fcmToken,
        'rate': rate,
        'vehicle': vehicle?.toJson(),
      };
}
