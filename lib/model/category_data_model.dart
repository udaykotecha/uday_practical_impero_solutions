import 'package:uday_interview/model/subcategories_model.dart';

class CategoryDataModel {
  int? id;
  String? name;
  int? isAuthorize;
  int? update080819;
  int? update130919;
  List<SubCategoriesModel>? subCategories;

  CategoryDataModel({this.id, this.name, this.isAuthorize, this.update080819, this.update130919, this.subCategories});

  CategoryDataModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    isAuthorize = json['IsAuthorize'];
    update080819 = json['Update080819'];
    update130919 = json['Update130919'];
    if (json['SubCategories'] != null) {
      subCategories = <SubCategoriesModel>[];
      json['SubCategories'].forEach((v) {
        subCategories!.add(SubCategoriesModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Name'] = name;
    data['IsAuthorize'] = isAuthorize;
    data['Update080819'] = update080819;
    data['Update130919'] = update130919;
    if (subCategories != null) {
      data['SubCategories'] = subCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
