import 'package:dartz/dartz.dart';
import 'package:mh/app/common/controller/app_controller.dart';
import 'package:mh/app/common/widgets/custom_dialog.dart';
import 'package:mh/app/models/custom_error.dart';
import 'package:mh/app/modules/client/client_suggested_employees/models/short_list_request_model.dart';
import 'package:mh/app/modules/employee/employee_home/models/common_response_model.dart';

import '../../../common/utils/exports.dart';
import '../../../repository/api_helper.dart';
import '../client_shortlisted/models/shortlisted_employees.dart';

class ShortlistController extends GetxService {
  RxList<ShortList> shortList = <ShortList>[].obs;

  RxList<ShortList> selectedForHire = <ShortList>[].obs;

  final ApiHelper _apiHelper = Get.find();

  final AppController _appController = Get.find();

  RxInt totalShortlisted = 0.obs;

  RxBool isFetching = false.obs;
  RxBool deleteFromShortlist = false.obs;

  String _selectedId = '';

  double getIntroductionFeesWithoutDiscount() {
    return selectedForHire.fold(0, (previousValue, element) => previousValue + (element.feeAmount ?? 0));
  }

  double getIntroductionFeesWithDiscount() {
    int total = selectedForHire.fold(0, (previousValue, element) => previousValue + (element.feeAmount ?? 0));
    double discount = _appController.user.value.client?.clientDiscount ?? 0;
    double discountedAmount = 0;

    if (discount != 0) {
      discountedAmount = (discount / 100) * getIntroductionFeesWithoutDiscount();
    }

    return total - discountedAmount;
  }

  Future<void> fetchShortListEmployees() async {
    isFetching.value = true;

    await _apiHelper.fetchShortlistEmployees().then((Either<CustomError, ShortlistedEmployees> response) {
      isFetching.value = false;

      response.fold((l) {
        Logcat.msg(l.msg);
      }, (r) {
        shortList.value = r.shortList ?? [];
        shortList.refresh();
        totalShortlisted.value = shortList.length;
      });
    });
  }

  List<String> getUniquePositions() {
    List<String> ids = [];
    for (ShortList element in shortList) {
      if (!ids.contains(element.employeeDetails!.positionId!)) {
        ids.add(element.employeeDetails!.positionId!);
      }
    }
    return ids;
  }

  List<ShortList> getEmployeesBasedOnPosition(String position) {
    return shortList.where((employee) => employee.employeeDetails!.positionId == position).toList();
  }

  Future<void> onBookNowClick(String employeeId) async {
    _selectedId = employeeId;
    if (_isEmployeeAddedInShortlist(employeeId)) return;

    await _addEmployeeToShortlist(employeeId);
  }

  Future<void> _addEmployeeToShortlist(String employeeId) async {
    isFetching.value = true;

    Map<String, dynamic> data = {"employeeId": employeeId};

    await _apiHelper.addToShortlist(data).then((response) {
      response.fold((l) {
        Logcat.msg(l.msg);
        isFetching.value = false;
      }, (r) {
        if ([200, 201].contains(r.statusCode)) {
          fetchShortListEmployees();
        } else {
          isFetching.value = false;
          CustomDialogue.information(
            context: Get.context!,
            title: "Error",
            description: "Employee already hired",
          );
        }
      });
    });
  }

  Future<void> _removeEmployeeFromFromShortlist(String employeeId) async {
    deleteFromShortlist.value = true;

    String shortlistId = shortList.firstWhere((element) => element.employeeId == employeeId).sId!;

    await _apiHelper.deleteFromShortlist(shortlistId).then((response) {
      deleteFromShortlist.value = false;

      response.fold((l) {
        Logcat.msg(l.msg);
      }, (r) {
        for (var element in shortList) {
          if (element.employeeId == employeeId) {
            shortList
              ..remove(element)
              ..refresh();

            totalShortlisted.value = shortList.length;

            selectedForHire.removeWhere((element) => element.employeeId == employeeId);
            selectedForHire.refresh();

            break;
          }
        }
      });
    });
  }

  Widget getIcon({required String employeeId, required bool isFetching, required String fromWhere, String? id}) {
    return GestureDetector(
      onTap: () {
        if (!_appController.hasPermission()) return;

        _onBookmarkClick(employeeId: employeeId, fromWhere: fromWhere, id: id);
      },
      child: (this.isFetching.value || deleteFromShortlist.value) && employeeId == _selectedId
          ? const SizedBox(
              width: 20,
              height: 20,
              child: Center(
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: MyColors.c_C6A34F,
                ),
              ),
            )
          : _isEmployeeAddedInShortlist(employeeId)
              ? const Icon(
                  Icons.bookmark,
                  color: MyColors.c_C6A34F,
                )
              : const Icon(
                  Icons.bookmark_outline_rounded,
                  color: Colors.grey,
                ),
    );
  }

  void _onBookmarkClick({required String employeeId, String? id, required String fromWhere}) {
    _selectedId = employeeId;

    if (_isEmployeeAddedInShortlist(employeeId)) {
      _confirmationForRemoveEmployeeFromShortlist(employeeId);
    } else {
      if (fromWhere == 'Requested Employees') {
        _addEmployeeToShortListNew(employeeId: employeeId, id: id ?? '');
      } else {
        _addEmployeeToShortlist(employeeId);
      }
    }
  }

  void onSelectClick(ShortList shortList) {
    if (selectedForHire.contains(shortList)) {
      selectedForHire.remove(shortList);
    } else {
      selectedForHire.add(shortList);
    }

    selectedForHire.refresh();
  }

  bool isDateRangeSetForSelectedUser() {
    // book all employee
    if (selectedForHire.isEmpty) {
      for (ShortList employee in shortList) {
        if (employee.fromDate != null &&
            employee.toDate != null &&
            employee.fromTime != null &&
            employee.toTime != null) {
          selectedForHire.add(employee);
        }
      }

      selectedForHire.refresh();

      return shortList.length == selectedForHire.length;
    }

    // check date and time range is selected
    bool valid = true;

    for (ShortList element in selectedForHire) {
      if (element.fromDate == null || element.toDate == null || element.fromTime == null || element.toTime == null) {
        valid = false;
        break;
      }
    }

    return valid;
  }

  bool _isEmployeeAddedInShortlist(String employeeId) {
    return shortList.where((employee) => employee.employeeId == employeeId).toList().isNotEmpty;
  }

  void _confirmationForRemoveEmployeeFromShortlist(String employeeId) {
    CustomDialogue.confirmation(
      context: Get.context!,
      title: "Confirm?",
      msg: "Are you sure you want to delete employee from shortlist?",
      confirmButtonText: "Delete",
      onConfirm: () {
        Get.back(); // hide dialog
        _removeEmployeeFromFromShortlist(employeeId);
      },
    );
  }

  void removeAllSelected() {
    selectedForHire
      ..clear()
      ..refresh();
  }

  void _addEmployeeToShortListNew({required String employeeId, required String id}) async {
    isFetching.value = true;

    ShortListRequestModel shortListRequestModel = ShortListRequestModel(id: id, employeeId: employeeId);

    await _apiHelper.addToShortlistNew(shortListRequestModel: shortListRequestModel).then((Either<CustomError, CommonResponseModel> response) {
      response.fold((l) {
        Logcat.msg(l.msg);
        isFetching.value = false;
      }, (r) {
        if ([200, 201].contains(r.statusCode)) {
          fetchShortListEmployees();
        } else {
          isFetching.value = false;
          CustomDialogue.information(
            context: Get.context!,
            title: "Error",
            description: "Employee already hired",
          );
        }
      });
    });
  }
}
