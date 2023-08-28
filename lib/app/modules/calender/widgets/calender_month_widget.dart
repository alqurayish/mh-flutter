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

        if (currentDate == today) {
          borderColor = MyColors.c_C6A34F; // Today's date should be red
        } else if (controller.dateListModel.value.bookedDates!.containsDate(currentDate)) {
          textColor = Colors.red; // Booked dates should be red
        } else if (controller.dateListModel.value.pendingDates!.containsDate(currentDate)) {
          textColor = Colors.yellow; // Pending dates should be yellow
        } else if (controller.dateListModel.value.unavailableDates!.containsDate(currentDate)) {
          textColor = Colors.black; // Unavailable dates should be black
        } else if (currentDate.isBefore(DateTime.now()) || controller.selectedDate.value == currentDate) {
          textColor = Colors.grey;
        } else {
          textColor = Colors.green; // Available days should be green
          canTapDate = true;
        }

        final isSelected = controller.selectedDates.contains(currentDate);
        if (isSelected) {
          containerColor = MyColors.c_C6A34F;
          textColor = Colors.white; // Change container color for selected dates
        }

        return GestureDetector(
          onTap: canTapDate ? () => controller.onDateClick(currentDate: currentDate) : null,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: borderColor),
              color: isSelected ? MyColors.c_C6A34F : containerColor,
            ),
            child: Text(
              day.toString(),
              style: TextStyle(color: textColor), // Text color based on textColor variable
            ),
          ),
        );
      },
    );
  }
}
