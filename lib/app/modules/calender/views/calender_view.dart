import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mh/app/common/widgets/custom_appbar.dart';
import 'package:mh/app/common/widgets/custom_bottombar.dart';
import 'package:mh/app/common/widgets/custom_buttons.dart';
import 'package:mh/app/enums/custom_button_style.dart';
import 'package:mh/app/modules/calender/widgets/calender_header_widget.dart';
import 'package:mh/app/modules/calender/widgets/calender_widget.dart';
import 'package:mh/app/modules/calender/widgets/calender_widget_latest.dart';

import '../controllers/calender_controller.dart';

class CalenderView extends GetView<CalenderController> {
  const CalenderView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    controller.context = context;

    return Scaffold(
      appBar: CustomAppbar.appbar(title: "Select Date Range", context: context),
      bottomNavigationBar: CustomBottomBar(
        child: CustomButtons.button(
          onTap: () {},
          text: "Submit",
          customButtonStyle: CustomButtonStyle.radiusTopBottomCorner,
        ),
      ),
      body: Obx(() {
        if (controller.dateDataLoading.value == true) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else {
          return const SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                children: [CalenderHeaderWidget(), CalenderWidgetLatest()],
              ),
            ),
          );
        }
      }),
    );
  }
}
