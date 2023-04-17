import 'package:mh/app/modules/employee/employee_home/controllers/employee_home_controller.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../enums/user_type.dart';
import '../../modules/client/client_home/controllers/client_home_controller.dart';
import '../controller/app_controller.dart';
import '../utils/exports.dart';

class ChatWithUserChoose {
  static show(BuildContext context) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => Container(
        color: MyColors.lightCard(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _menuItem(
              context,
              "Chat with Admin / support",
              Icons.chat,
              Get.find<EmployeeHomeController>().chatWithAdmin,
            ),
            const Divider(height: 1),
            _menuItem(
              context,
              "Chat with Restaurant",
              Icons.chat,
              Get.find<EmployeeHomeController>().chatWithAdmin,
            ),
          ],
        ),
      ),
    );
  }

  static Widget _menuItem(
    BuildContext context,
    String title,
    IconData icon,
    Function() onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(
        title,
        style: MyColors.l111111_dtext(context).regular16_5,
      ),
      onTap: onTap,
    );
  }
}
