import 'package:lottie/lottie.dart';
import 'package:mh/app/common/utils/exports.dart';
import 'package:mh/app/common/widgets/custom_appbar.dart';
import 'package:mh/app/modules/calender/widgets/calender_bottom_nav_bar_widget.dart';
import 'package:mh/app/modules/calender/widgets/calender_header_widget.dart';
import 'package:mh/app/modules/calender/widgets/calender_widget_latest.dart';
import 'package:mh/app/modules/calender/widgets/employee_date_range_widget.dart';
import 'package:mh/app/modules/calender/widgets/selected_days_count_widget.dart';
import 'package:mh/app/modules/calender/widgets/short_list_date_range_widget.dart';
import 'package:mh/app/modules/employee/employee_home/controllers/employee_home_controller.dart';
import '../controllers/calender_controller.dart';

class CalenderView extends GetView<CalenderController> {
  const CalenderView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Scaffold(
      appBar: CustomAppbar.appbar(title: "Select Date Range", context: context),
      bottomNavigationBar: const CalenderBottomNavBarWidget(),
      body: Obx(() {
        if (controller.dateDataLoading.value == true) {
          return Center(child: Lottie.asset(MyAssets.lottie.calenderLoading, fit: BoxFit.cover, height: 200, width: 200));
        } else {
          return Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: const SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      children: [CalenderHeaderWidget(), CalenderWidgetLatest()],
                    ),
                  ),
                ),
              ),
              const Positioned.fill(
                  child: Align(
                alignment: Alignment.bottomCenter,
                child: SelectedDaysCountWidget(),
              )),
              Positioned.fill(
                  child: Align(
                alignment: Alignment.bottomCenter,
                child: Get.isRegistered<EmployeeHomeController>()
                    ? const EmployeeDateRangeWidget()
                    : const ShortListDateRangeWidget(),
              )),
            ],
          );
        }
      }),
    );
  }
}
