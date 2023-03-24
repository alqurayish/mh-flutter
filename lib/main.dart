import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app/common/utils/initializer.dart';
import 'app/mirko_hospitality.dart';

import 'package:device_preview/device_preview.dart';

void main() {
  Initializer.instance.init(() {
    // runApp(DevicePreview(
    //   enabled: !kReleaseMode,
    //   builder: (context) => const MirkoHospitality(),
    // ));
    runApp(const MirkoHospitality());
  });
}


/// ERROR CODE
/// 1000 -> type conversion
/// 1001 -> unknown api error [ApiErrorHandle]
/// 1002 -> location service unavailable
/// 1002 -> location