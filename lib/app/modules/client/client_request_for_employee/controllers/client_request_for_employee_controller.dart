import 'package:get/get.dart';
import 'package:mh/app/common/controller/app_controller.dart';

class ClientRequestForEmployeeController extends GetxController {

  final AppController appController = Get.find();

  RxList<int> selectedEmployee = <int>[].obs;

  List<int> dropdownValues = [];

  @override
  void onInit() {

    for(int i = 0; i <= 50; i++) {
      dropdownValues.add(i);
    }

    for(int i = 0; i < appController.allActivePositions.length; i++) {
      selectedEmployee.add(0);
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

  void onDropdownChange(int value, int index) {
    selectedEmployee[index] = value;
  }

  void onRequestPressed() {

  }

}
