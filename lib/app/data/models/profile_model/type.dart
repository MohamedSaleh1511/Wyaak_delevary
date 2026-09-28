class Type {
  int? id;
  String? name;
  String? image;

  Type({this.id, this.name, this.image});

  factory Type.fromJson(Map<String, dynamic> json) => Type(
        id: json['id'] as int?,
        name: json['name'] as String?,
        image: json['image'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
      };
}
