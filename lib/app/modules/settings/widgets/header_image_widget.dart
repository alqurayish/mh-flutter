import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mh/app/common/values/my_assets.dart';

class HeaderImageWidget extends StatelessWidget {
  const HeaderImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Lottie.asset(MyAssets.lottie.changePasswordLottie, height: Get.width * 0.5, width: Get.width * 0.5));
  }
}
