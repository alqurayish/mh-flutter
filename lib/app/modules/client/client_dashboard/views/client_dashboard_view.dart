import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:keyboard_visibility_pro/keyboard_visibility_pro.dart';
import 'package:mh/app/common/widgets/custom_dropdown.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../common/style/my_decoration.dart';
import '../../../../common/utils/exports.dart';
import '../../../../common/utils/validators.dart';
import '../../../../common/widgets/custom_appbar.dart';
import '../../../../common/widgets/custom_badge.dart';
import '../../../../common/widgets/custom_dialog.dart';
import '../../../../common/widgets/custom_network_image.dart';
import '../../../../common/widgets/no_item_found.dart';
import '../../../../models/employee_daily_statistics.dart';
import '../controllers/client_dashboard_controller.dart';
import '../models/current_hired_employees.dart';

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
      body: Obx(
        () => controller.loading.value
            ? const Center(child: CircularProgressIndicator(color: MyColors.c_C6A34F))
            : (controller.hiredEmployeesByDate.value.hiredHistories ?? []).isEmpty
                ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Obx(
                            () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => _selectDate(context),
                              child: Text(
                                controller.selectedDate.value,
                                style: MyColors.l111111_dwhite(context).medium16,
                              ),
                            ),
                            Text(
                              (controller.hiredEmployeesByDate.value.hiredHistories ?? []).isEmpty
                                  ? controller.loading.value
                                  ? ''
                                  : "No Employee found"
                                  : "${(controller.hiredEmployeesByDate.value.hiredHistories ?? []).length} Employee Active",
                              style: MyColors.c_C6A34F.semiBold16,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Expanded(child: NoItemFound()),
                  ],
                )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () => _selectDate(context),
                                child: Text(
                                  controller.selectedDate.value,
                                  style: MyColors.l111111_dwhite(context).medium16,
                                ),
                              ),
                              Text(
                                (controller.hiredEmployeesByDate.value.hiredHistories ?? []).isEmpty
                                    ? controller.loading.value
                                        ? ''
                                        : "No Employee found"
                                    : "${(controller.hiredEmployeesByDate.value.hiredHistories ?? []).length} Employee Active",
                                style: MyColors.c_C6A34F.semiBold16,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: HorizontalDataTable(
                          leftHandSideColumnWidth: 143.w,
                          rightHandSideColumnWidth: 600.w,
                          isFixedHeader: true,
                          headerWidgets: _getTitleWidget(),
                          leftSideItemBuilder: _generateFirstColumnRow,
                          rightSideItemBuilder: _generateRightHandSideColumnRow,
                          itemCount: (controller.hiredEmployeesByDate.value.hiredHistories ?? []).length,
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
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.dashboardDate.value,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).brightness == Brightness.light
              ? ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: MyColors.c_C6A34F,
              onPrimary: Colors.white,
              onSurface: MyColors.l111111_dwhite(context),
            ),
          ) : ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: MyColors.c_C6A34F,
              onPrimary: Colors.white,
              onSurface: MyColors.l111111_dwhite(context),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != controller.dashboardDate.value) {
      controller.onDatePicked(picked);
    }
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('Employee', 143.w),
      _getTitleItemWidget('Check in', 100.w),
      _getTitleItemWidget('Check out', 100.w),
      _getTitleItemWidget('Break Time', 100.w),
      _getTitleItemWidget('Total hours', 100.w),
      _getTitleItemWidget('Chat', 100.w),
      _getTitleItemWidget('Complain', 100.w),
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
    HiredHistory hiredHistory = controller.hiredEmployeesByDate.value.hiredHistories![index];

    return SizedBox(
      width: 143.w,
      height: 71.h,
      child: _cell(
        width: 143.w,
        value: '-',
        child: _employeeDetails(
          hiredHistory.employeeDetails?.employeeId ?? "",
          hiredHistory.employeeDetails?.name ?? "-",
          Utils.getPositionName(hiredHistory.employeeDetails!.positionId!),
          hiredHistory.employeeDetails?.profilePicture ?? "",
        ),
      ),
    );
  }

  Widget _cell({
    required double width,
    required String value,
    String? clientUpdatedValue,
    Widget? child,
  }) =>
      SizedBox(
        width: width,
        height: 71.h,
        child: child ?? Center(
          child: Text.rich(
            TextSpan(
                text: value,
                children: [
                  TextSpan(
                      text: (clientUpdatedValue == null) || (clientUpdatedValue == value) ? "" : '\n$clientUpdatedValue',
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                      )
                  ),
                ]
            ),
            textAlign: TextAlign.center,
            style: MyColors.l7B7B7B_dtext(controller.context!).semiBold13,
          ),
        ),
      );

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {

    HiredHistory hiredHistory = controller.hiredEmployeesByDate.value.hiredHistories![index];

    if(controller.getCheckInOutDate(index) == null) {
      return Row(
        children: <Widget>[
          _cell(width: 100.w, value: "-"),
          _cell(width: 100.w, value: "-"),
          _cell(width: 100.w, value: "-"),
          _cell(width: 100.w, value: "-"),
          _cell(width: 100.w, value: "", child: _chat(hiredHistory)),
          _cell(width: 100.w, value: "-",),
        ],
      );
    }

    UserDailyStatistics dailyStatistics = Utils.checkInOutToStatistics(controller.getCheckInOutDate(index)!);

    return Row(
      children: <Widget>[
        _cell(width: 100.w, value: dailyStatistics.displayCheckInTime, clientUpdatedValue: dailyStatistics.employeeCheckInTime),
        _cell(width: 100.w, value: dailyStatistics.displayCheckOutTime, clientUpdatedValue: dailyStatistics.employeeCheckOutTime),
        _cell(width: 100.w, value: dailyStatistics.displayBreakTime, clientUpdatedValue: dailyStatistics.employeeBreakTime),
        _cell(width: 100.w, value: dailyStatistics.workingHour),
        _cell(width: 100.w, value: "", child: _chat(hiredHistory)),
        _cell(width: 100.w, value: "--", child: _action(index)),
      ],
    );
  }

  Widget _action(int index) => controller.getComment(index).isEmpty
      ? GestureDetector(
          onTap: () {
            controller.setUpdatedDate(index);

            showMaterialModalBottomSheet(
              context: controller.context!,
              builder: (context) => Container(
                // padding: EdgeInsets.only(
                //   bottom: MediaQuery.of(context).viewInsets.bottom,
                // ),
                color: MyColors.lightCard(context),
                child: BottomA(_updateOption(index)),
              ),
            );
          },
          child: const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 22,
          ),
        )
      : GestureDetector(
          onTap: () {
            if(controller.clientCommentEnable(index)) {
              controller.setUpdatedDate(index);

              showMaterialModalBottomSheet(
                context: controller.context!,
                builder: (context) => Container(
                  // padding: EdgeInsets.only(
                  //   bottom: MediaQuery.of(context).viewInsets.bottom,
                  // ),
                  color: MyColors.lightCard(context),
                  child: BottomA(_updateOption(index)),
                ),
              );

            } else {
              CustomDialogue.information(
                context: controller.context!,
                title: "Restaurant Report on You",
                description: controller.getComment(index),
              );
            }
          },
          child: const Icon(
            Icons.info,
            color: Colors.blue,
            size: 22,
          ),
        );

  Widget _employeeDetails(String id, String name, String positionName, String image, ) {
    return Container(
      width: 143.w,
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
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 24.h,
                    width: 24.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.grey.withOpacity(.3),
                    ),
                    child: CustomNetworkImage(url: image.imageUrl,radius: 8.0,),
                  ),

                  Positioned(
                    top: -15,
                    right: -3,
                    child: Obx(
                      () => Visibility(
                        visible: controller.clientHomeController.employeeChatDetails.where((data) => data["employeeId"] == id && data["${controller.appController.user.value.userId}_unread"] > 0).isNotEmpty,
                        child: const CustomBadge(""),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(width: 10.w),
              Flexible(
                child: Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: MyColors.l5C5C5C_dwhite(controller.context!).semiBold14,
                ),
              ),
            ],
          ),

          SizedBox(height: 6.h),

          Text(
            positionName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: MyColors.l50555C_dtext(controller.context!).medium12,
          ),
        ],
      ),
    );
  }

  Widget _chat (HiredHistory hiredHistory) => GestureDetector(
        onTap: () => controller.chatWithEmployee(hiredHistory),
        child: Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(
                Icons.message,
                color: MyColors.c_C6A34F,
              ),

              Positioned(
                top: -15,
                right: -10,
                child: Obx(
                      () {
                        var result = controller.clientHomeController.employeeChatDetails.where((data) => data["employeeId"] == hiredHistory.employeeDetails!.employeeId! && data["${controller.appController.user.value.userId}_unread"] > 0);

                        if(result.isEmpty) return Container();
                        return CustomBadge(result.first["${controller.appController.user.value.userId}_unread"].toString());
                      },
                ),
              ),
            ],
          ),
        ),
      );

  Widget _updateOption(int index) => Form(
    key: controller.formKey,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 19.h),

        Center(
          child: Container(
            height: 4.h,
            width: 80.w,
            decoration: const BoxDecoration(
              color: MyColors.c_5C5C5C,
            ),
          ),
        ),

        SizedBox(height: 30.h),

        Row(
              children: [
                Expanded(
                  flex: 8,
                  child: CustomDropdown(
                    prefixIcon: Icons.timelapse,
                    hints: null,
                    value: controller.selectedComplainType,
                    items: controller.complainType,
                    onChange: (value) {
                      controller.onComplainTypeChange(index, value);
                    },
                  ),
                ),

                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 58.h,
                    child: TextFormField(
                      controller: controller.tecTime,
                      keyboardType: TextInputType.number,
                      cursorColor: MyColors.c_C6A34F,
                      style: MyColors.l111111_dwhite(controller.context!).regular14,
                      decoration: MyDecoration.inputFieldDecoration(
                        context: controller.context!,
                        label: "",
                      ),
                      validator: (String? value) => Validators.emptyValidator(
                        value?.trim(),
                        MyStrings.required.tr,
                      ),
                    ),
                  ),
                ),
                const Text("  Min"),
                const SizedBox(width: 14),
              ],
            ),

        SizedBox(height: 30.h),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: TextFormField(
            controller: controller.tecComment,
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: null,
            cursorColor: MyColors.c_C6A34F,
            style: MyColors.l111111_dwhite(controller.context!).regular14,
            decoration: MyDecoration.inputFieldDecoration(
              context: controller.context!,
              label: "Comment",
            ),
            validator: (String? value) => Validators.emptyValidator(
              value?.trim(),
              MyStrings.required.tr,
            ),
          ),
        ),

        SizedBox(height: 30.h),

        CustomButtons.button(
          height: 52.h,
          onTap: () => controller.onUpdatePressed(index),
          text: "Update",
          margin: const EdgeInsets.symmetric(horizontal: 14),
          customButtonStyle: CustomButtonStyle.radiusTopBottomCorner,
        ),

        SizedBox(height: 30.h),
      ],
    ),
  );
}


class BottomA extends StatefulWidget {
  final Widget updateOption;
  const BottomA(this.updateOption, {Key? key}) : super(key: key);

  @override
  State<BottomA> createState() => _BottomAState();
}

class _BottomAState extends State<BottomA> {

  double p = 0;

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibility(
      onChanged: (bool visible) {
        setState(() {
          p = visible ? 300 : 0;
        });
      },
      child: Container(
        padding: EdgeInsets.only(bottom: p),
        child: widget.updateOption,
      ),
    );
  }
}

