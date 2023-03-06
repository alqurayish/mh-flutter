import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

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

  void _updateUserModel() {
    if (StorageHelper.hasToken && StorageHelper.getToken.isNotEmpty) {
      if (!_isTokenExpire()) {

        Client temp = Client.fromJson(JwtDecoder.decode(StorageHelper.getToken));

        if(temp.role == "CLIENT") {
          user.value.userType = UserType.client;
          user.value.client = Client.fromJson(JwtDecoder.decode(StorageHelper.getToken));
        } else if(temp.role == "EMPLOYEE") {
          user.value.userType = UserType.employee;
          user.value.employee = Employee.fromJson(JwtDecoder.decode(StorageHelper.getToken));
        } else if (user.value.isAdmin) {
          user.value.userType = UserType.admin;
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
    Client temp = Client.fromJson(JwtDecoder.decode(token));

    if(temp.role == "CLIENT") {
      await updateToken(token);
      activeShortlistService();
    } else {
      user.value.userType = UserType.guest;
    }

    Get.offAllNamed(Routes.employeeRegisterSuccess);
  }

  Future<void> afterSuccessLogin(String token) async {
    await updateToken(token);

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

  void onLogoutClick() {
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
}
