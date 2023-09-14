import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mh/app/common/extensions/extensions.dart';
import 'package:mh/app/common/values/my_assets.dart';
import 'package:mh/app/common/values/my_color.dart';
import 'package:mh/app/modules/client/client_shortlisted/models/add_to_shortlist_request_model.dart';

class TimeRangeWidget extends StatelessWidget {
  final RequestDateModel requestDate;
  final bool hasDeleteOption;
  final VoidCallback onTap;
  const TimeRangeWidget({Key? key, required this.requestDate, required this.hasDeleteOption, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 10.w),
      margin:  EdgeInsets.only(top: 15.0.h),
      decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(MyAssets.calender2, height: 20.w, width: 20.w),
              Text(DateFormat('E, dd MMM, yyyy').format(DateTime.parse(requestDate.startDate ?? '')),
                  style: MyColors.l111111_dwhite(context).medium13),
              Container(width: 12.w, color: Colors.grey, height: 2.h),
              Text(DateFormat('E, dd MMM, yyyy').format(DateTime.parse(requestDate.endDate ?? '')),
                  style: MyColors.l111111_dwhite(context).medium13),
              if (hasDeleteOption == true)
                Material(
                    color: Colors.transparent,
                    child: InkWell(onTap: onTap, child: const Icon(Icons.remove, color: Colors.red)))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _timeWidget(time: requestDate.startTime ?? ''),
              Container(width: 12.w, color: Colors.grey, height: 2.h),
              _timeWidget(time: requestDate.endTime ?? ''),
            ],
          )
        ],
      ),
    );
  }

  Widget _timeWidget({required String time}) {
    return Container(
      width: 120.w,
      padding:  EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 3.0.h),
      decoration: BoxDecoration(
          color: MyColors.lightCard(Get.context!),
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(5.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [Image.asset(MyAssets.clock, height: 18.h, width: 18.w), Text(time, style: MyColors.l111111_dwhite(Get.context!).medium13)],
      ),
    );
  }
}
