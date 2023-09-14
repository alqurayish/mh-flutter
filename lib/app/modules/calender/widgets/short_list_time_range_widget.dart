import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mh/app/common/extensions/extensions.dart';
import 'package:mh/app/common/values/my_assets.dart';
import 'package:mh/app/common/values/my_color.dart';
import 'package:mh/app/modules/calender/controllers/calender_controller.dart';
import 'package:mh/app/modules/client/client_shortlisted/models/add_to_shortlist_request_model.dart';

class ShortListTimeRangeWidget extends StatelessWidget {
  final RequestDateModel requestDate;
  final int index;
  const ShortListTimeRangeWidget({Key? key, required this.requestDate, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      decoration: BoxDecoration(color: Get.isDarkMode ?Colors.grey.shade800 :Colors.grey.shade200, borderRadius: BorderRadius.circular(10.0)),
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.11, left: 15.0.w, right: 15.0.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 15.0.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Image.asset(MyAssets.calender2, height: 20.w, width: 20.w),
                    Text(' ${DateTime.parse(requestDate.startDate ?? "").formatDateWithWeekday()}  ',
                        style: MyColors.l111111_dwhite(context).semiBold13),
                    Container(width: 12.w, color: Colors.grey, height: 2.h),
                    if (requestDate.endDate == null)
                      Text('  Select End Date', style: MyColors.c_7B7B7B.semiBold13)
                    else
                      Text('  ${DateTime.parse(requestDate.endDate ?? "").formatDateWithWeekday()}',
                          style: MyColors.l111111_dwhite(context).semiBold13),
                  ],
                ),
                 SizedBox(width: 20.w),
                InkWell(
                    onTap: () => Get.find<CalenderController>().onRemoveClickForShortList(index: index),
                    child: const Icon(Icons.remove, color: Colors.red))
              ],
            ),
          ),
          Obx(() => Visibility(
              visible: requestDate.endDate == null,
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
                        value: Get.find<CalenderController>().sameAsStartDate.value,
                        onChanged: Get.find<CalenderController>().onSameAsStartDatePressedForShortList),
                    Text('Same as Start Date', style: MyColors.primaryDark.semiBold15),
                  ],
                ),
              ))),
          if (requestDate.startDate != null &&
              requestDate.endDate != null &&
              requestDate.startTime == null &&
              requestDate.endTime == null)
            _selectTimeRangeWidget(index: index)
          else if (requestDate.startTime != null && requestDate.endTime != null)
            _timeRangeWidget(requestDate: requestDate, index: index)
        ],
      ),
    );
  }

  Widget _selectTimeRangeWidget({required int index}) {
    return InkWell(
      onTap: () => Get.find<CalenderController>().showTimePickerBottomSheet(index: index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
        decoration: BoxDecoration(
            color: MyColors.lightCard(Get.context!),
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(5.0)),
        child: Row(
          children: [
            Image.asset(MyAssets.clock, height: 20, width: 20),
            const SizedBox(width: 10),
            Text('Select Time Range', style: MyColors.l111111_dwhite(Get.context!).semiBold13)
          ],
        ),
      ),
    );
  }

  Widget _timeRangeWidget({required RequestDateModel requestDate, required int index}) {
    return Row(
      children: [
        _timeWidget(time: requestDate.startTime ?? '', index: index),
         Text('  -  ', style: MyColors.l111111_dwhite(Get.context!).semiBold13),
        _timeWidget(time: requestDate.endTime ?? '', index: index),
      ],
    );
  }

  Widget _timeWidget({required String time, required int index}) {
    return InkWell(
      onTap: ()=>Get.find<CalenderController>().showTimePickerBottomSheet(index: index),
      child: Container(
        width: 130,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
        decoration: BoxDecoration(
            color: MyColors.lightCard(Get.context!),
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(5.0)),
        child: Row(
          children: [Image.asset(MyAssets.clock, height: 20, width: 20), const SizedBox(width: 10), Text(time, style: MyColors.l111111_dwhite(Get.context!).semiBold13)],
        ),
      ),
    );
  }
}
