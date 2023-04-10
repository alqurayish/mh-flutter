import 'package:mh/app/models/requested_employees.dart';

import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_appbar.dart';
import '../../../../common/widgets/custom_network_image.dart';
import '../controllers/client_suggested_employees_controller.dart';

class ClientSuggestedEmployeesView extends GetView<ClientSuggestedEmployeesController> {
  const ClientSuggestedEmployeesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;

    return Scaffold(
      appBar: CustomAppbar.appbar(
        context: context,
        title: 'Requested Employees',
      ),
      body: Obx(
        () => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 22.h),
            ...controller.getUniquePositions().map((e) {
              return _employeeInSamePosition(e);
            }),
          ],
        ),
      ),
    );
  }

  Widget _employeeInSamePosition(ClientRequestDetail e) {
    final List<SuggestedEmployeeDetail> employees = controller.getUniquePositionEmployees(e.positionId!);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 12.h),
          child: Text(
            "${e.positionName} (${employees.length} of ${e.numOfEmployee})",
            style: MyColors.l111111_dwhite(controller.context!).semiBold16,
          ),
        ),

        if(employees.isEmpty)
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 20.h),
            child: const Text("No employee suggest yet"),
          )
        else
        ...employees.map((e) {
          return _employeeItem(e);
        }),
      ],
    );
  }

  Widget _employeeItem(SuggestedEmployeeDetail employee) {
    return Container(
      height: 92.h,
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
      child: Row(
        children: [
          _image((employee.profilePicture ?? "").imageUrl),

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
                              _name(employee.name ?? "-"),
                              _rating(employee.rating ?? 0),
                              const Spacer(),
                              Obx(
                                    () => controller.shortlistController.getIcon(
                                  employee.employeeId!,
                                  controller.shortlistController.isFetching.value,
                                ),
                              ),
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
                    _detailsItem(MyAssets.exp, MyStrings.rate.tr, MyStrings.ratePerHour.trParams({"rate": "\$${(employee.hourlyRate ?? 0)}"})),
                    _detailsItem(MyAssets.totalHour, MyStrings.totalHour.tr, (employee.totalWorkingHour ?? 0).toString()),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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