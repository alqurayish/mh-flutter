import 'package:intl/intl.dart';
import 'package:mh/app/common/utils/exports.dart';
import 'package:mh/app/modules/calender/controllers/calender_controller.dart';

class ShortListDateRangeWidget extends GetWidget<CalenderController> {
  const ShortListDateRangeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('ShortListDateRangeWidget.build: ${controller.rangeEndDate.value}');
    return Obx(() => Visibility(
        visible: controller.rangeStartDate.value != null && controller.selectedDates.isNotEmpty,
        child: Container(
          height: 100,
          decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10.0)),
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.11, left: 15.0, right: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => Row(
                          children: [
                            Image.asset(MyAssets.calender2, height: 20, width: 20),
                            Text(' ${DateFormat('E, dd MMM, yyyy').format(controller.rangeStartDate.value!)}  -  ',
                                style: MyColors.black.medium12),
                            if (controller.rangeEndDate.value == null)
                              Text('Select End Date', style: MyColors.c_7B7B7B.medium12)
                            else
                              Text(DateFormat('E, dd MMM, yyyy').format(controller.rangeEndDate.value!),
                                  style: MyColors.black.medium12),
                          ],
                        )),
                    InkWell(onTap: controller.onRemoveClick, child: const Icon(Icons.remove, color: Colors.red))
                  ],
                ),
              ),
              Obx(() => Visibility(
                  visible: controller.rangeEndDate.value == null,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5.w),
                    child: Row(
                      children: [
                        Checkbox(
                            activeColor: MyColors.c_C6A34F,
                            checkColor: MyColors.c_FFFFFF,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                            side: MaterialStateBorderSide.resolveWith(
                              (states) => const BorderSide(width: 2.0, color: MyColors.c_C6A34F),
                            ),
                            value: controller.sameAsStartDate.value,
                            onChanged: controller.onSameAsStartDatePressed),
                        Text('Same as Start Date', style: MyColors.black.medium15),
                      ],
                    ),
                  ))),
              Obx(() => Visibility(
                  visible: controller.rangeEndDate.value != null && controller.rangeEndDate.value != null,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _timeWidget(time: '8.00 AM'),
                        const Text('-'),
                        _timeWidget(time: '09:00 AM'),
                      ],
                    ),
                  ))),
            ],
          ),
        )));
  }

  Widget _timeWidget({required String time}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
      decoration:
          BoxDecoration(
            color: MyColors.lightCard(Get.context!),
              border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(5.0)),
      child: Row(
        children: [Image.asset(MyAssets.clock, height: 20, width: 20),
          const SizedBox(width: 10),
          Text(time)],
      ),
    );
  }
}
