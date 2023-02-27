import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_appbar.dart';
import '../../../../common/widgets/no_item_found.dart';
import '../controllers/client_dashboard_controller.dart';

class ClientDashboardView extends GetView<ClientDashboardController> {
  const ClientDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;

    return Scaffold(
      appBar: CustomAppbar.appbar(
        title: MyStrings.dashboard.tr,
        context: context,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            SizedBox(height: 16.h),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Obx(
                      () => Text(controller.selectedDate.value,
                      style: MyColors.l111111_dwhite(context).medium16,),
                    ),
                  ),

                  Text(
                    controller.dashboardResult.isEmpty
                        ? "No Employee found"
                        : "${controller.dashboardResult.length} Employee Active",
                    style: MyColors.c_C6A34F.semiBold16,
                  ),
                ],
              ),
            ),
            Obx(
              () => controller.loading.value
                  ? const Center(child: CircularProgressIndicator())
                  : controller.dashboardResult.isEmpty
                      ? const NoItemFound()
                      : SingleChildScrollView(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _buildEmployeeDetails(),
                              ),
                              Flexible(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: _buildRows(),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.dashboardDate.value,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != controller.dashboardDate.value) {
      controller.onDatePicked(picked);
    }
  }

  List<Widget> _buildEmployeeDetails() {
    return List.generate(
      25 + 1,
      (index) => Container(
        alignment: Alignment.center,
        width: controller.fields.first["width"],
        height: 71.h,
        child: index == 0
            ? Container(
                width: controller.fields.first["width"] - 3,
                height: 71.h,
                decoration: BoxDecoration(
                  color: MyColors.c_C6A34F,
                  border: Border(
                    right: BorderSide(
                        width: 3.0, color: Colors.grey.withOpacity(.1)),
                  ),
                ),
                child: Center(
                  child: Text(
                    controller.fields.first["name"],
                    style: MyColors.white.semiBold14,
                  ),
                ),
              )
            : _employeeDetails(),
      ),
    );
  }

  Widget _employeeDetails() {
    return Container(
      width: controller.fields.first["width"],
      padding: const EdgeInsets.all(7.0),
      decoration: BoxDecoration(
        color: MyColors.lightCard(controller.context!),
        border: Border(
          right: BorderSide(width: 3.0, color: Colors.grey.withOpacity(.1)),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 24.h,
                width: 24.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey.withOpacity(.3),
                ),
              ),

              SizedBox(width: 10.w),
              Flexible(
                child: Text(
                  "Name",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: MyColors.l5C5C5C_dwhite(controller.context!).semiBold14,
                ),
              ),
            ],
          ),

          SizedBox(height: 6.h),

          Text(
            "Manager",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: MyColors.l50555C_dtext(controller.context!).medium12,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRows() {
    return List.generate(
      25 + 1,
      (index) => Row(
        children: index == 0 ? _buildRowHeader() : _buildRowCells(),
      ),
    );
  }

  List<Widget> _buildRowHeader() {
    return List.generate(
      controller.fields.length - 1,
      (index) => Container(
        alignment: Alignment.center,
        width: controller.fields[index + 1]["width"],
        height: 71.h,
        color: MyColors.c_C6A34F,
        child: Text(
          controller.fields[index + 1]["name"],
          style: MyColors.white.semiBold14,
        ),
      ),
    );
  }

  List<Widget> _buildRowCells() {
    return List.generate(
      controller.fields.length - 1,
      (index) => Container(
        alignment: Alignment.center,
        width: controller.fields[index + 1]["width"],
        height: 71.h,
        color: Colors.white,
        child: _getChild(index+1),
      ),
    );
  }

  Widget _getChild(int index) {
    switch (controller.fields[index]["name"]) {
      case "Check In":
        return _checkIn;
      case "Check Out":
        return _checkOut;
      case "Break Time":
        return _breakTime;
      case "Total Hours":
        return _totalHours;
      case "Chat":
        return _chat;
      case "More":
      default:
        return _more;
    }
  }

  Widget _cellValue(String value) => Text(
        value,
        style: MyColors.c_7B7B7B.semiBold13,
      );

  Widget get _checkIn => _cellValue("9:00");

  Widget get _checkOut => _cellValue("12:00");

  Widget get _breakTime => _cellValue("30 min");

  Widget get _totalHours => _cellValue("2.5 min");

  Widget get _totalAmount => _cellValue("£ 45.00");

  Widget get _chat => const Icon(
        Icons.message,
        color: MyColors.c_C6A34F,
      );

  Widget get _more => Container(
    width: 95.w,
    height: 37.h,
    decoration: BoxDecoration(
        color: MyColors.lightCard(controller.context!),
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(
          width: .5,
          color: MyColors.c_A6A6A6,
        ),
    ),
    child: Row(
      children: [
        const Expanded(child: Icon(Icons.close_rounded, color: Colors.red,),),
        Container(
          height: 25,
          width: 1,
          color: MyColors.c_DADADA,
        ),
        const Expanded(child: Icon(Icons.check_rounded, color: Colors.green,),),
      ],
    ),
  );
}
