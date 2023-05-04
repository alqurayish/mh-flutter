import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_appbar.dart';
import '../../../../common/widgets/custom_filter.dart';
import '../../../../common/widgets/custom_network_image.dart';
import '../../../../common/widgets/no_item_found.dart';
import '../../../../models/employees_by_id.dart';
import '../controllers/admin_all_employees_controller.dart';

class AdminAllEmployeesView extends GetView<AdminAllEmployeesController> {
  const AdminAllEmployeesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;

    return Scaffold(
      appBar: CustomAppbar.appbar(
          title: "Employees",
          context: context,
          centerTitle: true,
      ),
      body: Obx(
        () => (controller.employees.value.users ?? []).isEmpty
            ? controller.isLoading.value
                ? const SizedBox()
                : Column(
                  children: [
                    _resultCountWithFilter(),
                    const Spacer(),
                    const NoItemFound(),
                    const Spacer(),
                  ],
                )
            : Column(
                children: [
                  _resultCountWithFilter(),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      itemCount: controller.employees.value.users?.length ?? 0,
                      itemBuilder: (context, index) {
                        return _employeeItem(
                          controller.employees.value.users![index],
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _resultCountWithFilter() {
    return Padding(
      padding: EdgeInsets.fromLTRB(23.w, 10.h, 23.w, 0),
      child: Row(
        children: [
          Text(
            "${controller.employees.value.users?.length ?? 0}",
            style: MyColors.c_C6A34F.semiBold16,
          ),
          Text(
            " Employees are showing",
            style: MyColors.l111111_dwhite(controller.context!).semiBold16,
          ),

          const Spacer(),

          GestureDetector(
            onTap: () => CustomFilter.customFilter(
              controller.context!,
              controller.onApplyClick,
              controller.onResetClick,
              showPositionId: true,
            ),
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: MyColors.c_DDBD68,
              ),
              child: const Icon(Icons.filter_list_rounded, color: Colors.white,),
            ),
          ),
        ],
      ),
    );
  }

  Widget _employeeItem(Employee user) {
    return Container(
      height: 105.h,
      margin: EdgeInsets.symmetric(horizontal: 24.w).copyWith(
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
        onTap: () => controller.onEmployeeClick(user),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              bottom: 0,
              child: SizedBox(
                width: 122.w,
                child: CustomButtons.button(
                  height: 28.w,
                  text: "\$${user.hourlyRate ?? 0} / hour",
                  margin: EdgeInsets.zero,
                  fontSize: 12,
                  customButtonStyle: CustomButtonStyle.radiusTopBottomCorner,
                  onTap: () {},
                ),
              ),
            ),

            Positioned(
              right: 7,
              top: 4,
              child: Obx(
                () => GestureDetector(
                  onTap: () => controller.onChatClick(user),
                  child: Icon(
                    Icons.chat,
                    size: 20,
                    color: controller.adminHomeController.unreadFromEmployee.contains(user.id) ? MyColors.c_C6A34F : MyColors.stock,
                  ),
                ),
              ),
            ),

            Row(
              children: [
                _image((user.profilePicture ?? "").imageUrl),

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
                                    Expanded(child: _name("${user.firstName ?? "-"} ${user.lastName ?? ""}")),
                                    _rating(user.rating ?? 0),
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
                          _detailsItem(controller.getPositionLogo(user.positionId!), user.positionName ?? "", ""),
                          _activeStatus(user.isHired ?? false),
                          const SizedBox(width: 7),
                        ],
                      ),

                      SizedBox(height: 8.h),

                      Row(
                        children: [
                          _detailsItem(MyAssets.totalHour, MyStrings.totalHour.tr, (user.totalWorkingHour ?? 0).toString()),
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

  Widget _activeStatus(bool isHired) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: isHired ? MyColors.c_00C92C_10 : MyColors.c_FF5029_10,
        ),
        child: Row(
          children: [
            Container(
              height: 11,
              width: 11,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isHired ? MyColors.c_00C92C : MyColors.c_FF5029,
              ),
            ),

            const SizedBox(width: 5),

            Text(
              isHired ? "Hired" : "Available",
              style: MyColors.l111111_dwhite(controller.context!).medium10,
            ),
          ],
        ),
      );
}
