import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mh/app/common/values/my_color.dart';
import 'package:mh/app/modules/otp/controllers/otp_controller.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpFieldWidget extends GetWidget<OtpController> {
  const OtpFieldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      textStyle: TextStyle(color: context.textTheme.bodyLarge?.color),
      autoFocus: true,
      controller: controller.tecOtp.value,
      appContext: Get.context!,
      enableActiveFill: true,
      cursorColor: MyColors.c_C6A34F,
      keyboardType: TextInputType.number,
      length: 6,
      showCursor: false,
      obscureText: false,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          inactiveFillColor: Colors.transparent,
          selectedFillColor: Colors.transparent,
          activeFillColor: Colors.transparent,
          selectedColor: MyColors.c_C6A34F,
          inactiveColor: MyColors.c_C6A34F.withOpacity(0.3),
          activeColor: Colors.green),
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      onChanged: controller.onPinCodeChange,
      beforeTextPaste: controller.onBeforeTextPaste,
    );
  }
}
