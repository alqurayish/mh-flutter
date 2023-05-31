import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'common/app_info/app_info.dart';
import 'common/language/translation.dart';
import 'common/local_storage/storage_helper.dart';
import 'common/style/theme.dart';
import 'common/utils/initializer.dart';
import 'routes/app_pages.dart';

class MirkoHospitality extends StatelessWidget {
  const MirkoHospitality({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return GetMaterialApp(
          title: AppInfo.appName,
          initialRoute: Routes.splash,
          getPages: AppPages.routes,
          initialBinding: InitialBindings(),
          debugShowCheckedModeBanner: false,
          defaultTransition: Transition.rightToLeft,
          translations: Translation(),
          locale: Locale(StorageHelper.getLanguage),
          fallbackLocale: Locale(StorageHelper.getLanguage),
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.system,
        );
      },
    );
  }
}
