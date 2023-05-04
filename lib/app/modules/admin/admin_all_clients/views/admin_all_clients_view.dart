import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_appbar.dart';
import '../../../../common/widgets/custom_network_image.dart';
import '../../../../common/widgets/no_item_found.dart';
import '../../../../models/employees_by_id.dart';
import '../controllers/admin_all_clients_controller.dart';

class AdminAllClientsView extends GetView<AdminAllClientsController> {
  const AdminAllClientsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;

    return Scaffold(
      appBar: CustomAppbar.appbar(
        title: "Clients",
        context: context,
        centerTitle: true,
      ),
      body: Obx(
        () => (controller.clients.value.users ?? []).isEmpty
            ? controller.isLoading.value
                ? const SizedBox()
                : const NoItemFound()
            : Column(
                children: [
                  _resultCountWithFilter(),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      itemCount: controller.clients.value.users?.length ?? 0,
                      itemBuilder: (context, index) {
                        return _employeeItem(
                          index,
                          controller.clients.value.users![index],
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
            "${controller.clients.value.users?.length ?? 0}",
            style: MyColors.c_C6A34F.semiBold16,
          ),
          Text(
            " Clients are showing",
            style: MyColors.l111111_dwhite(controller.context!).semiBold16,
          ),
        ],
      ),
    );
  }

  Widget _employeeItem(int index, Employee user) {
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
        onTap: () {},
        child: Stack(
          children: [
            // Positioned(
            //   right: 0,
            //   bottom: 0,
            //   child: SizedBox(
            //     width: 122.w,
            //     child: CustomButtons.button(
            //       height: 28.w,
            //       text: "\$${user.hourlyRate ?? 0} / hour",
            //       margin: EdgeInsets.zero,
            //       fontSize: 12,
            //       customButtonStyle: CustomButtonStyle.radiusTopBottomCorner,
            //       onTap: () {},
            //     ),
            //   ),
            // ),

            Positioned(
              right: 10,
              top: 7,
              child: Obx(
                () => GestureDetector(
                  onTap: () => controller.onChatClick(user),
                  child: Icon(
                    Icons.chat,
                    size: 20,
                    color: controller.adminHomeController.unreadFromClient.contains(user.id) ? MyColors.c_C6A34F : MyColors.stock,
                  ),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // _image((user.profilePicture ?? "").imageUrl),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 14).copyWith(
                    top: 16,
                  ),
                  child: Text(
                    (index + 1).toString(),
                    style: MyColors.l111111_dffffff(controller.context!).semiBold18,
                  ),
                ),

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
                                    _name(user.restaurantName ?? ""),
                                    _rating(user.rating ?? 0),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 8.h),

                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              user.restaurantAddress ?? "No address found",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: MyColors.l111111_dwhite(controller.context!).regular14,
                            ),
                          ),
                          const SizedBox(width: 7),
                        ],
                      ),

                      SizedBox(height: 8.h),

                      // Row(
                      //   children: [
                      //     Text("Discount ${user.clientDiscount ?? 0}%"),
                      //   ],
                      // ),
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
    style: MyColors.c_C6A34F.semiBold18,
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
