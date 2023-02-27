import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../controller/app_controller.dart';
import '../utils/exports.dart';

class CustomMenu {
  static accountMenu(BuildContext context) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _menuItem(Icons.logout, "Logout", Get.find<AppController>().onLogoutClick),
        ],
      ),
    );
  }

  static Widget _menuItem(IconData icon, String title, Function() onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}