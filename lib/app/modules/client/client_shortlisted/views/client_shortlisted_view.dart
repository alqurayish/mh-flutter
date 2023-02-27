import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_appbar.dart';
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
      body: Column(
        children: [
          ...controller.shortlistController.getUniquePositions().map((e) {
            return _employeeInSamePosition(e);
          }),
        ],
      ),
    );
  }

  Widget _employeeInSamePosition(String positionId) {
    return Column(
      children: [
        Text(
          Utils.getPositionName(positionId),
          style: MyColors.l111111_dwhite(controller.context!).semiBold16,
        ),

        // ...controller.shortlistController.getEmployeesBasedOnPosition(positionId).map((e) {
        //   return _employeeItem(e);
        // }),
      ],
    );
  }

  Widget _employeeItem(ShortList employee) {
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
          _image(),

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
                              _name("Khalid Hassan"),
                              _rating(4),
                              // _name(employee ?? "-"),
                              // _rating(user.rating ?? 0),
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

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _image() => Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 13, 16),
        width: 74.w,
        height: 74.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.grey.withOpacity(.1),
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
}
