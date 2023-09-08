import 'package:mh/app/common/utils/exports.dart';
import 'package:mh/app/modules/calender/controllers/calender_controller.dart';

class CalenderMonthWidget extends StatelessWidget {
  final DateTime month;
  final CalenderController controller;
  const CalenderMonthWidget({Key? key, required this.month, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();
    final int daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final int firstDayWeekday = (DateTime(month.year, month.month, 1).weekday + 5) % 7 + 1;
    final int weeks = (daysInMonth + firstDayWeekday - 1) ~/ 7 + 1;

    return GridView.builder(
      itemCount: weeks * 7,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
      itemBuilder: (context, index) {
        final int day = index + 1 - firstDayWeekday;
        if (day <= 0 || day > daysInMonth) {
          return Container();
        }
        final DateTime currentDate = DateTime(month.year, month.month, day);

        Color borderColor = Colors.transparent;
        Color textColor = Colors.black;
        Color containerColor = Colors.transparent;

        bool canTapDate = false;
        if (currentDate.toString().substring(0, 10) == today.toString().substring(0, 10)) {
          borderColor = MyColors.c_C6A34F; // Today's date should be red
        } else if (controller.dateListModel.value.bookedDates!.containsDate(currentDate)) {
          textColor = Colors.red; // Booked dates should be red
        } else if (controller.dateListModel.value.pendingDates!.containsDate(currentDate)) {
          textColor = Colors.amber; // Pending dates should be yellow
        } else if (controller.dateListModel.value.unavailableDates!.containsDate(currentDate)) {
          textColor = MyColors.l111111_dwhite(context); // Unavailable dates should be black
        } else if (currentDate.isBefore(DateTime.now()) || controller.selectedDate.value == currentDate) {
          textColor = Colors.grey;
        } else {
          textColor = Colors.green; // Available days should be green
          canTapDate = true;
        }

        return GestureDetector(
          onTap: canTapDate ? () => controller.onDateClick(currentDate: currentDate) : null,
          child: Obx(() {
            final bool isSelected = controller.selectedDates.contains(currentDate);
            final bool isDateInRange =
                controller.requestDateList.any((dateRange) => controller.isDateInSelectedRange(currentDate, dateRange));

            if (isSelected == true) {
              containerColor = MyColors.c_C6A34F;
              textColor = MyColors.white; // Change container color for selected dates
            } else if (isDateInRange == true) {
              containerColor = MyColors.c_DDBD68.withOpacity(0.8);
              textColor = MyColors.white;
            } else if (isSelected == false && canTapDate == true) {
              containerColor = Colors.transparent;
              textColor = Colors.green;
            }
            return Container(
              margin: const EdgeInsets.all(5.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: borderColor),
                color: isSelected ? MyColors.c_C6A34F : containerColor,
              ),
              child: Text(
                day.toString(),
                style:
                    TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 15), // Text color based on textColor variable
              ),
            );
          }),
        );
      },
    );
  }
}
