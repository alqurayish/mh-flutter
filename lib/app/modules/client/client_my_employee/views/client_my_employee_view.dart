import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_appbar.dart';
import '../controllers/client_my_employee_controller.dart';

class ClientMyEmployeeView extends GetView<ClientMyEmployeeController> {
  const ClientMyEmployeeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar.appbar(
        title: MyStrings.myEmployees.tr,
        context: context,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Text("No employee hire yet", style: MyColors.l111111_dwhite(context).semiBold16,)),
        ],
      ),
    );
  }
}
