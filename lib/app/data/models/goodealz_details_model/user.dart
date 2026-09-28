class User {
  String? name;
  String? email;
  dynamic phone;

  User({this.name, this.email, this.phone});

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json['name'] as String?,
        email: json['email'] as String?,
        phone: json['phone'] as dynamic,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
      };
}
