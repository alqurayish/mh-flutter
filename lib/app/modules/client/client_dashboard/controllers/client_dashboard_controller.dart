import 'package:intl/intl.dart';
import 'package:mh/app/common/controller/app_controller.dart';
import 'package:mh/app/common/widgets/custom_loader.dart';
import 'package:mh/app/modules/client/common/shortlist_controller.dart';
import 'package:mh/app/repository/api_helper.dart';

import '../../../../common/utils/exports.dart';
import '../../../../enums/chat_with.dart';
import '../../../../models/check_in_out_histories.dart';
import '../../../../models/custom_error.dart';
import '../../../../models/employee_daily_statistics.dart';
import '../../../../routes/app_pages.dart';
import '../../client_home/controllers/client_home_controller.dart';
import '../models/current_hired_employees.dart';
import 'package:intl/intl.dart';

class ClientDashboardController extends GetxController {
  BuildContext? context;

  final ApiHelper _apiHelper = Get.find();

  final AppController appController = Get.find();

  final ClientHomeController clientHomeController = Get.find();

  final List<Map<String, dynamic>> fields = [
    {"name": "Employee", "width": 143.0},
    {"name": "Check In", "width": 100.0},
    {"name": "Check Out", "width": 100.0},
    {"name": "Break Time", "width": 100.0},
    {"name": "Total Hours", "width": 100.0},
    {"name": "Chat", "width": 100.0},
    {"name": "More", "width": 100.0},
  ];

  List<String> complainType = [
    "Check In Before",
    "Check In After",
    "Check Out Before",
    "Check Out After",
    "Break Time",
  ];

  String selectedComplainType = "Check In Before";

  final formKey = GlobalKey<FormState>();
  TextEditingController tecTime = TextEditingController();
  TextEditingController tecComment = TextEditingController();

  Rx<DateTime> dashboardDate = DateTime.now().obs;
  RxString selectedDate = "".obs;

  RxBool loading = false.obs;

  Rx<HiredEmployeesByDate> hiredEmployeesByDate = HiredEmployeesByDate().obs;

  Rx<CheckInCheckOutHistory> checkInCheckOutHistory = CheckInCheckOutHistory().obs;

  // RxList<CheckInCheckOutHistoryElement> history = <CheckInCheckOutHistoryElement>[].obs;

  @override
  void onInit() {
    super.onInit();
    onDatePicked(DateTime.now());

    _fetchEmployees();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  String getComment(int index) {
    return getCheckInOutDate(index)?.checkInCheckOutDetails?.clientComment ?? "";
  }

  CheckInCheckOutHistoryElement? getCheckInOutDate(int index) {
    String id = hiredEmployeesByDate.value.hiredHistories![index].employeeDetails!.employeeId!;

    for (var element in checkInCheckOutHistory.value.checkInCheckOutHistory ?? []) {
      if(element.employeeDetails!.employeeId! == id) {
        return element;
      }
    }

    return null;
  }

  bool clientCommentEnable(int index) {
    CheckInCheckOutHistoryElement? element = getCheckInOutDate(index);

    if(element != null) {
      // checkout is 24h ago
      if ((element.checkInCheckOutDetails?.checkOutTime != null) && DateTime.now().difference(element.checkInCheckOutDetails!.checkOutTime!.toLocal()).inHours > 24) {
        return false;
      }
      // check in 24h ago (forgot checkout)
      else if ((element.checkInCheckOutDetails?.checkInTime != null) && DateTime.now().difference(element.checkInCheckOutDetails!.checkInTime!.toLocal()).inHours > 24) {
        return false;
      }
    }

    return true;
  }

  void setUpdatedDate(int index) {
    CheckInCheckOutHistoryElement? element = getCheckInOutDate(index);
    if(element != null) {
      tecComment.text = element.checkInCheckOutDetails?.clientComment ?? "";
      tecTime.clear();

      complainType = [
        "Check In Before",
        "Check In After",
      ];

      if(element.checkInCheckOutDetails?.checkOutTime != null) {
        complainType = [
          "Check In Before",
          "Check In After",
          "Check Out Before",
          "Check Out After",
          "Break Time",
        ];
      }

      if(selectedComplainType == complainType[0] || selectedComplainType == complainType[1]) {
        if(element.checkInCheckOutDetails?.clientCheckInTime != null) {

          var dif = element.checkInCheckOutDetails!.clientCheckInTime!.difference(element.checkInCheckOutDetails!.checkInTime!).inMinutes;

          if(selectedComplainType == complainType[0]) {
            if(dif < 0) {
              tecTime.text = dif.abs().toString();
            } else {
              tecTime.text = "";
            }
          } else {
            if(dif > 0) {
              tecTime.text = dif.abs().toString();
            } else {
              tecTime.text = "";
            }
          }

        }
      }
      else if(selectedComplainType == complainType[2] || selectedComplainType == complainType[3]) {
        if(element.checkInCheckOutDetails?.clientCheckOutTime != null) {

          var dif = element.checkInCheckOutDetails!.clientCheckOutTime!.difference(element.checkInCheckOutDetails!.checkOutTime!).inMinutes;

          if(selectedComplainType == complainType[2]) {
            if(dif < 0) {
              tecTime.text = dif.abs().toString();
            } else {
              tecTime.text = "";
            }
          } else {
            if(dif > 0) {
              tecTime.text = dif.abs().toString();
            } else {
              tecTime.text = "";
            }
          }

        }
      }
      else if(selectedComplainType == complainType.last) {
        tecTime.text = (element.checkInCheckOutDetails?.clientBreakTime ?? 0).toString();
      }
    }

  }

  void onDatePicked(DateTime dateTime) {
    dashboardDate.value = dateTime;
    dashboardDate.refresh();

    selectedDate.value = DateFormat('E, d MMM ,y').format(dashboardDate.value);

    _fetchEmployees();
  }

  void onComplainTypeChange(int index, String? type) {
    selectedComplainType = type!;

    setUpdatedDate(index);
  }

  Future<void> _fetchEmployees() async {
    if(loading.value) return;

    loading.value = true;

    await _apiHelper.getHiredEmployeesByDate(date: dashboardDate.value.toString().split(" ").first).then((response) {

      response.fold((CustomError customError) {
        loading.value = false;

        Utils.errorDialog(context!, customError..onRetry = _fetchEmployees);

      }, (HiredEmployeesByDate hiredEmployeesByDate) {

        this.hiredEmployeesByDate.value = hiredEmployeesByDate;
        this.hiredEmployeesByDate.refresh();

        _fetchCheckInOutHistory();

      });
    });
  }

  Future<void> _fetchCheckInOutHistory() async {
    loading.value = true;

    await _apiHelper.getCheckInOutHistory(
      filterDate: dashboardDate.value.toUtc().toString().split(" ").first,
      clientId: appController.user.value.userId,
    ).then((response) {

      loading.value = false;

      response.fold((CustomError customError) {
        Utils.errorDialog(context!, customError..onRetry = _fetchCheckInOutHistory);
      }, (CheckInCheckOutHistory checkInCheckOutHistory) async {

        this.checkInCheckOutHistory.value = checkInCheckOutHistory;
        // history..clear()..addAll(checkInCheckOutHistory.checkInCheckOutHistory ?? []);

      });
    });
  }

  Future<void> onUpdatePressed(int index) async {

    Utils.unFocus();

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      CheckInCheckOutHistoryElement element = getCheckInOutDate(index)!;

      int checkInDiff = element.checkInCheckOutDetails!.clientCheckInTime!.difference(element.checkInCheckOutDetails!.checkInTime!).inMinutes;
      int checkOutDiff = element.checkInCheckOutDetails!.clientCheckOutTime!.difference(element.checkInCheckOutDetails!.checkOutTime!).inMinutes;
      int breakTime = element.checkInCheckOutDetails?.clientBreakTime ?? 0;

      Map<String, dynamic> data = {
        "id": element.currentHiredEmployeeId,
        "checkIn": (element.checkInCheckOutDetails?.checkIn ?? false) || (element.checkInCheckOutDetails?.emmergencyCheckIn ?? false),
        "checkOut": (element.checkInCheckOutDetails?.checkOut ?? false) || (element.checkInCheckOutDetails?.emmergencyCheckOut ?? false),
        if(tecComment.text.isNotEmpty) "clientComment": tecComment.text,
        "clientBreakTime": selectedComplainType == complainType.last ? int.parse(tecTime.text) : breakTime,
        "clientCheckInTime": complainType[0] == selectedComplainType ? -(int.parse(tecTime.text)) : complainType[1] == selectedComplainType ? int.parse(tecTime.text) : checkInDiff,
        "clientCheckOutTime": complainType.length > 2 ? complainType[2] == selectedComplainType ? -(int.parse(tecTime.text)) : complainType[3] == selectedComplainType ? int.parse(tecTime.text) : checkOutDiff : 0,
      };

      CustomLoader.show(context!);
      await _apiHelper.updateCheckInOutByClient(data).then((response) {
        CustomLoader.hide(context!);

        response.fold((CustomError customError) {

          Utils.errorDialog(context!, customError);

        }, (result) {

          Get.back(); // hide dialog

          if([200, 201].contains(result.statusCode)) {
            _fetchEmployees();
          }

        });
      });


    }
  }

  void chatWithEmployee(HiredHistory hiredHistory) {
    Get.toNamed(Routes.clientEmployeeChat, arguments: {
      MyStrings.arg.receiverName: hiredHistory.employeeDetails?.name ?? "-",
      MyStrings.arg.fromId: appController.user.value.userId,
      MyStrings.arg.toId: hiredHistory.employeeDetails?.employeeId ?? "",
      MyStrings.arg.clientId: appController.user.value.userId,
      MyStrings.arg.employeeId: hiredHistory.employeeDetails?.employeeId ?? "",
    });
  }


}
