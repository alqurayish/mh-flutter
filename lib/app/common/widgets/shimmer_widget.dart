import 'package:mh/app/common/utils/exports.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget {
  static Widget employeeHomeShimmerWidget() {
    return Shimmer.fromColors(
      baseColor: MyColors.shimmerColor,
      highlightColor: Get.context!.theme.scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15.h),
              Row(
                children: [
                  Expanded(child: _homeCardWidget()),
                  SizedBox(width: 24.w),
                  Expanded(child: _homeCardWidget())
                ],
              ),
              SizedBox(height: 15.h),
              Row(
                children: [
                  Expanded(child: _homeCardWidget()),
                  SizedBox(width: 24.w),
                  Expanded(child: _homeCardWidget())
                ],
              ),
              SizedBox(height: 15.h),
              Row(
                children: [
                  Expanded(child: _homeCardWidget()),
                  SizedBox(width: 24.w),
                  Expanded(child: _homeCardWidget())
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget employeeTodayWorkScheduleShimmerWidget() {
    return Shimmer.fromColors(
        baseColor: MyColors.shimmerColor,
        highlightColor: Get.context!.theme.scaffoldBackgroundColor,
        child: Container(
          margin: EdgeInsets.only(bottom: 15.h),
            height: 160,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: MyColors.shimmerColor)));
  }

  static Widget employeeTodayDashboardShimmerWidget() {
    return Shimmer.fromColors(
        baseColor: MyColors.shimmerColor,
        highlightColor: Get.context!.theme.scaffoldBackgroundColor,
        child: Container(
            height: 160,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: MyColors.shimmerColor)));
  }
}

Widget _homeCardWidget() {
  return Container(
    height: 150,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: MyColors.shimmerColor),
  );
}
