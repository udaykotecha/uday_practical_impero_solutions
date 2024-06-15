import 'package:uday_interview/model/category_data_model.dart';

class CategroyModel {
  List<CategoryDataModel>? category;

  CategroyModel({this.category});

  CategroyModel.fromJson(Map<String, dynamic> json) {
    if (json['Category'] != null) {
      category = <CategoryDataModel>[];
      json['Category'].forEach((v) {
        category!.add(CategoryDataModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (category != null) {
      data['Category'] = category!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
