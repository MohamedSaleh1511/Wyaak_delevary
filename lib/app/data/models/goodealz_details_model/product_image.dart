class ProductImage {
  int? id;
  String? productName;
  String? productImage;

  ProductImage({this.id, this.productName, this.productImage});

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
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
