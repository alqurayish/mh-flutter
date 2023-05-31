import '../../enums/release_mode.dart';
import '../../enums/server_url.dart';

class AppInfo {
  AppInfo._();

  static const String appName = "Mirco Hospitality";

  static const String version = "1.0.8";

  /// it must change [releaseMode] when release
  static const ReleaseMode releaseMode = ReleaseMode.release;

  /// change [serverUrl] based on testing
  static const ServerUrl serverUrl = ServerUrl.production;
}
