class GoodealzProductImage {
  int? id;
  String? productName;
  String? productImage;

  GoodealzProductImage({this.id, this.productName, this.productImage});

  factory GoodealzProductImage.fromJson(Map<String, dynamic> json) =>
      GoodealzProductImage(
        id: json['id'] as int?,
        productName: json['product_name'] as String?,
        productImage: json['product_image'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'product_name': productName,
        'product_image': productImage,
      };
}
