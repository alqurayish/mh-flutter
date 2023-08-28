import 'package:intl/intl.dart';
import 'package:mh/app/common/utils/exports.dart';
import 'package:mh/app/modules/calender/controllers/calender_controller.dart';
import 'package:mh/app/modules/calender/widgets/calender_month_widget.dart';

class CalenderWidgetLatest extends GetWidget<CalenderController> {
  const CalenderWidgetLatest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Obx(() => Text(
                DateFormat.yMMMM().format(controller.selectedDate.value),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.grey.withOpacity(0.3),
                border: Border.all(color: Colors.grey.shade300)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: controller.dayNames
                  .map((dayName) => Text(
                        dayName,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: PageView.builder(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              itemCount: 2,
              itemBuilder: (context, index) {
                final DateTime month = DateTime.now().add(Duration(days: index * 30));
                return CalenderMonthWidget(month: month, controller: controller);
              },
            ),
          ),
          const SizedBox(height: 20),
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: controller.selectedDate.value.month == DateTime.now().month
                              ? Colors.blue
                              : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(5.0)),
                      width: 30,
                      height: 5),
                  const SizedBox(width: 10),
                  Container(
                      width: 30,
                      height: 5,
                      decoration: BoxDecoration(
                          color: controller.selectedDate.value.month != DateTime.now().month
                              ? Colors.blue
                              : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(5.0))),
                ],
              )),
          const SizedBox(height: 20),
          Container(
            width: Get.width * 0.6,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: MyColors.c_C6A34F),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.calendar_month, color: Colors.white),
               Obx(() =>  Text(' ${controller.selectedDates.length}',
                   style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24))),
                const Text(' Days have been selected',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
