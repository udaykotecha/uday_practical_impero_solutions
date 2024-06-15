// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProductModel {
  String? name;
  String? priceCode;
  String? imageName;
  int? id;

  ProductModel({this.name, this.priceCode, this.imageName, this.id});

  ProductModel.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    priceCode = json['PriceCode'];
    imageName = json['ImageName'];
    id = json['Id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Name'] = name;
    data['PriceCode'] = priceCode;
    data['ImageName'] = imageName;
    data['Id'] = id;
    return data;
  }

  ProductModel copyWith({
    String? name,
    String? priceCode,
    String? imageName,
    int? id,
  }) {
    return ProductModel(
      name: name ?? this.name,
      priceCode: priceCode ?? this.priceCode,
      imageName: imageName ?? this.imageName,
      id: id ?? this.id,
    );
  }
}
