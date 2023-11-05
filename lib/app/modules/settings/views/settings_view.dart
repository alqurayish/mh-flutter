import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mh/app/common/values/my_assets.dart';
import 'package:mh/app/common/widgets/custom_appbar.dart';
import 'package:mh/app/modules/settings/widgets/button_widget.dart';
import 'package:mh/app/modules/settings/widgets/current_password_field_widget.dart';
import 'package:mh/app/modules/settings/widgets/header_image_widget.dart';
import 'package:mh/app/modules/settings/widgets/new_password_field_widget.dart';
import 'package:mh/app/modules/settings/widgets/welcome_back_text_widget.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar.appbar(title: "Settings", context: context),
      body: const SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            HeaderImageWidget(),
            WelcomeBackTextWidget(),
            SizedBox(height: 50),
            CurrentPasswordFieldWidget(),
            SizedBox(height: 20),
            NewPasswordFieldWidget(),
            SizedBox(height: 50),
            ButtonWidget()

          ],
        ),
      ),
    );
  }
}
