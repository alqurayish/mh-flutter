import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/hatch_mark.dart';
import 'package:another_xlider/models/hatch_mark_label.dart';
import 'package:another_xlider/models/slider_step.dart';
import 'package:another_xlider/models/tooltip/tooltip.dart';
import 'package:another_xlider/models/tooltip/tooltip_box.dart';
import 'package:another_xlider/models/tooltip/tooltip_position_offset.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:mh/app/common/controller/app_controller.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../utils/exports.dart';
import 'custom_dropdown.dart';

class CustomFilter {
  static customFilter(
    BuildContext context,
    Function(String selectedRating, String selectedExp, String minTotalHour, String maxTotalHour, String positionId,
            String dressSize, String nationality, String height, String hourlyRate)
        onApplyClick,
    Function() onResetClick, {
    bool showPositionId = false,
  }) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        String selectedRating = "";
        String selectedExp = "";
        String minTotalHour = "";
        String maxTotalHour = "";
        String positionId = "";
        String selectedDressSize = "";
        String selectedNationality = "";
        String selectedHeight = "";
        String selectedHourlyRate = "";

        return Container(
          color: MyColors.lightCard(context),
          child: Padding(
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
                _title(context, "Position"),
                SizedBox(height: 4.h),
                Visibility(
                  visible: showPositionId,
                  child: CustomDropdown(
                    prefixIcon: Icons.bookmark,
                    hints: null,
                    value: null,
                    items: (Get.find<AppController>().allActivePositions).map((e) => e.name!).toList(),
                    onChange: (value) {
                      positionId = Get.find<AppController>()
                          .allActivePositions
                          .firstWhere((element) => element.name == value)
                          .id!;
                    },
                    padding: EdgeInsets.symmetric(horizontal: 0.w),
                  ),
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
                  trackBar: _sliderTrackbar(context),
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
                      FlutterSliderHatchMarkLabel(percent: 0, label: _sliderHatchMarkLabel(context, "0")),
                      FlutterSliderHatchMarkLabel(percent: 20, label: _sliderHatchMarkLabel(context, "1")),
                      FlutterSliderHatchMarkLabel(percent: 40, label: _sliderHatchMarkLabel(context, "2")),
                      FlutterSliderHatchMarkLabel(percent: 60, label: _sliderHatchMarkLabel(context, "3")),
                      FlutterSliderHatchMarkLabel(percent: 80, label: _sliderHatchMarkLabel(context, "4")),
                      FlutterSliderHatchMarkLabel(percent: 100, label: _sliderHatchMarkLabel(context, "5")),
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
                    boxStyle: FlutterSliderTooltipBox(
                      decoration: BoxDecoration(
                        color: MyColors.c_C6A34F,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    textStyle: const TextStyle(
                      color: Colors.white,
                    ),
                    positionOffset: FlutterSliderTooltipPositionOffset(top: -10),
                    format: (String value) {
                      int age = int.parse(value.split(".").first);
                      String postfix = age > 0 ? "Years" : "Year";
                      return "$age $postfix";
                    },
                  ),
                  trackBar: _sliderTrackbar(context),
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
                      FlutterSliderHatchMarkLabel(percent: 0, label: _sliderHatchMarkLabel(context, "0")),
                      FlutterSliderHatchMarkLabel(percent: 100, label: _sliderHatchMarkLabel(context, "60")),
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
                    boxStyle: FlutterSliderTooltipBox(
                      decoration: BoxDecoration(
                        color: MyColors.c_C6A34F,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    textStyle: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  trackBar: _sliderTrackbar(context),
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
                      FlutterSliderHatchMarkLabel(percent: 0, label: _sliderHatchMarkLabel(context, "0")),
                      FlutterSliderHatchMarkLabel(percent: 100, label: _sliderHatchMarkLabel(context, "10000")),
                    ],
                  ),
                ),
                SizedBox(height: 27.h),
                _title(context, 'Dress Size'),
                SizedBox(height: 15.h),
                CustomRadioButton(
                  elevation: 0,
                  selectedBorderColor: Colors.transparent,
                  unSelectedBorderColor: Colors.transparent,
                  absoluteZeroSpacing: true,
                  width: 80.w,
                  radius: 5,
                  margin: EdgeInsets.only(right: 10.w),
                  shapeRadius: 5,
                  unSelectedColor: MyColors.c_C6A34F.withOpacity(0.5),
                  buttonLables: const [
                    'S',
                    'M',
                    'L',
                    'XL',
                    'XXL',
                    'XXXL',
                  ],
                  buttonValues: const [
                    'S',
                    'M',
                    'L',
                    'XL',
                    'XXL',
                    'XXXL',
                  ],
                  buttonTextStyle: const ButtonTextStyle(
                      selectedColor: Colors.white, unSelectedColor: Colors.black, textStyle: TextStyle(fontSize: 16)),
                  radioButtonValue: (value) {
                    selectedDressSize = value;
                  },
                  selectedColor: MyColors.c_C6A34F,
                ),
                SizedBox(height: 27.h),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: GestureDetector(
                        onTap: () {
                          onResetClick();
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
                          Get.back();
                          onApplyClick(
                              selectedRating, selectedExp, minTotalHour, maxTotalHour, positionId, selectedDressSize, selectedNationality, selectedHeight, selectedHourlyRate);
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
          ),
        );
      }),
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

  static Widget _sliderHatchMarkLabel(BuildContext context, String text) => Text(
        text,
        style: MyColors.l111111_dwhite(context).regular16_5,
      );

  static FlutterSliderTrackBar _sliderTrackbar(BuildContext context) => FlutterSliderTrackBar(
        inactiveTrackBar: BoxDecoration(
          color: MyColors.darkCard(context),
        ),
        activeTrackBar: const BoxDecoration(
          color: MyColors.c_C6A34F,
        ),
      );
}
