import '../common/app_info/app_info.dart';
import '../enums/release_mode.dart';
import '../enums/server_url.dart';

class ServerUrls {

  /// image urls
  static String publicImage = _getBaseImageUrl;
  static String profilePicture = "${_getBaseImageUrl}users/profile/";

  static String get _getBaseImageUrl {
    const String prodUrl = "https://mh-user-bucket.s3.amazonaws.com/public/";

    return _url(prodUrl);
  }

  /// server urls
  static String serverUrlUser = '$_getBaseServerUrl$_apiVersion/';

  static String get _getBaseServerUrl {
    const String prodUrl = "https://server.mhpremierstaffingsolutions.com/";

    return _url(prodUrl);
  }

  static String get _getPostUrl {
    const String prodUrl = "";

    return _url(prodUrl);
  }

  static String get _apiVersion {
    return "api/v1";
  }

  /// prod = production
  static String _url(String prod) {
    if(AppInfo.releaseMode == ReleaseMode.release) return prod;

    switch(AppInfo.serverUrl) {
      case ServerUrl.production : return prod;
      case ServerUrl.staging : default: return prod;
    }
  }
}
