import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mh/app/repository/server_urls.dart';

class ApiHelperImplementWithFileUpload {

  static void uploadProfileImageAndCv(Map<String, dynamic> data) async {
    SendPort responseSendPort = data["responseReceivePort"];

    Response? result = await _uploadData("${ServerUrls.serverUrlUser}users/profile-picture/upload", data);

    responseSendPort.send({"data" : result?.data});
  }

  static void uploadCertificates(Map<String, dynamic> data) async {
    SendPort responseSendPort = data["responseReceivePort"];

    Response? result = await _uploadData("${ServerUrls.serverUrlUser}users/certificate/upload", data);

    responseSendPort.send({"data" : result?.data});
  }

  // static void uploadAccessoriesMoreImage(Map<String, dynamic> data) async {
  //   SendPort responseSendPort = data["responseReceivePort"];
  //
  //   Response? result = await _uploadData("${ServerUrls.serverUrlUser}accessories/update-price-info", data);
  //
  //   responseSendPort.send({"data" : result?.data});
  // }

  // static void createOrUpdateAccessories(Map<String, dynamic> data) async {
  //   SendPort responseSendPort = data["responseReceivePort"];
  //
  //   bool isCreateMethod = data["isCreate"];
  //
  //   Response? result = await _uploadData(
  //     "${ServerUrls.serverUrlProduct}accessories/${isCreateMethod ? "create" : "update-basic"}",
  //     data,
  //     postMethod: isCreateMethod,
  //   );
  //
  //   responseSendPort.send({"data" : result?.data});
  // }

  // static void uploadPaymentFile(Map<String, dynamic> data) async {
  //   SendPort responseSendPort = data["responseReceivePort"];
  //
  //   Response? result = await _uploadData("${ServerUrls.serverUrlOrder}orders/update-payment-file/add-info", data);
  //
  //   responseSendPort.send([200].contains(result?.statusCode));
  // }

  /// [List] has two data => [Response, isSuccess]
  static Future<Response?> _uploadData(String url, Map<String, dynamic> data, {bool postMethod = false}) async {
    FormData formData = data["formData"];
    String token = data["token"];
    SendPort percentSendPort = data["percentReceivePort"];
    percentSendPort.send(0);

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
      return e.response;
    }

    return response;
  }

}