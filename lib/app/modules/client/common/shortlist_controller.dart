import '../../../common/utils/exports.dart';
import '../../../repository/api_helper.dart';
import '../client_shortlisted/models/shortlisted_employees.dart';

class ShortlistController extends GetxService {
  RxList<ShortList> shortList = <ShortList>[].obs;

  RxList<ShortList> selectedForHire = <ShortList>[].obs;

  final ApiHelper _apiHelper = Get.find();

  RxInt totalShortlisted = 0.obs;

  RxBool isFetching = false.obs;

  String _selectedId = '';

  int getIntroductionFees() {
    return selectedForHire.fold(0, (previousValue, element) => previousValue + (element.feeAmount ?? 0));
  }

  Future<void> fetchShortListEmployees() async {
    isFetching.value = true;

    await _apiHelper.fetchShortlistEmployees().then((response) {

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
      if (!ids.contains(element.employees!.positionId!)) {
        ids.add(element.employees!.positionId!);
      }
    }
    return ids;
  }

  List<ShortList> getEmployeesBasedOnPosition(String position) {
    return shortList.where((employee) => employee.employees!.positionId == position).toList();
  }

  Future<void> onBookNowClick(String employeeId) async {
    if (_isEmployeeAddedInShortlist(employeeId)) return;

    await _addEmployeeToShortlist(employeeId);
  }

  Future<void> _addEmployeeToShortlist(String employeeId) async {
    isFetching.value = true;

    Map<String, dynamic> data  = {"employeeId" : employeeId};

    await _apiHelper.addToShortlist(data).then((response) {
      response.fold((l) {
        Logcat.msg(l.msg);
      }, (r) {
        fetchShortListEmployees();
      });
    });

  }

  Future<void> _removeEmployeeFromFromShortlist(String employeeId) async {
    isFetching.value = true;

    String shortlistId = shortList.firstWhere((element) => element.employeeId == employeeId).sId!;

    await _apiHelper.deleteFromShortlist(shortlistId).then((response) {

      isFetching.value = false;

      response.fold((l) {
        Logcat.msg(l.msg);
      }, (r) {
        for (var element in shortList) {
          if (element.employeeId == employeeId) {

            shortList..remove(element)..refresh();

            totalShortlisted.value = shortList.length;

            selectedForHire.removeWhere((element) => element.employeeId == employeeId);
            selectedForHire.refresh();

            isFetching.value = false;

            break;
          }
        }
      });

    });

  }

  Widget getIcon(String employeeId, bool isFetching) {
    return GestureDetector(
      onTap: () => _onBookmarkClick(employeeId),
      child: isFetching && employeeId == _selectedId
          ? const SizedBox(
              width: 20,
              height: 20,
              child: Center(
                child: CircularProgressIndicator(
                  color: MyColors.c_C6A34F,
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

  void _onBookmarkClick(String employeeId) {
    _selectedId = employeeId;

    if(_isEmployeeAddedInShortlist(employeeId)) {
      _confirmationForRemoveEmployeeFromShortlist(employeeId);
    } else {
      _addEmployeeToShortlist(employeeId);
    }
  }

  void onSelectClick(ShortList shortList) {
    if(selectedForHire.contains(shortList)) {
      selectedForHire.remove(shortList);
    } else {
      selectedForHire.add(shortList);
    }

    selectedForHire.refresh();
  }

  bool isDateRangeSetForSelectedUser() {
    if(selectedForHire.isEmpty) {
      for(ShortList employee in shortList) {
        if(employee.fromDate != null && employee.toDate != null) {
          selectedForHire.add(employee);
        }
      }

      selectedForHire.refresh();

      return shortList.length == selectedForHire.length;
    }

    bool valid = true;

    for (ShortList element in selectedForHire) {
      if(element.fromDate == null || element.toDate == null) {
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
    _removeEmployeeFromFromShortlist(employeeId);
  }

}