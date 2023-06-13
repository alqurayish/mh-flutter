import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mh/app/repository/server_urls.dart';

import '../common/controller/app_error_controller.dart';

class ApiHelperImplementWithFileUpload {

  static void employeeRegister(Map<String, dynamic> data) async {
    SendPort responseSendPort = data["responseReceivePort"];

    Response? result = await _uploadData(
      "${ServerUrls.serverUrlUser}users/employee-register",
      data,
      postMethod: true,
    );

    responseSendPort.send({"data" : result?.data});
  }

  /// [List] has two data => [Response, isSuccess]
  static Future<Response?> _uploadData(String url, Map<String, dynamic> data, {bool postMethod = false}) async {

    String token = data["token"];
    SendPort percentSendPort = data["percentReceivePort"];
    percentSendPort.send(0);

    FormData formData = FormData.fromMap(data["basicData"]);

    if(url.split("/").last == "users/employee-register") {
      if(data["profileImage"] != null) {
        formData.files.add(MapEntry(
            "profilePicture",
            await MultipartFile.fromFile(
              data["profileImage"],
              filename: data["profileImage"].last.path.split("/").last,
              contentType: MediaType("image", "jpeg"),
            )));
      }

      if(data["cv"].isNotEmpty) {
        formData.files.add(MapEntry(
            "cv",
            await MultipartFile.fromFile(
              data["cv"].last.path,
              filename: data["cv"].last.path.split("/").last,
              contentType: MediaType("application", "pdf"),
            )));
      }
    }

    Response? response;

    if(kDebugMode) {
      print(url);
      print(formData.fields);
      print(formData.files);
    }

    try {
      Options options = Options(
        headers: {
          'Content-Type': 'application/json',
          'Vary': 'Accept',
          if(token.isNotEmpty) 'Authorization': 'Bearer $token'
        },
        sendTimeout: const Duration(minutes: 5), // 5 min
        followRedirects: false,
      );

      response = postMethod
          ? await Dio().post(
              url,
              data: formData,
              options: options,
              onSendProgress: (int count, int total) {
                percentSendPort.send(((100 / total) * count).toInt());
              },
            )
          : await Dio().put(
              url,
              data: formData,
              options: options,
              onSendProgress: (int count, int total) {
                percentSendPort.send(((100 / total) * count).toInt());
              },
            );
    } on DioError catch (e, s) {
      if(kDebugMode) {
        print(e.response);
        print(e);
        print(s);
      }

      AppErrorController.submitAutomaticError(
        errorName: "From: api_helper_imp_with_file_upload.dart > on DioError catch",
        description: (e.response?.data ?? "").toString(),
      );

      return e.response;
    }

    return response;
  }

}