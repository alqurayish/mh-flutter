import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mh/app/common/controller/app_controller.dart';
import 'package:mh/app/common/extensions/extensions.dart';
import 'package:mh/app/common/utils/utils.dart';
import 'package:mh/app/common/widgets/custom_loader.dart';
import 'package:mh/app/models/custom_error.dart';
import 'package:mh/app/modules/calender/models/calender_model.dart';
import 'package:mh/app/modules/calender/models/update_unavailable_date_request_model.dart';
import 'package:mh/app/modules/client/client_home/controllers/client_home_controller.dart';
import 'package:mh/app/modules/client/client_shortlisted/models/add_to_shortlist_request_model.dart';
import 'package:mh/app/modules/employee/employee_home/controllers/employee_home_controller.dart';
import 'package:mh/app/modules/employee/employee_home/models/common_response_model.dart';
import 'package:mh/app/repository/api_helper.dart';

class CalenderController extends GetxController {
  BuildContext? context;
  String employeeId = '';

  final AppController appController = Get.find();
  final ApiHelper _apiHelper = Get.find();

  Rx<DateListModel> dateListModel = DateListModel().obs;
  List<CalenderDataModel> totalDateList = <CalenderDataModel>[];
  RxBool dateDataLoading = true.obs;

  final List<String> dayNames = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  late PageController pageController;
  RxInt currentPageIndex = 0.obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;

  final RxSet<DateTime> selectedDates = <DateTime>{}.obs;
  Rx<DateTime?> rangeStartDate = Rx<DateTime?>(null);
  Rx<DateTime?> rangeEndDate = Rx<DateTime?>(null);

  //For employee only
  RxList<Dates> unavailableDateList = <Dates>[].obs;
  RxBool sameAsStartDate = false.obs;

  //For client only
  RxList<AddToShortListRequestModel> addToShortListRequestList = <AddToShortListRequestModel>[].obs;
  Rx<RequestDate> requestDateModel = RequestDate().obs;

  @override
  void onInit() {
    employeeId = Get.arguments;
    _getCalenderData();
    pageController = PageController(initialPage: currentPageIndex.value);
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onDateClick({required DateTime currentDate}) {
    if (Get.isRegistered<ClientHomeController>() == true) {
      onDateClickForClient(currentDate: currentDate);
    } else if (Get.isRegistered<EmployeeHomeController>() == true) {
      onDateClickForEmployee(currentDate: currentDate);
    } else {
      Utils.showSnackBar(message: 'Something went wrong', isTrue: true);
    }
  }

  void _getCalenderData() {
    dateDataLoading.value = true;
    _apiHelper.getCalenderData(employeeId: employeeId).then((Either<CustomError, CalenderModel> responseData) {
      dateDataLoading.value = false;
      responseData.fold((CustomError customError) {
        Utils.errorDialog(context!, customError..onRetry = _getCalenderData);
      }, (CalenderModel response) {
        if (response.status == "success" && response.statusCode == 200 && response.dateList != null) {
          dateListModel.value = response.dateList!;
          dateListModel.refresh();
          loadTotalDateList();
        }
      });
    });
  }

  void loadTotalDateList() {
    totalDateList = <CalenderDataModel>[
      ...dateListModel.value.unavailableDates ?? [],
      ...dateListModel.value.pendingDates ?? [],
      ...dateListModel.value.bookedDates ?? [],
    ];
  }

  void onPageChanged(int index) {
    currentPageIndex.value = index;
    selectedDate.value = DateTime.now().add(Duration(days: index * 30));
  }

  ///---------------- For employee only -------------------

  //For employee only
  void onDateClickForEmployee({required DateTime currentDate}) {
    if (currentDate.isBefore(DateTime.now()) || selectedDate.value == currentDate) {
      return; // Skip processing for previous dates and current date
    }

    if (selectedDates.length == 2 || (rangeStartDate.value != null && rangeEndDate.value != null)) {
      selectedDates.clear();
      rangeStartDate.value = currentDate;
      rangeEndDate.value = null;
      sameAsStartDate.value = false;
    } else if (rangeStartDate.value == null) {
      rangeStartDate.value = currentDate;
    } else if (totalDateList.anyDatesExistInRange(
            rangeStart: rangeStartDate.value.toString().substring(0, 10),
            rangeEnd: currentDate.toString().substring(0, 10)) ==
        true) {
      Utils.showSnackBar(message: 'You cannot select this range', isTrue: false);
    } else if (rangeStartDate.value != null && currentDate.isBefore(rangeStartDate.value!)) {
      rangeEndDate.value = rangeStartDate.value;
      rangeStartDate.value = currentDate;
    } else if (rangeEndDate.value == null && currentDate != rangeStartDate.value) {
      rangeEndDate.value = currentDate;
    } else {
      rangeEndDate.value = null;
      rangeStartDate.value = null;
      sameAsStartDate.value = false;
    }

    loadSelectedDates(currentDate: currentDate);
    loadUnavailableDates();
  }

  //For employees only
  void updateUnavailableDates() {
    CustomLoader.show(context!);
    UpdateUnavailableDateRequestModel updateUnavailableDateRequestModel =
        UpdateUnavailableDateRequestModel(unavailableDateList: unavailableDateList.toSet().toList());
    _apiHelper
        .updateUnavailableDate(updateUnavailableDateRequestModel: updateUnavailableDateRequestModel)
        .then((Either<CustomError, CommonResponseModel> responseData) {
      CustomLoader.hide(context!);
      responseData.fold((CustomError customError) {
        Utils.errorDialog(context!, customError..onRetry = _getCalenderData);
      }, (CommonResponseModel response) {
        if (response.status == "success" && response.statusCode == 200) {
          _getCalenderData();
          unavailableDateList.clear();
          selectedDates.clear();
          Utils.showSnackBar(message: 'Dates have been updated successfully', isTrue: true);
        } else {
          Utils.showSnackBar(message: 'Date update failed', isTrue: false);
        }
      });
    });
  }

  //For employees only
  void loadUnavailableDates() {
    if (rangeStartDate.value != null && rangeEndDate.value != null) {
      unavailableDateList.add(Dates(
          startDate: rangeStartDate.value.toString().substring(0, 10),
          endDate: rangeEndDate.value.toString().substring(0, 10)));
    }

    if (dateListModel.value.unavailableDates != null && dateListModel.value.unavailableDates!.isNotEmpty) {
      for (CalenderDataModel date in dateListModel.value.unavailableDates!) {
        unavailableDateList.add(Dates(startDate: date.startDate ?? '', endDate: date.endDate ?? ''));
      }
    }
  }

  //For employee only
  void onSameAsStartDatePressed(bool? value) {
    sameAsStartDate.value = !sameAsStartDate.value;
    if (sameAsStartDate.value == true) {
      rangeEndDate.value = rangeStartDate.value;
    } else {
      rangeEndDate.value = null;
    }
  }

  //For employee only
  void onRemoveClick() {
    selectedDates.clear();
    rangeStartDate.value = null;
  }

  //For employee only
  bool get disableSubmitButton {
    return rangeStartDate.value == null || rangeEndDate.value == null;
  }

  //For employee only
  void loadSelectedDates({required DateTime currentDate}) {
    if (selectedDates.contains(currentDate)) {
      selectedDates.remove(currentDate);
    } else {
      if (totalDateList.anyDatesExistInRange(
              rangeStart: rangeStartDate.value.toString().substring(0, 10),
              rangeEnd: currentDate.toString().substring(0, 10)) ==
          false) {
        selectedDates.add(currentDate);
      }
    }
  }

  //For employee only
  int get totalSelectedDays {
    if (rangeStartDate.value == null || rangeEndDate.value == null) {
      return 0;
    } else {
      return rangeStartDate.value!.daysUntil(rangeEndDate.value!);
    }
  }

  ///-------------------------------------------------------------------

  ///---------------- For Client only ----------------------------------

  void onDateClickForClient({required DateTime currentDate}) {
    if (currentDate.isBefore(DateTime.now()) || selectedDate.value == currentDate) {
      return; // Skip processing for previous dates and current date
    }

    if (selectedDates.length == 2 || (rangeStartDate.value != null && rangeEndDate.value != null)) {
      selectedDates.clear();
      rangeStartDate.value = currentDate;
      rangeEndDate.value = null;
      sameAsStartDate.value = false;
    } else if (rangeStartDate.value == null) {
      rangeStartDate.value = currentDate;
    } else if (totalDateList.anyDatesExistInRange(
        rangeStart: rangeStartDate.value.toString().substring(0, 10),
        rangeEnd: currentDate.toString().substring(0, 10)) ==
        true) {
      Utils.showSnackBar(message: 'You cannot select this range', isTrue: false);
    } else if (rangeStartDate.value != null && currentDate.isBefore(rangeStartDate.value!)) {
      rangeEndDate.value = rangeStartDate.value;
      rangeStartDate.value = currentDate;
    } else if (rangeEndDate.value == null && currentDate != rangeStartDate.value) {
      rangeEndDate.value = currentDate;
    } else {
      rangeEndDate.value = null;
      rangeStartDate.value = null;
      sameAsStartDate.value = false;
    }

    loadSelectedDates(currentDate: currentDate);
    loadUnavailableDates();
  }
}
