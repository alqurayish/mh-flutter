import 'package:horizontal_data_table/horizontal_data_table.dart';

import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_appbar.dart';
import '../controllers/employee_dashboard_controller.dart';

class EmployeeDashboardView extends GetView<EmployeeDashboardController> {
  const EmployeeDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;

    return Scaffold(
      appBar: CustomAppbar.appbar(
        context: context,
        title: 'Features',
      ),
      body: Column(
        children: [
          SizedBox(height: 30.h),
          Expanded(
            child: HorizontalDataTable(
              leftHandSideColumnWidth: 90.w,
              rightHandSideColumnWidth: 520.w,
              isFixedHeader: true,
              headerWidgets: _getTitleWidget(),
              leftSideItemBuilder: _generateFirstColumnRow,
              rightSideItemBuilder: _generateRightHandSideColumnRow,
              itemCount: 20,
              rowSeparatorWidget: Container(
                height: 6.h,
                color: MyColors.lFAFAFA_dframeBg(context),
              ),
              leftHandSideColBackgroundColor: MyColors.lffffff_dbox(context),
              rightHandSideColBackgroundColor: MyColors.lffffff_dbox(context),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('Date', 90.w),
      _getTitleItemWidget('Check in', 100.w),
      _getTitleItemWidget('Check out', 100.w),
      _getTitleItemWidget('Break Time', 100.w),
      _getTitleItemWidget('Total hours', 100.w),
      _getTitleItemWidget('Total Amount', 120.w),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      width: width,
      height: 62.h,
      color: MyColors.c_C6A34F,
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: MyColors.lffffff_dframeBg(controller.context!).semiBold14,
        ),
      ),
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      width: 90.w,
      height: 71.h,
      color: Colors.white,
      child: _cell(width: 90.w, value: "10 Jan, 23"),
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        _cell(width: 100.w, value: "9:00"),
        _cell(width: 100.w, value: "12:00"),
        _cell(width: 100.w, value: "30 min"),
        _cell(width: 100.w, value: "2.5 Hours"),
        _cell(width: 120.w, value: "£ 45.00"),
      ],
    );
  }

  Widget _cell({required double width, required String value}) => SizedBox(
        width: width,
        height: 71.h,
        child: Center(
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: MyColors.l7B7B7B_dtext(controller.context!).semiBold13,
          ),
        ),
      );
}
