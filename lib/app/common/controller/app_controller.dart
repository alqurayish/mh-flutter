import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../enums/user_type.dart';
import '../../models/client.dart';
import '../../models/commons.dart';
import '../../models/dropdown_item.dart';
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
    userType: UserType.client,
  ).obs;

  void _updateUserModel() {
    if (StorageHelper.hasToken && StorageHelper.getToken.isNotEmpty) {
      if (!_isTokenExpire()) {
        if(user.value.isClient) {
          user.value.client = Client.fromJson(JwtDecoder.decode(StorageHelper.getToken));
        } else if(user.value.isEmployee) {

        } else if (user.value.isAdmin) {

        }

        user.refresh();
      }
    } else {
      Logcat.msg("User Token not found in local");
    }
  }

  bool _isTokenExpire() => JwtDecoder.isExpired(StorageHelper.getToken);

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
    if(user.value.isClient) {
      Get.put(ShortlistController());
      Get.find<ShortlistController>().fetchShortListEmployees();
    }
  }

  void onLogoutClick() {
    StorageHelper.removeToken;
    Get.offAllNamed(Routes.login);
  }
}
