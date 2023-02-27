import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../enums/user_type.dart';
import '../../models/client.dart';
import '../../models/user.dart';
import '../controller/app_controller.dart';
import '../local_storage/storage_helper.dart';
import '../utils/logcat.dart';

class AuthHelper {
  AuthHelper._();

  static Future<Either<String, bool>> getUserFromLocal() async {
    String? token = StorageHelper.getToken;

    print(token);

    if (StorageHelper.hasToken && token.isNotEmpty) {
      if (JwtDecoder.isExpired(token)) {
        return left("Token Expire");
      } else {
        /// TODO return valid user
        // _userModel.value = User.fromJson(JwtDecoder.decode(StorageHelper.getUserToken!));

        Client user = Client.fromJson(JwtDecoder.decode(StorageHelper.getToken));

        if(user.client ?? false) {
          Get.find<AppController>().user.value = User(userType: UserType.client);
          Get.find<AppController>().user.value.client = user;
        } else if(user.client ?? false) {
          Get.find<AppController>().user.value = User(userType: UserType.employee);
          Get.find<AppController>().user.value.client = user;
        } else if(user.client ?? false) {
          Get.find<AppController>().user.value = User(userType: UserType.admin);
          Get.find<AppController>().user.value.client = user;
        } else {
          Get.find<AppController>().user.value = User(userType: UserType.guest);
        }

        Get.find<AppController>().user.refresh();

        return right(true);
      }
    } else {
      Logcat.msg("User Token not found in local");
      return left("User Token not found in local");
    }
  }
}