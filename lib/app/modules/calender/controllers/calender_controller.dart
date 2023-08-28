import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mh/app/common/controller/app_controller.dart';
import 'package:mh/app/common/utils/utils.dart';
import 'package:mh/app/models/custom_error.dart';
import 'package:mh/app/modules/calender/models/calender_model.dart';
import 'package:mh/app/repository/api_helper.dart';

class CalenderController extends GetxController {
  BuildContext? context;

  final AppController appController = Get.find();
  final ApiHelper _apiHelper = Get.find();

  Rx<DateListModel> dateListModel = DateListModel().obs;
  RxBool dateDataLoading = true.obs;

  final List<String> dayNames = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  late PageController pageController;
  RxInt currentPageIndex = 0.obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;

  final RxSet<DateTime> selectedDates = <DateTime>{}.obs;
  Rx<DateTime?> rangeStartDate = Rx<DateTime?>(null);
  Rx<DateTime?> rangeEndDate = Rx<DateTime?>(null);

  @override
  void onInit() {
    _getCalenderData();
    pageController = PageController(initialPage: currentPageIndex.value);
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void _getCalenderData() {
    _apiHelper
        .getCalenderData(employeeId: appController.user.value.userId)
        .then((Either<CustomError, CalenderModel> responseData) {
      dateDataLoading.value = false;
      responseData.fold((CustomError customError) {
        Utils.errorDialog(context!, customError..onRetry = _getCalenderData);
      }, (CalenderModel response) {
        if (response.status == "success" && response.statusCode == 200 && response.dateList != null) {
          dateListModel.value = response.dateList!;
        }
      });
    });
  }

  void onDateClick({required DateTime currentDate}) {
    if (currentDate.isBefore(DateTime.now()) || selectedDate.value == currentDate) {
      return; // Skip processing for previous dates and current date
    }

    if (rangeStartDate.value == null || rangeEndDate.value != null) {
      rangeStartDate.value = currentDate;
      rangeEndDate.value = null;
    } else if (rangeStartDate.value != null && currentDate.isBefore(rangeStartDate.value!)) {
      rangeStartDate.value = currentDate;
    } else {
      rangeEndDate.value = currentDate;
    }

    if (selectedDates.contains(currentDate)) {
      selectedDates.remove(currentDate);
    } else {
      selectedDates.add(currentDate);
    }
  }

  void onPageChanged(int index) {
    currentPageIndex.value = index;
    selectedDate.value = DateTime.now().add(Duration(days: index * 30));
  }
}
