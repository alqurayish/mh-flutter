import 'package:get/get.dart';
import 'package:mh/app/modules/client/client_shortlisted/models/add_to_shortlist_request_model.dart';
import 'package:mh/app/modules/employee/employee_home/controllers/employee_home_controller.dart';
import 'package:mh/app/modules/employee_hired_history/widgets/employee_hired_history_details_widget.dart';

class EmployeeHiredHistoryController extends GetxController {
  final EmployeeHomeController employeeHomeController = Get.find<EmployeeHomeController>();


  void onDetailsClick({required List<RequestDateModel> bookedDateList}) {
    Get.bottomSheet(EmployeeHiredHistoryDetailsWidget(requestDateList: bookedDateList));
  }
}
