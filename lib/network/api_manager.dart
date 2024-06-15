// ignore_for_file: unrelated_type_equality_checks

import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uday_interview/response/common_response.dart';
import 'package:uday_interview/utlis/toast.dart';

class ApiManager {
  static Future<bool> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  Future postCall(String url, Map<String, dynamic> request, BuildContext context) async {
    try {
      var uri = Uri.parse(url);

      final headers = await getHeaders();
      log(headers.toString());
      log(uri.toString());
      log(request.toString());
      http.Response response = await http.post(uri, body: jsonEncode(request), headers: headers);
      if (response.statusCode == 401) {
        log("${response.statusCode}");
        log(response.body);
      } else {
        log("${response.statusCode}");
        log(response.body);
        return await json.decode(response.body);
      }
    } catch (e) {
      toast(text: "Error $e");
    }
  }

  Future getCall(
    String url,
    Map<String, dynamic> request,
  ) async {
    try {
      Map<String, String> headers;
      headers = await getHeaders();
      var uri2 = Uri.parse(url);

      uri2 = uri2.replace(queryParameters: request);
      http.Response response = await http.get(uri2, headers: headers);
      log("$uri2");
      log(response.statusCode.toString());
      if (response.statusCode == 401) {
        log("${response.statusCode}");
        log(response.body);
        CommonResponse commonResponce = CommonResponse(message: "Unauthenticated", status: "401");
        return await json.decode(json.encode(commonResponce.toJson()));
      } else {
        log("${response.statusCode}");
        log(response.body);
        return await json.decode(response.body);
      }
    } catch (e) {
      log("EERRROORR:: $e");
      CommonResponse commonResponse = CommonResponse(message: e.toString(), status: "0");
      return await json.decode(json.encode(commonResponse.toJson()));
    }
  }

  Future<Map<String, String>> getHeaders() async {
    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
  }
}

class AppLogs {
  static debugging(Object object) {
    log(object.toString());
  }
}
