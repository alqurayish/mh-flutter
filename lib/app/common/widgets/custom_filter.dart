import 'package:another_xlider/another_xlider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../utils/exports.dart';

class CustomFilter {
  static customFilter(
    BuildContext context,
    Function(String selectedRating, String selectedExp, String minTotalHour, String maxTotalHour) onApplyClick,
  ) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {

          String selectedRating = "";
          String selectedExp = "";
          String minTotalHour = "";
          String maxTotalHour = "";

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
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

                SizedBox(height: 19.h),

                Row(
                  children: [
                    _divider(context),

                    SizedBox(width: 10.w),

                    Text(
                      MyStrings.filters.tr,
                      style: MyColors.l7B7B7B_dtext(context).semiBold14,
                    ),

                    SizedBox(width: 10.w),

                    _divider(context),
                  ],
                ),

                SizedBox(height: 16.h),

                _title(context, MyStrings.rating.tr),

                FlutterSlider(
                  min: 0,
                  max: 5,
                  values: const [0],
                  selectByTap: false,
                  onDragging: (int handlerIndex, dynamic lowerValue, dynamic upperValue) {
                    selectedRating = lowerValue.toString().split(".").first;
                  },
                  tooltip: FlutterSliderTooltip(
                    disabled: true,
                  ),
                  trackBar: const FlutterSliderTrackBar(
                    inactiveTrackBar: BoxDecoration(
                      color: Colors.black12,
                    ),
                    activeTrackBar: BoxDecoration(
                        color: MyColors.c_C6A34F,
                    ),
                  ),
                  handler: FlutterSliderHandler(
                    decoration: const BoxDecoration(),
                    child: Container(
                        height: 15,
                      width: 15,
                      decoration: const BoxDecoration(
                        color: MyColors.c_C6A34F,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  hatchMark: FlutterSliderHatchMark(
                    density: .05,
                    displayLines: true,
                    linesDistanceFromTrackBar: -5,
                    labelsDistanceFromTrackBar: 40,
                    labels: [
                      FlutterSliderHatchMarkLabel(percent: 0, label: const Text('0')),
                      FlutterSliderHatchMarkLabel(percent: 20, label: const Text('1')),
                      FlutterSliderHatchMarkLabel(percent: 40, label: const Text('2')),
                      FlutterSliderHatchMarkLabel(percent: 60, label: const Text('3')),
                      FlutterSliderHatchMarkLabel(percent: 80, label: const Text('4')),
                      FlutterSliderHatchMarkLabel(percent: 100, label: const Text('5')),
                    ],
                  ),
                ),

                SizedBox(height: 27.h),

                _title(context, MyStrings.experience.tr),

                SizedBox(height: 15.h),

                FlutterSlider(
                  min: 0,
                  max: 60,
                  values: const [0],
                  selectByTap: false,
                  step: const FlutterSliderStep(step: 1),
                  onDragCompleted: (int handlerIndex, dynamic lowerValue, dynamic upperValue) {
                    selectedExp = lowerValue.toString().split(".").first;
                  },
                  tooltip: FlutterSliderTooltip(
                    alwaysShowTooltip: true,
                    positionOffset: FlutterSliderTooltipPositionOffset(top: -10), format: (String value) {
                      int age = int.parse(value.split(".").first);
                      String postfix = age > 0 ? "Years" : "Year";
                      return "$age $postfix";
                    }
                  ),
                  trackBar: const FlutterSliderTrackBar(
                    inactiveTrackBar: BoxDecoration(
                      color: Colors.black12,
                    ),
                    activeTrackBar: BoxDecoration(
                      color: MyColors.c_C6A34F,
                    ),
                  ),
                  handler: FlutterSliderHandler(
                    decoration: const BoxDecoration(),
                    child: Container(
                      height: 15,
                      width: 15,
                      decoration: const BoxDecoration(
                        color: MyColors.c_C6A34F,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  hatchMark: FlutterSliderHatchMark(
                    density: .05,
                    displayLines: true,
                    linesDistanceFromTrackBar: -5,
                    labelsDistanceFromTrackBar: 40,
                    labels: [
                      FlutterSliderHatchMarkLabel(percent: 0, label: const Text('0')),
                      FlutterSliderHatchMarkLabel(percent: 100, label: const Text('60')),
                    ],
                  ),
                ),

                SizedBox(height: 27.h),

                _title(context, MyStrings.totalHour.tr),

                SizedBox(height: 15.h),

                FlutterSlider(
                  min: 0,
                  max: 10000,
                  rangeSlider: true,
                  values: const [0, 10000],
                  selectByTap: false,
                  step: const FlutterSliderStep(step: 1),
                  onDragCompleted: (int handlerIndex, dynamic lowerValue, dynamic upperValue) {
                    minTotalHour = lowerValue.toString().split(".").first;
                    maxTotalHour = upperValue.toString().split(".").first;
                  },
                  tooltip: FlutterSliderTooltip(
                    alwaysShowTooltip: true,
                    positionOffset: FlutterSliderTooltipPositionOffset(top: -10),
                    format: (String value) {
                      return value.split(".").first;
                    },
                  ),
                  trackBar: const FlutterSliderTrackBar(
                    inactiveTrackBar: BoxDecoration(
                      color: Colors.black12,
                    ),
                    activeTrackBar: BoxDecoration(
                      color: MyColors.c_C6A34F,
                    ),
                  ),
                  handler: FlutterSliderHandler(
                    decoration: const BoxDecoration(),
                    child: Container(
                      height: 15,
                      width: 15,
                      decoration: const BoxDecoration(
                        color: MyColors.c_C6A34F,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  rightHandler: FlutterSliderHandler(
                    decoration: const BoxDecoration(),
                    child: Container(
                      height: 15,
                      width: 15,
                      decoration: const BoxDecoration(
                        color: MyColors.c_C6A34F,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  hatchMark: FlutterSliderHatchMark(
                    linesDistanceFromTrackBar: -5,
                    labelsDistanceFromTrackBar: 40,
                    labels: [
                      FlutterSliderHatchMarkLabel(percent: 0, label: const Text('0')),
                      FlutterSliderHatchMarkLabel(percent: 100, label: const Text('10000')),
                    ],
                  ),
                ),

                SizedBox(height: 27.h),

                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: GestureDetector(
                        onTap: () {
                          setState(() { });
                        },
                        child: Text(
                          "Reset Data",
                          style: MyColors.c_FF5029.semiBold16,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: CustomButtons.button(
                        height: 52.h,
                        onTap: () {

                          // close modal
                          Get.back();

                          // callback
                          onApplyClick(selectedRating, selectedExp, minTotalHour, maxTotalHour);

                        },
                        text: "Apply",
                        margin: EdgeInsets.zero,
                        customButtonStyle: CustomButtonStyle.radiusTopBottomCorner,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 11.h),
              ],
            ),
          );
        }
      ),
    );
  }

  static Widget _divider(BuildContext context) => Expanded(
        child: Container(
          height: 1,
          color: MyColors.lD9D9D9_dstock(context),
        ),
      );

  static Widget _title(BuildContext context, String text) => Text(
        text,
        style: MyColors.l111111_dwhite(context).semiBold16,
      );
}
