import 'package:uday_interview/model/category_data_model.dart';
import 'package:uday_interview/model/category_model.dart';

class CategoryResponse {
  int? status;
  String? message;
  CategroyModel? result;

  CategoryResponse({this.status, this.message, this.result});

  CategoryResponse.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    result = json['Result'] != null ? CategroyModel.fromJson(json['Result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['Message'] = message;
    if (result != null) {
      data['Result'] = result!.toJson();
    }
    return data;
  }
}

