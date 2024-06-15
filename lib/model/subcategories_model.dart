// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:uday_interview/model/product_model.dart';

class SubCategoriesModel {
  int? id;
  String? name;
  List<ProductModel>? product;

  SubCategoriesModel({this.id, this.name, this.product});

  SubCategoriesModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    if (json['Product'] != null) {
      product = <ProductModel>[];
      json['Product'].forEach((v) {
        product!.add(ProductModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Name'] = name;
    if (product != null) {
      data['Product'] = product!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  SubCategoriesModel copyWith({
    int? id,
    String? name,
    List<ProductModel>? product,
  }) {
    return SubCategoriesModel(
      id: id ?? this.id,
      name: name ?? this.name,
      product: product ?? this.product,
    );
  }
}
