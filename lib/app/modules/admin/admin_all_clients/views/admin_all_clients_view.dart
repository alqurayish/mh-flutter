import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mh/app/common/widgets/shimmer_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_appbar.dart';
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
            ? controller.clientsDataLoading.value
                ? Padding(
                  padding:  EdgeInsets.only(top: 50.h, left: 15.w, right: 15.w),
                  child: ShimmerWidget.clientMyEmployeesShimmerWidget(),
                )
                : const NoItemFound()
            : Column(
                children: [
                  _resultCountWithFilter(),
                  Expanded(
                    child: ListView.builder(
                      controller: controller.scrollController,
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      itemCount: controller.clients.value.users?.length ?? 0,
                      itemBuilder: (context, index) {
                        if(index == controller.clients.value.users!.length -1 && controller.moreDataAvailable.value == true){
                          return const SpinKitThreeBounce(
                            color: MyColors.c_C6A34F,
                            size: 40,
                          );
                        }
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
      padding: EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 0),
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
            //       text: "£${user.hourlyRate ?? 0} / hour",
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
                    color: controller.adminHomeController.chatUserIds.contains(user.id)
                        ? MyColors.c_C6A34F
                        : MyColors.stock,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                    Flexible(flex: user.rating! > 0.0 ? 2 : 7, child: _name(user.restaurantName ?? "")),
                                    Expanded(flex: 2, child: _rating(user.rating ?? 0.0)),
                                    const Expanded(flex: 2, child: Wrap()),
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
                          const CircleAvatar(
                              radius: 11.0,
                              backgroundColor: MyColors.c_C6A34F,
                              child: Icon(Icons.add_road_rounded, size: 15, color: MyColors.c_FFFFFF)),
                          SizedBox(width: 5.w),
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

                      InkResponse(
                        onTap: () => launchUrl(Uri.parse("tel:${user.phoneNumber}")),
                        child: Row(
                          children: [
                            const CircleAvatar(
                                radius: 11.0,
                                backgroundColor: MyColors.c_C6A34F,
                                child: Icon(CupertinoIcons.phone, size: 15, color: MyColors.c_FFFFFF)),
                            SizedBox(width: 5.w),
                            Text(
                              user.phoneNumber ?? " ",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: MyColors.l111111_dwhite(controller.context!).regular14,
                            ),
                          ],
                        ),
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

  Widget _name(String name) => Text(
        name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: MyColors.c_C6A34F.semiBold16,
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
}
