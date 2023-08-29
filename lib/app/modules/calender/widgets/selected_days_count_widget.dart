import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mh/app/common/values/my_assets.dart';
import 'package:mh/app/common/values/my_color.dart';
import 'package:mh/app/modules/calender/controllers/calender_controller.dart';

class SelectedDaysCountWidget extends GetWidget<CalenderController> {
  const SelectedDaysCountWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin:  EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.03),
      width: MediaQuery.of(context).size.width * 0.6,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0), color: MyColors.c_C6A34F),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(MyAssets.calender1, height: 20, width: 20),
          Obx(() =>  Text(' ${controller.selectedDates.length}',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24))),
          const Text(' Days have been selected',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }
}
