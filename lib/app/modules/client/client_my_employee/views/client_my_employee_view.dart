import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_appbar.dart';
import '../controllers/client_my_employee_controller.dart';

class ClientMyEmployeeView extends GetView<ClientMyEmployeeController> {
  const ClientMyEmployeeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;

    return Scaffold(
      appBar: CustomAppbar.appbar(
        title: MyStrings.myEmployees.tr,
        context: context,
      ),
      body: controller.isLoading.value
          ? _loading
          : (controller.employees.value.currentHiredEmployees ?? []).isEmpty
              ? _noEmployeeHireYet
              : _showEmployeeList,
    );
  }

  Widget get _noEmployeeHireYet => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "No employee hire yet",
              style: MyColors.l111111_dwhite(controller.context!).semiBold16,
            ),
          ),
        ],
      );

  Widget get _loading => const Center(child: CircularProgressIndicator());

  Widget get _showEmployeeList => Container();
}
