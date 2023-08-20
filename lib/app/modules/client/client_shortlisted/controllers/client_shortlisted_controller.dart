import 'package:intl/intl.dart';

import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_dialog.dart';
import '../../../../common/widgets/custom_hire_time.dart';
import '../../../../common/widgets/custom_loader.dart';
import '../../../../repository/api_helper.dart';
import '../../../../routes/app_pages.dart';
import '../../common/shortlist_controller.dart';
import '../models/shortlisted_employees.dart';

class ClientShortlistedController extends GetxController {
  BuildContext? context;

  final ApiHelper _apiHelper = Get.find();

  final ShortlistController shortlistController = Get.find();

  void onSelectClick(ShortList shortList) {
    shortlistController.onSelectClick(shortList);
  }

  Future<void> onDateSelect(String shortlistId) async {
    DateTimeRange? selectedRange = await showDateRangePicker(
      context: context!,
      initialDateRange: DateTimeRange(
        start: DateTime.now().add(const Duration(days: 1)),
        end: DateTime.now().add(const Duration(days: 1)),
      ),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 1000)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).brightness == Brightness.light
              ? ThemeData.light().copyWith(
                  colorScheme: ColorScheme.light(
                    primary: MyColors.c_C6A34F,
                    onPrimary: Colors.white,
                    onSurface: MyColors.l111111_dwhite(context),
                  ),
                )
              : ThemeData.dark().copyWith(
                  colorScheme: ColorScheme.dark(
                    primary: MyColors.c_C6A34F,
                    onPrimary: Colors.white,
                    onSurface: MyColors.l111111_dwhite(context),
                  ),
                ),
          child: child!,
        );
      },
    );

    if (selectedRange != null) {
      Map<String, dynamic> data = {
        "id": shortlistId,
        "fromDate": selectedRange.start.toString().split(" ").first,
        "toDate": selectedRange.end.toString().split(" ").first
      };

      _updateShortListDateOrTime(data);
    }
  }

  Future<void> _updateShortListDateOrTime(Map<String, dynamic> data) async {
    CustomLoader.show(context!);

    await _apiHelper.updateShortlistItem(data).then((value) async {
      await shortlistController.fetchShortListEmployees();
      CustomLoader.hide(context!);
    });
  }

  void onTimeSelect(String shortlistId) {
    CustomHireTime.show(context!, (String fromTime, String toTime) {
      Map<String, dynamic> data = {"id": shortlistId, "fromTime": fromTime, "toTime": toTime};

      _updateShortListDateOrTime(data);
    });
  }

  void onBookAllClick() {
    if (shortlistController.shortList.isEmpty) {
      CustomDialogue.information(
        context: context!,
        title: "Empty Shortlist",
        description: "Please add employee to shortlist then continue",
      );
    } else if (shortlistController.isDateRangeSetForSelectedUser()) {
      Get.toNamed(Routes.clientTermsConditionForHire);
    } else {
      CustomDialogue.information(
        context: context!,
        title: "Invalid Input",
        description: "Please select the date and time range for when you want to hire an employee",
      );
    }
  }

  TimeOfDay timeConverter({required String time}) {
    TimeOfDay timeOfDay;
    List<String> timeParts = time.split(":");
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    timeOfDay = TimeOfDay(hour: hour, minute: minute);
    return timeOfDay;
  }

  double calculateTotalRate(
      {required String fromTime, required String toTime, required String daysDifference, required double hourlyRate}) {
    double totalRate =
        int.parse(daysDifference.split(' ').first) * calculateHourDifference(fromTime, toTime) * hourlyRate;
    return totalRate;
  }

  int calculateHourDifference(String fromTime, String toTime) {
    // Parse the time strings into DateTime objects
    DateFormat dateFormat = DateFormat("hh:mm a");
    DateTime fromDateTime = dateFormat.parse(fromTime);
    DateTime toDateTime = dateFormat.parse(toTime);

    // If the 'toTime' is before the 'fromTime', it means it spans across two days
    // We add one day (24 hours) to the 'toTime' to handle this case
    if (toDateTime.isBefore(fromDateTime)) {
      toDateTime = toDateTime.add(const Duration(hours: 24));
    }

    // Calculate the difference in hours
    int differenceInMilliseconds = toDateTime.difference(fromDateTime).inMilliseconds;
    double differenceInHours = differenceInMilliseconds / (1000 * 60 * 60);
    return differenceInHours.round();
  }
}
