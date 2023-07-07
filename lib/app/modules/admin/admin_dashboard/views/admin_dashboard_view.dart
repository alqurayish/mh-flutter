import 'package:horizontal_data_table/horizontal_data_table.dart';

import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_appbar.dart';
import '../../../../common/widgets/no_item_found.dart';
import '../controllers/admin_dashboard_controller.dart';

class AdminDashboardView extends GetView<AdminDashboardController> {
  const AdminDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;

    return Scaffold(
      appBar: CustomAppbar.appbar(
        context: context,
        title: 'Dashboard',
      ),
      body: Obx(
        () => controller.historyLoading.value ? const Center(child: CircularProgressIndicator.adaptive(
          backgroundColor: MyColors.c_C6A34F,
        )) : Column(
          children: [

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Row(
                      children: [
                        Obx(
                              () => Text(controller.dashboardDate.value.EdMMMy,
                            style: MyColors.l111111_dwhite(context).medium16,),
                        ),
                        const SizedBox(width: 5,),
                        const Icon(Icons.arrow_drop_down_circle, size: 16,),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 40.h,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18.w),
                        child: Obx(
                          () => DropdownButtonFormField<String>(
                            dropdownColor: MyColors.lightCard(context),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            onChanged: controller.onClientChange,
                            isExpanded: true,
                            itemHeight: 58.h,
                            isDense: false,
                            hint: Text(controller.clientLoading.value ? "Loading..." : "Select Client",
                              style: MyColors.l7B7B7B_dtext(context).regular18,
                            ),
                            value: "ALL",
                            items: controller.restaurants.map((e) {
                              return DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e,
                                  style: MyColors.l111111_dwhite(context).regular16_5,
                                ),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Theme.of(context).cardColor,
                              // contentPadding: const EdgeInsets.fromLTRB(0, 4, 8, 4),
                              floatingLabelStyle: const TextStyle(
                                fontFamily: MyAssets.fontMontserrat,
                                fontWeight: FontWeight.w600,
                                color: MyColors.c_C6A34F,
                              ),
                              contentPadding: const EdgeInsets.fromLTRB(10, 0, 5, 5),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(width: 1),
                                borderRadius: BorderRadius.circular(10.73),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(width: .5, color: MyColors.c_777777),
                                borderRadius: BorderRadius.circular(10.73),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(width: 1, color: MyColors.c_C6A34F),
                                borderRadius: BorderRadius.circular(10.73),
                                gapPadding: 10,
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(width: 1, color: Colors.redAccent),
                                borderRadius: BorderRadius.circular(10.73),
                              ),
                              hintMaxLines: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),

            Obx(
              () => Visibility(
                visible: (controller.checkInCheckOutHistory.value.checkInCheckOutHistory ?? []).isNotEmpty,
                child: Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.symmetric(vertical: 17),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      width: .5,
                      color: MyColors.c_A6A6A6,
                    ),
                    color: MyColors.lightCard(controller.context!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(child: _itemValue("Clients", controller.uniqueClient.value.toString())),
                      _vDivider,
                      Expanded(child: _itemValue("Hours", (controller.totalWorkingTimeInMinutes.value / 60).toStringAsFixed(1))),
                      _vDivider,
                      Expanded(child: _itemValue("Amount", "£${controller.amount.value}")),
                    ],
                  ),
                ),
              ),
            ),

            Obx(
              () => Visibility(
                visible: (controller.checkInCheckOutHistory.value.checkInCheckOutHistory ?? []).isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    "${controller.history.length} Employees Active",
                    style: MyColors.c_C6A34F.semiBold16,
                  ),
                ),
              ),
            ),
            Obx(
              () => Visibility(
                visible: (controller.checkInCheckOutHistory.value.checkInCheckOutHistory ?? []).isEmpty,
                child: controller.historyLoading.value
                    ? const CircularProgressIndicator.adaptive(
                        backgroundColor: MyColors.c_C6A34F,
                      )
                    : const NoItemFound(),
              ),
            ),

            Obx(
              () => Visibility(
                visible: (controller.checkInCheckOutHistory.value.checkInCheckOutHistory ?? []).isNotEmpty,
                child: Expanded(
                  child: HorizontalDataTable(
                    leftHandSideColumnWidth: 90.w,
                    rightHandSideColumnWidth: 1120.w,
                    isFixedHeader: true,
                    headerWidgets: _getTitleWidget(),
                    leftSideItemBuilder: _generateFirstColumnRow,
                    rightSideItemBuilder: _generateRightHandSideColumnRow,
                    itemCount: (controller.checkInCheckOutHistory.value.checkInCheckOutHistory ?? []).length,
                    rowSeparatorWidget: Container(
                      height: 6.h,
                      color: MyColors.lFAFAFA_dframeBg(context),
                    ),
                    leftHandSideColBackgroundColor: MyColors.lffffff_dbox(context),
                    rightHandSideColBackgroundColor: MyColors.lffffff_dbox(context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemValue(String text, String value) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            textAlign: TextAlign.center,
            style: MyColors.c_C6A34F.semiBold22,
          ),
          const SizedBox(height: 5),
          Text(
            text,
            textAlign: TextAlign.center,
            style: MyColors.l7B7B7B_dtext(controller.context!).medium12,
          ),
        ],
      );

  Widget get _vDivider => Container(
        width: .5,
        height: 30,
        color: MyColors.l111111_dwhite(controller.context!),
      );

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

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('Date', 90.w),
      _getTitleItemWidget('Restaurant Name', 150.w),
      _getTitleItemWidget('Employee Name', 150.w),
      _getTitleItemWidget('Position', 150.w),
      _getTitleItemWidget('Check in', 100.w),
      _getTitleItemWidget('Check out', 100.w),
      _getTitleItemWidget('Break Time', 100.w),
      _getTitleItemWidget('Total hours', 100.w),
      _getTitleItemWidget('Amount', 120.w),
      _getTitleItemWidget('Complain', 150.w),
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
      child: _cell(width: 90.w, value: controller.dailyStatistics(index).date),
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        _cell(width: 150.w, value: controller.dailyStatistics(index).restaurantName),
        _cell(width: 150.w, value: controller.dailyStatistics(index).employeeName),
        _cell(width: 150.w, value: controller.dailyStatistics(index).position),
        _cell(width: 100.w, value: controller.dailyStatistics(index).displayCheckInTime),
        _cell(width: 100.w, value: controller.dailyStatistics(index).displayCheckOutTime),
        _cell(width: 100.w, value: controller.dailyStatistics(index).displayBreakTime),
        _cell(width: 100.w, value: controller.dailyStatistics(index).workingHour),
        _cell(width: 120.w, value: controller.dailyStatistics(index).amount),
        _cell(width: 150.w, value: controller.dailyStatistics(index).complain),
      ],
    );
  }

  Widget _cell({required double width, required String value}) => SizedBox(
    width: width,
    height: 71.h,
    child: Center(
      child: Text(
        value,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: MyColors.l7B7B7B_dtext(controller.context!).semiBold13,
      ),
    ),
  );
}
