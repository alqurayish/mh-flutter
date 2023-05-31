import '../../../../common/controller/app_controller.dart';
import '../../../../common/utils/exports.dart';
import '../../../../models/requested_employees.dart';
import '../../client_home/controllers/client_home_controller.dart';
import '../../common/shortlist_controller.dart';

class ClientSuggestedEmployeesController extends GetxController {

  BuildContext? context;

  final AppController appController = Get.find();
  final ClientHomeController clientHomeController = Get.find();
  final ShortlistController shortlistController = Get.find();

  List<ClientRequestDetail> getUniquePositions() {
    List<String> ids = [];
    List<ClientRequestDetail> idsWithCounts = [];

    for(RequestEmployee element in clientHomeController.requestedEmployees.value.requestEmployees ?? []) {
      for(ClientRequestDetail positions in element.clientRequestDetails ?? []) {
        if(ids.contains(positions.id)) {
          idsWithCounts[ids.indexOf(positions.id!)].numOfEmployee = (positions.numOfEmployee ?? 0) + (idsWithCounts[ids.indexOf(positions.id!)].numOfEmployee ?? 0);
        } else {
          ids.add(positions.id!);
          idsWithCounts.add(positions);
        }
      }
    }

    return idsWithCounts;
  }

  List<SuggestedEmployeeDetail> getUniquePositionEmployees(String positionId) {
    List<SuggestedEmployeeDetail> employees = [];

    for(RequestEmployee element in clientHomeController.requestedEmployees.value.requestEmployees ?? []) {
      for(SuggestedEmployeeDetail employee in element.suggestedEmployeeDetails ?? []) {
        if(employee.positionId == positionId) {
          employees.add(employee);
        }
      }
    }

    return employees;
  }

}
