import '../../../../common/controller/app_controller.dart';
import '../../../../common/utils/exports.dart';
import '../../../../models/position.dart';
import '../../../../models/requested_employees.dart';
import '../../../../routes/app_pages.dart';
import '../../admin_client_request/controllers/admin_client_request_controller.dart';

class AdminClientRequestPositionsController extends GetxController {

  BuildContext? context;

  final AppController appController = Get.find();
  final AdminClientRequestController adminClientRequestController = Get.find();

  late int selectedIndex;

  RxList<Position> positions = <Position>[].obs;

  @override
  void onInit() {
    selectedIndex = Get.arguments[MyStrings.arg.data];

    for (Position element in appController.allActivePositions) {
      for(ClientRequestDetail requestedPosition in adminClientRequestController.requestedEmployees.value.requestEmployees?[selectedIndex].clientRequestDetails ?? []) {
        if(requestedPosition.positionId == element.id) {
          positions.add(element);
        }
      }
    }

    super.onInit();

  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  String getSuggested(Position position) {
    int total = (adminClientRequestController.requestedEmployees.value.requestEmployees?[selectedIndex].clientRequestDetails ?? []).firstWhere((element) => element.positionId == position.id).numOfEmployee ?? 0;
    int suggested = (adminClientRequestController.requestedEmployees.value.requestEmployees?[selectedIndex].suggestedEmployeeDetails ?? []).where((element) => element.positionId == position.id).length;
    return "$suggested of $total";
  }

  void onPositionClick(Position position) {
    ClientRequestDetail clientRequestDetail = (adminClientRequestController.requestedEmployees.value.requestEmployees?[selectedIndex].clientRequestDetails ?? []).firstWhere((element) => element.positionId == position.id);
    Get.toNamed(Routes.adminClientRequestPositionEmployees, arguments: {
      MyStrings.arg.data : clientRequestDetail,
    });
  }



}
