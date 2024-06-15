import 'package:uday_interview/model/product_model.dart';

class ProductResponse {
  int? status;
  String? message;
  List<ProductModel>? result;

  ProductResponse({this.status, this.message, this.result});

  ProductResponse.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    if (json['Result'] != null) {
      result = <ProductModel>[];
      json['Result'].forEach((v) {
        result!.add(ProductModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['Message'] = message;
    if (result != null) {
      data['Result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
