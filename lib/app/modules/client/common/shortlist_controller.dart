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
    return selectedForHire.fold(0, (previousValue, element) => previousValue + (element.introductionFee ?? 0));
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
      if (!ids.contains(element)) {
        ids.add(element.employeeId!);
      }
    }
    return ids;
  }

  List<ShortList> getEmployeesBasedOnPosition(String position) {
    return shortList.where((employee) => employee.employeeId == position).toList();
  }

  Future<void> onBookNowClick(String employeeId) async {
    if (_isEmployeeAddedInShortlist(employeeId)) return;

    await _addEmployeeToShortlist(employeeId);
  }

  Future<void> _addEmployeeToShortlist(String employeeId) async {
    isFetching.value = true;

    _selectedId = employeeId;

    Map<String, dynamic> data  = {
      "shortList" : [{"employeeId" : employeeId}]
    };

    await _apiHelper.addToShortlist(data).then((response) {
      response.fold((l) {
        Logcat.msg(l.msg);
      }, (r) {
        fetchShortListEmployees();
      });
    });

  }

  void _removeEmployeeFromFromShortlist(String employeeId) {
    isFetching.value = true;
    for (var element in shortList) {
      if(element.employeeId == employeeId) {
        shortList..remove(element)..refresh();
        isFetching.value = false;
        break;
      }
    }
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
    if(_isEmployeeAddedInShortlist(employeeId)) {
      _confirmationForRemoveEmployeeFromShortlist(employeeId);
    } else {
      _addEmployeeToShortlist(employeeId);
    }
  }

  void addShortlistEmployeeForHire(ShortList shortList) {
    selectedForHire..add(shortList)..refresh();
  }

  void removeShortlistEmployeeForHire(ShortList shortList) {
    selectedForHire..remove(shortList)..refresh();
  }

  bool _isEmployeeAddedInShortlist(String employeeId) {
    return shortList.where((employee) => employee.employeeId == employeeId).toList().isNotEmpty;
  }

  void _confirmationForRemoveEmployeeFromShortlist(String employeeId) {
    _removeEmployeeFromFromShortlist(employeeId);
  }

}