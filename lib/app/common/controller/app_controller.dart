import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mh/app/common/widgets/custom_loader.dart';
import 'package:mh/app/models/admin.dart';
import 'package:mh/app/repository/api_helper.dart';

import '../../enums/user_type.dart';
import '../../models/client.dart';
import '../../models/commons.dart';
import '../../models/dropdown_item.dart';
import '../../models/employee.dart';
import '../../models/position.dart';
import '../../models/user.dart';
import '../../modules/client/common/shortlist_controller.dart';
import '../../routes/app_pages.dart';
import '../data/data.dart';
import '../local_storage/storage_helper.dart';
import '../utils/logcat.dart';
import '../utils/utils.dart';
import '../values/my_assets.dart';

class AppController extends GetxService {

  Rx<Commons>? commons = Commons().obs;

  RxList<Position> allActivePositions = <Position>[].obs;

  Rx<User> user = User(
    userType: UserType.guest,
  ).obs;

  void setTokenFromLocal() {
    _updateUserModel();

    if(user.value.isGuest) {
      _updateFCMToken(isLogin: false);
      Get.offAndToNamed(Routes.loginRegisterHints);
    } else {
      _updateFCMToken();
      activeShortlistService();
      Get.offAndToNamed(user.value.userType!.homeRoute);
    }
  }

  void _updateUserModel() {
    if (StorageHelper.hasToken && StorageHelper.getToken.isNotEmpty) {
      if (!_isTokenExpire()) {

        Client temp = Client.fromJson(JwtDecoder.decode(StorageHelper.getToken));

        if(temp.role == "CLIENT") {
          user.value.userType = UserType.client;
          user.value.client = temp;
        } else if(temp.role == "EMPLOYEE") {
          user.value.userType = UserType.employee;
          user.value.employee = Employee.fromJson(JwtDecoder.decode(StorageHelper.getToken));
        } else if (temp.role == "ADMIN") {
          user.value.userType = UserType.admin;
          user.value.admin = Admin.fromJson(JwtDecoder.decode(StorageHelper.getToken));
        } else {
          user.value.userType = UserType.guest;
        }

        user.refresh();

      } else {
        Logcat.msg("Token Expire");
        Get.offAllNamed(Routes.login);
      }
    } else {
      Logcat.msg("User Token not found in local");
    }
  }

  bool _isTokenExpire() => JwtDecoder.isExpired(StorageHelper.getToken);

  Future<void> afterSuccessRegister(String token) async {
    // if (token.isEmpty) {
    //   user.value.userType = UserType.guest;
    //   Get.offAllNamed(Routes.employeeRegisterSuccess);
    //   activeShortlistService();
    //   return;
    // }
    //
    //
    // Client temp = Client.fromJson(JwtDecoder.decode(token));
    //
    // if(temp.role == "CLIENT") {
    //   await updateToken(token);
    //   activeShortlistService();
    // } else {
    //   user.value.userType = UserType.guest;
    // }

    activeShortlistService();
    user.value.userType = UserType.guest;

    Get.offAllNamed(Routes.employeeRegisterSuccess);
  }

  Future<void> afterSuccessLogin(String token) async {
    await updateToken(token);

    _updateFCMToken();

    if(user.value.userType == null) {

    } else {
      activeShortlistService();
      Get.offAndToNamed(user.value.userType!.homeRoute);
    }
  }

  Future<void> updateToken(String token) async {
    // update token on local
    await StorageHelper.setToken(token);

    // update user model for globally
    _updateUserModel();
  }

  void setCommons(Commons commons) {
    this.commons?.value = commons;
    this.commons?.refresh();

    for (DropdownItem element in (this.commons?.value.positions ?? [])) {
      if(element.active ?? false) {
        bool found = false;
        for (var position in Data.positions) {
          if (element.id == position.id) {
            allActivePositions.add(position);
            found = true;
            break;
          }
        }

        if (!found) {
          allActivePositions.add(Position(
            id: element.id!,
            name: element.name!,
            logo: MyAssets.defaultImage,
          ));
        }

      }
    }

    allActivePositions.refresh();

  }

  /// call when
  /// login success - done
  /// register success
  /// after splash - done
  void activeShortlistService() {
    Get.put(ShortlistController());

    if(user.value.isClient) {
      Get.find<ShortlistController>().fetchShortListEmployees();
    }
  }

  Future<void> enterAsGuestMode() async {
    await StorageHelper.setToken("");
    activeShortlistService();
    Get.toNamed(Routes.mhEmployees);
  }

  Future<void> onLogoutClick() async {

    CustomLoader.show(Get.context!);

    if(Get.isRegistered<ShortlistController>()) {
      Get.find<ShortlistController>().removeAllSelected();
    }

    await _updateFCMToken(isLogin: false);

    CustomLoader.hide(Get.context!);

    StorageHelper.removeToken;

    Get.offAllNamed(Routes.login);
  }

  bool hasPermission() {
    if(user.value.isGuest) {
      Get.toNamed(Routes.login);
      return false;
    }

    return true;
  }

  Future<void> _updateFCMToken({bool isLogin = true}) async {
    if(Get.isRegistered<ApiHelper>()) {
      await Get.find<ApiHelper>().updateFcmToken(isLogin: isLogin);
    }
  }
}
