import 'package:mh/app/common/controller/app_controller.dart';
import 'package:mh/app/common/widgets/shimmer_widget.dart';
import 'package:mh/app/modules/client/client_shortlisted/models/add_to_shortlist_request_model.dart';

import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_appbar.dart';
import '../../../../common/widgets/custom_network_image.dart';
import '../../client_dashboard/models/current_hired_employees.dart';
import '../controllers/client_my_employee_controller.dart';

class ClientMyEmployeeView extends GetView<ClientMyEmployeeController> {
  const ClientMyEmployeeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;

    return Scaffold(
      appBar: CustomAppbar.appbar(
        title: MyStrings.myEmployees.tr,
        context: context,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? _loading
            : (controller.employees.value.hiredHistories ?? []).isEmpty
                ? _noEmployeeHireYet
                : _showEmployeeList,
      ),
    );
  }

  Widget get _noEmployeeHireYet => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "No employee hire yet",
              style: MyColors.l111111_dwhite(controller.context!).semiBold16,
            ),
          ),
        ],
      );

  Widget get _loading => Padding(
    padding: const EdgeInsets.all(15.0),
    child: Center(child: ShimmerWidget.clientMyEmployeesShimmerWidget()),
  );

  Widget get _showEmployeeList => ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        itemCount: controller.employees.value.hiredHistories?.length ?? 0,
        itemBuilder: (context, index) {
          return _employeeItem(
            controller.employees.value.hiredHistories![index],
          );
        },
      );

  Widget _employeeItem(HiredHistory hiredHistory) {
    return Container(
      height: 120.h,
      margin: EdgeInsets.symmetric(horizontal: 15.w).copyWith(
        bottom: 20.h,
      ),
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
      child: InkWell(
        // onTap: () => controller.onEmployeeClick(user),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              bottom: 0,
              child: SizedBox(
                width: 122.w,
                child: CustomButtons.button(
                  height: 28.w,
                  text:
                      "${Utils.getCurrencySymbol(Get.find<AppController>().user.value.client?.countryName ?? '')}${hiredHistory.employeeDetails?.hourlyRate ?? 0} /h",
                  margin: EdgeInsets.zero,
                  fontSize: 12,
                  customButtonStyle: CustomButtonStyle.radiusTopBottomCorner,
                  onTap: null,
                ),
              ),
            ),
            Positioned(
              right: 5,
              top: 3,
              child: Obx(
                () => controller.shortlistController.getIcon(
                    requestedDateList: <RequestDateModel>[],
                    employeeId: hiredHistory.id!,
                    isFetching: controller.shortlistController.isFetching.value,
                    fromWhere: ''),
              ),
            ),
            Row(
              children: [
                _image((hiredHistory.employeeDetails?.profilePicture ?? "").imageUrl),
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
                                SizedBox(height: 16.h),
                                Row(
                                  children: [
                                    Flexible(
                                        flex: hiredHistory.employeeDetails!.rating! > 0.0 ? 3 : 4,
                                        child: _name(hiredHistory.employeeDetails?.name ?? "-")),
                                    Expanded(flex: 2, child: _rating(hiredHistory.employeeDetails?.rating ?? 0.0)),
                                    const Expanded(flex: 2, child: Wrap())
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      const Divider(
                        thickness: .5,
                        height: 1,
                        color: MyColors.c_D9D9D9,
                        endIndent: 13,
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          _detailsItem(
                              MyAssets.exp, "", Utils.getPositionName(hiredHistory.employeeDetails?.positionId ?? "")),
                          InkWell(
                              onTap: () =>
                                  controller.onCalenderClick(requestDateList: hiredHistory.requestDateList ?? []),
                              child: Image.asset(MyAssets.calender2, height: 20, width: 20)),
                          SizedBox(width: 8.w)
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          _detailsItem(MyAssets.totalHour, MyStrings.totalHour.tr,
                              (hiredHistory.employeeDetails?.totalWorkingHour ?? 0).toString()),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _image(String profilePicture) => Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 13, 16),
        width: 74.w,
        height: 74.w,
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
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: MyColors.l111111_dwhite(controller.context!).medium14,
      );

  Widget _rating(double rating) => Visibility(
        visible: rating > 0.0,
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

  Widget _detailsItem(String icon, String title, String value) => Expanded(
        child: Row(
          children: [
            Image.asset(
              icon,
              width: 14.w,
              height: 14.w,
            ),
            SizedBox(width: 10.w),
            Text(
              title,
              style: MyColors.l7B7B7B_dtext(controller.context!).medium11,
            ),
            SizedBox(width: 3.w),
            Text(
              value,
              style: MyColors.l111111_dwhite(controller.context!).medium11,
            ),
          ],
        ),
      );
}
