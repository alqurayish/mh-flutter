import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_appbar.dart';
import '../../../../common/widgets/custom_bottombar.dart';
import '../../../../common/widgets/custom_network_image.dart';
import '../../../../common/widgets/no_item_found.dart';
import '../controllers/client_shortlisted_controller.dart';
import '../models/shortlisted_employees.dart';

class ClientShortlistedView extends GetView<ClientShortlistedController> {
  const ClientShortlistedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Scaffold(
      appBar: CustomAppbar.appbar(
        title: "Shortlist",
        context: context,
      ),
      bottomNavigationBar: _bottomBar(context),
      body: Obx(
        () => controller.shortlistController.isFetching.value
            ? const Center(child: CircularProgressIndicator.adaptive(backgroundColor: MyColors.c_C6A34F))
            : controller.shortlistController.shortList.isEmpty
                ? const NoItemFound()
                : Column(
                    children: [
                      SizedBox(height: 22.h),
                      ...controller.shortlistController.getUniquePositions().map((String e) {
                        return _employeeInSamePosition(e);
                      }),
                    ],
                  ),
      ),
    );
  }

  Widget _employeeInSamePosition(String positionId) {
    final List<ShortList> employees = controller.shortlistController.getEmployeesBasedOnPosition(positionId);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 12.h),
          child: Text(
            "${Utils.getPositionName(positionId)} (${employees.length})",
            style: MyColors.l111111_dwhite(controller.context!).semiBold16,
          ),
        ),
        ...employees.map((e) {
          return _employeeItem(e);
        }),
      ],
    );
  }

  Widget _employeeItem(ShortList employee) {
    print(
        'ClientShortlistedView._employeeItem: ${employee.fromDate}, ${employee.fromTime} - ${employee.toDate}, ${employee.toTime}');
    return Column(
      children: [
        Container(
          height: 110.h,
          margin: EdgeInsets.symmetric(horizontal: 24.w),
          decoration: BoxDecoration(
            color: MyColors.lightCard(controller.context!),
            borderRadius: BorderRadius.circular(10.0).copyWith(
              bottomRight: const Radius.circular(11),
            ),
            border: Border.all(
              width: .5,
              color: MyColors.c_A6A6A6,
            ),
          ),
          child: Row(
            children: [
              _image((employee.employeeDetails?.profilePicture ?? "").imageUrl),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _name(employee.employeeDetails?.name ?? "-"),
                                  _rating(employee.employeeDetails?.rating ?? 0),
                                  const Spacer(),
                                  Obx(
                                    () => controller.shortlistController.getIcon(
                                      employee.employeeId!,
                                      controller.shortlistController.isFetching.value,
                                    ),
                                  ),
                                  // Obx(
                                  //   () => controller.loadingRemoveFromShortcut.value && employee.id == controller.removeShortlistId
                                  //       ? const Center(
                                  //           child: CircularProgressIndicator.adaptive(),
                                  //         )
                                  //       : GestureDetector(
                                  //           onTap: () => controller.onBookmarkClick(employee),
                                  //           child: const Icon(
                                  //             Icons.bookmark,
                                  //             color: MyColors.c_C6A34F,
                                  //           ),
                                  //         ),
                                  // ),
                                  SizedBox(width: 9.w),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    Divider(
                      thickness: .5,
                      height: 1,
                      color: MyColors.c_D9D9D9,
                      endIndent: 13.w,
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () => controller.onDateSelect(employee.sId!),
                                child: Container(
                                  height: 25.h,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5.w,
                                    vertical: 2.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: MyColors.c_F5F5F5,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset(MyAssets.calender),
                                      SizedBox(width: 10.w),
                                      Text(
                                        employee.fromDate != null && employee.toDate != null
                                            ? "${employee.fromDate!.dMMMy} - ${employee.toDate!.dMMMy} (${employee.fromDate!.differenceInDays(employee.toDate!)})"
                                            : "--/--/--   -   --/--/--",
                                        style: MyColors.c_111111.medium12,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 7),
                              GestureDetector(
                                onTap: () => controller.onTimeSelect(employee.sId!),
                                child: Container(
                                  height: 25.h,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5.w,
                                    vertical: 2.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: MyColors.c_F5F5F5,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset(MyAssets.totalHour),
                                      SizedBox(width: 10.w),
                                      Text(
                                        employee.fromTime != null && employee.toTime != null
                                            ? "From ${employee.fromTime}   To ${employee.toTime}"
                                            : "From --:--   To --:--",
                                        style: MyColors.c_111111.medium12,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 17.w),
                        Obx(
                          () => GestureDetector(
                            onTap: () => controller.onSelectClick(employee),
                            child: Container(
                              width: 25.h,
                              height: 25.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: controller.shortlistController.selectedForHire.contains(employee)
                                    ? Colors.green.shade400
                                    : MyColors.c_F5F5F5,
                                border: Border.all(
                                  color: controller.shortlistController.selectedForHire.contains(employee)
                                      ? Colors.green
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Icon(
                                Icons.check,
                                size: 14,
                                color: controller.shortlistController.selectedForHire.contains(employee)
                                    ? Colors.white
                                    : Colors.grey.shade300,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 20.0),
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            height: 30.h,
            width: 200.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0.0)
                    .copyWith(bottomLeft: const Radius.circular(10.0), bottomRight: const Radius.circular(10.0)),
                color: MyColors.c_C6A34F),
            child: Center(
                child: Text(
              (employee.fromDate != null &&
                      employee.toDate != null &&
                      employee.fromTime != null &&
                      employee.toTime != null &&
                      employee.employeeDetails?.hourlyRate != null)
                  ? 'Total Rate: £ ${controller.calculateTotalRate(fromDateStr: employee.fromDate.toString(), toDateStr: employee.toDate.toString(), fromTimeStr: employee.fromTime.toString(), toTimeStr: employee.toTime.toString(), hourlyRate: employee.employeeDetails?.hourlyRate ?? 0.0)}'
                  : 'Hourly Rate: £ ${employee.employeeDetails?.hourlyRate ?? 0.0}',
              style: const TextStyle(color: MyColors.c_FFFFFF),
            )))
      ],
    );
  }

  Widget _image(String profilePicture) => Container(
        margin: const EdgeInsets.fromLTRB(8, 8, 13, 8),
        width: 74.w,
        height: 74.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.grey.withOpacity(.1),
        ),
        child: CustomNetworkImage(
          url: profilePicture,
          radius: 5,
        ),
      );

  Widget _name(String name) => Text(
        name,
        style: MyColors.l111111_dwhite(controller.context!).medium14,
      );

  Widget _rating(int rating) => Visibility(
        visible: rating > 0,
        child: Row(
          children: [
            SizedBox(width: 10.w),
            Container(
              height: 2.h,
              width: 2.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MyColors.l111111_dwhite(controller.context!),
              ),
            ),
            SizedBox(width: 10.w),
            const Icon(
              Icons.star,
              color: MyColors.c_FFA800,
              size: 16,
            ),
            SizedBox(width: 2.w),
            Text(
              rating.toString(),
              style: MyColors.l111111_dwhite(controller.context!).medium14,
            ),
          ],
        ),
      );

  Widget _bottomBar(BuildContext context) {
    return Obx(
      () => CustomBottomBar(
        child: CustomButtons.button(
          onTap: controller.onBookAllClick,
          text: controller.shortlistController.selectedForHire.isEmpty ||
                  controller.shortlistController.selectedForHire.length ==
                      controller.shortlistController.totalShortlisted.value
              ? "Book All"
              : "Book (${controller.shortlistController.selectedForHire.length}) Employee",
          customButtonStyle: CustomButtonStyle.radiusTopBottomCorner,
        ),
      ),
    );
  }
}
