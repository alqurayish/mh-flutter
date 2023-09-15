import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:mh/app/modules/calender/models/calender_model.dart';
import 'package:mh/app/modules/calender/models/update_unavailable_date_request_model.dart';
import 'package:mh/app/modules/client/client_shortlisted/models/add_to_shortlist_request_model.dart';
import 'package:mh/app/modules/client/client_shortlisted/models/update_shortlist_request_model.dart';
import 'package:mh/app/modules/client/client_suggested_employees/models/short_list_request_model.dart';
import 'package:mh/app/modules/employee/employee_home/models/common_response_model.dart';
import 'package:mh/app/modules/employee/employee_home/models/employee_check_in_request_model.dart';
import 'package:mh/app/modules/employee/employee_home/models/employee_check_out_request_model.dart';
import 'package:mh/app/modules/employee/employee_home/models/employee_hired_history_model.dart';
import 'package:mh/app/modules/employee/employee_home/models/review_dialog_model.dart';
import 'package:mh/app/modules/employee/employee_home/models/review_request_model.dart';
import 'package:mh/app/modules/employee/employee_home/models/booking_history_model.dart';
import 'package:mh/app/modules/employee/employee_home/models/single_booking_details_model.dart';
import 'package:mh/app/modules/employee/employee_home/models/todays_work_schedule_model.dart';
import 'package:mh/app/modules/employee/employee_payment_history/models/employee_payment_history_model.dart';
import 'package:mh/app/modules/notifications/models/notification_response_model.dart';
import 'package:mh/app/modules/notifications/models/notification_update_request_model.dart';
import 'package:mh/app/modules/notifications/models/notification_update_response_model.dart';
import 'package:mh/app/modules/stripe_payment/models/stripe_request_model.dart';
import 'package:mh/app/modules/stripe_payment/models/stripe_response_model.dart';
import 'package:mh/app/repository/server_urls.dart';

import '../common/controller/app_error_controller.dart';
import '../common/local_storage/storage_helper.dart';
import '../common/utils/exports.dart';
import '../common/utils/type_def.dart';
import '../enums/error_from.dart';
import '../models/all_admins.dart';
import '../models/check_in_out_histories.dart';
import '../models/commons.dart';
import '../models/custom_error.dart';
import '../models/employee_full_details.dart';
import '../models/employees_by_id.dart';
import '../models/lat_long_to_address.dart';
import '../models/one_to_one_msg.dart';
import '../models/requested_employees.dart' as requested_employees;
import '../models/sources.dart';
import '../models/user_info.dart';
import '../modules/auth/login/model/login.dart';
import '../modules/auth/login/model/login_response.dart';
import '../modules/auth/register/models/client_register.dart';
import '../modules/auth/register/models/client_register_response.dart';
import '../modules/auth/register/models/employee_registration.dart';
import '../modules/client/client_dashboard/models/current_hired_employees.dart';
import '../modules/client/client_payment_and_invoice/model/client_invoice_model.dart';
import '../modules/client/client_self_profile/model/client_profile_update.dart';
import '../modules/client/client_shortlisted/models/shortlisted_employees.dart' as short_list_employees;
import '../modules/client/client_terms_condition_for_hire/models/terms_condition_for_hire.dart';
import '../modules/employee/employee_home/models/today_check_in_out_details.dart';
import 'api_error_handel.dart';
import 'api_helper.dart';

class ApiHelperImpl extends GetConnect implements ApiHelper {
  @override
  void onInit() {
    httpClient.baseUrl = ServerUrls.serverLiveUrlUser;
    httpClient.timeout = const Duration(seconds: 120);

    httpClient.addRequestModifier<dynamic>((Request request) {
      Logcat.msg(request.url.toString());
      if (StorageHelper.hasToken) {
        Logcat.msg("Token Attached");
        request.headers['Authorization'] = "Bearer ${StorageHelper.getToken}";
      }
      return request;
    });
  }

  /// basically we need to convert [Response] to model
  /// that's why [Response] must contains a body of Map type
  /// if [Response] is null that means their is NO INTERNET CONNECTION
  ///
  /// [Response] will be null or
  /// [Response] data or type will not match with model field
  /// so we must verify [Response] data is correct format
  ///
  /// way to check correct data t
  ///  1. check null for no internet
  ///  2. check status code is valid or not
  ///  3. finally convert response to model
  Either<CustomError, T> _convert<T>(
    Response? response,
    Function(Map<String, dynamic>) base, {
    bool onlyErrorCheck = false,
  }) {
    try {
      if ((response?.statusText ?? "").contains("SocketException")) {
        AppErrorController.submitAutomaticError(
          errorName: "From: api_helper_imp.dart > _convert",
          description: """
              response: $response
              statusCode: ${response?.statusCode}
              responseStatusText: ${response?.statusText}
            """,
        );

        return left(CustomError(
          errorCode: response?.statusCode ?? 500,
          errorFrom: ErrorFrom.noInternet,
          msg: "No internet connection",
        ));
      } else if (response == null || response.statusCode == null) {
        AppErrorController.submitAutomaticError(
          errorName: "From: api_helper_imp.dart > _convert",
          description: """
              response: $response
              statusCode: ${response?.statusCode}
              responseStatusText: ${response?.statusText}
            """,
        );

        return left(CustomError(
          errorCode: response?.statusCode ?? 500,
          errorFrom: ErrorFrom.server,
          msg: "Server Error",
        ));
      }

      Either<CustomError, Response> hasError = ApiErrorHandle.checkError(response);

      if (hasError.isLeft()) {
        AppErrorController.submitAutomaticError(
          errorName: "From: api_helper_imp.dart > _convert > custom error",
          description: """
              errorCode: ${hasError.asLeft.errorCode}
              errorName: ${hasError.asLeft.errorFrom.name}
              errorMsg: ${hasError.asLeft.msg}
            """,
        );

        return left(hasError.asLeft);
      }

      if (onlyErrorCheck) return right(response as T);

      return right(base(response.body) as T);
    } catch (e, s) {
      Logcat.msg(e.toString());
      Logcat.stack(s);

      AppErrorController.submitAutomaticError(
        errorName: "From: api_helper_imp.dart > _convert > type conversion",
        description: """
              errorCode: 1000
              error: ${e.toString()}
              stack: ${s.toString()}
            """,
      );

      return left(
        CustomError(
          errorCode: 1000,
          errorFrom: ErrorFrom.typeConversion,
          msg: e.toString(),
        ),
      );
    }
  }

  @override
  EitherModel<Commons> commons() async {
    var response = await get("commons");

    if (response.statusCode == null) response = await get("commons");
    if (response.statusCode == null) response = await get("commons");
    if (response.statusCode == null) response = await get("commons");

    return _convert<Commons>(
      response,
      Commons.fromJson,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<LoginResponse> login(
    Login login,
  ) async {
    var response = await post("users/login", jsonEncode(login.toJson));

    if (response.statusCode == null) response = await post("users/login", jsonEncode(login.toJson));
    if (response.statusCode == null) response = await post("users/login", jsonEncode(login.toJson));
    if (response.statusCode == null) response = await post("users/login", jsonEncode(login.toJson));

    return _convert<LoginResponse>(
      response,
      LoginResponse.fromJson,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<ClientRegistrationResponse> clientRegister(
    ClientRegistration clientRegistration,
  ) async {
    var response = await post("users/client-register", jsonEncode(clientRegistration.toJson));
    if (response.statusCode == null) await post("users/client-register", jsonEncode(clientRegistration.toJson));
    if (response.statusCode == null) await post("users/client-register", jsonEncode(clientRegistration.toJson));
    if (response.statusCode == null) await post("users/client-register", jsonEncode(clientRegistration.toJson));

    return _convert<ClientRegistrationResponse>(
      response,
      ClientRegistrationResponse.fromJson,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<ClientRegistrationResponse> employeeRegister(EmployeeRegistration employeeRegistration) async {
    var response = await post("users/employee-register", jsonEncode(employeeRegistration.toJson));
    if (response.statusCode == null) {
      response = await post("users/employee-register", jsonEncode(employeeRegistration.toJson));
    }
    if (response.statusCode == null) {
      response = await post("users/employee-register", jsonEncode(employeeRegistration.toJson));
    }
    if (response.statusCode == null) {
      response = await post("users/employee-register", jsonEncode(employeeRegistration.toJson));
    }

    return _convert<ClientRegistrationResponse>(
      response,
      ClientRegistrationResponse.fromJson,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<Response> updateFcmToken({bool isLogin = true}) async {
    String? token;
    String? deviceIdentifier;

    if (isLogin) {
      await FirebaseMessaging.instance.getToken().then((fcmToken) async {
        token = fcmToken;
      });
    }

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo build = await deviceInfo.androidInfo;
      deviceIdentifier = build.id; //UUID for Android
    } else if (Platform.isIOS) {
      IosDeviceInfo data = await deviceInfo.iosInfo;
      deviceIdentifier = data.identifierForVendor; //UUID for iOS
    }

    if (!isLogin || !StorageHelper.hasToken) {
      token = null;
    }

    Map<String, dynamic> data = {
      "uuid": deviceIdentifier ?? "",
      "fcmToken": token ?? "",
      "platform": Platform.isAndroid ? "android" : "ios"
    };

    var response = await put("users/push-notification-update", jsonEncode(data));
    if (response.statusCode == null) response = await put("users/push-notification-update", jsonEncode(data));
    if (response.statusCode == null) response = await put("users/push-notification-update", jsonEncode(data));
    if (response.statusCode == null) response = await put("users/push-notification-update", jsonEncode(data));

    return _convert<Response>(
      response,
      (Map<String, dynamic> data) {},
      onlyErrorCheck: true,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<UserInfo> clientDetails(
    String id,
  ) async {
    String url = "users/$id";
    var response = await get(url);
    if (response.statusCode == null) response = await get("users/$id");
    if (response.statusCode == null) response = await get("users/$id");
    if (response.statusCode == null) response = await get("users/$id");

    return _convert<UserInfo>(
      response,
      UserInfo.fromJson,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<Employees> getEmployees({
    String? positionId,
    String? rating,
    String? employeeExperience,
    String? minTotalHour,
    String? maxTotalHour,
    bool? isReferred,
  }) async {
    String url = "users/list?";

    if ((positionId ?? "").isNotEmpty) url += "positionId=$positionId";
    if ((rating ?? "").isNotEmpty) url += "&rating=$rating";
    if ((employeeExperience ?? "").isNotEmpty) url += "&employeeExperience=$employeeExperience";
    if ((minTotalHour ?? "").isNotEmpty) url += "&minTotalHour=$minTotalHour";
    if ((maxTotalHour ?? "").isNotEmpty) url += "&maxTotalHour=$maxTotalHour";
    if (isReferred ?? false) url += "&isReferPerson=${isReferred!.toApiFormat}";
    var response = await get(url);
    if (response.statusCode == null) response = await get(url);
    if (response.statusCode == null) response = await get(url);
    if (response.statusCode == null) response = await get(url);

    return _convert<Employees>(
      response,
      Employees.fromJson,
    ).fold((CustomError l) => left(l), (Employees r) => right(r));
  }

  @override
  EitherModel<Employees> getAllUsersFromAdmin(
      {String? positionId,
      String? rating,
      String? employeeExperience,
      String? minTotalHour,
      String? maxTotalHour,
      bool? isReferred,
      String? requestType,
      bool? active,
      required int currentPage}) async {
    String url = "users?page=$currentPage&limit=10&requestType=$requestType";

    if ((positionId ?? "").isNotEmpty) url += "&positionId=$positionId";
    if ((rating ?? "").isNotEmpty) url += "&rating=$rating";
    if ((employeeExperience ?? "").isNotEmpty) url += "&employeeExperience=$employeeExperience";
    if ((minTotalHour ?? "").isNotEmpty) url += "&minTotalHour=$minTotalHour";
    if ((maxTotalHour ?? "").isNotEmpty) url += "&maxTotalHour=$maxTotalHour";
    if (isReferred ?? false) url += "&isReferPerson=${isReferred!.toApiFormat}";
    if (active ?? false) url += "&active=${active!.toApiFormat}";

    var response = await get(url);
    if (response.statusCode == null) response = await get(url);
    if (response.statusCode == null) response = await get(url);
    if (response.statusCode == null) response = await get(url);

    return _convert<Employees>(
      response,
      Employees.fromJson,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<AllAdmins> getAllAdmins() async {
    String url = "users/mh-employee-list?requestType=ADMIN&skipLimit=YES";
    var response = await get(url);
    if (response.statusCode == null) response = await get(url);
    if (response.statusCode == null) response = await get(url);
    if (response.statusCode == null) response = await get(url);

    return _convert<AllAdmins>(
      response,
      AllAdmins.fromJson,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<TermsConditionForHire> getTermsConditionForHire() async {
    var response = await get("terms-conditions");
    if (response.statusCode == null) response = await get("terms-conditions");
    if (response.statusCode == null) response = await get("terms-conditions");
    if (response.statusCode == null) response = await get("terms-conditions");

    return _convert<TermsConditionForHire>(
      response,
      TermsConditionForHire.fromJson,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<short_list_employees.ShortlistedEmployees> fetchShortlistEmployees() async {
    var response = await get("short-list");
    if (response.statusCode == null) response = await get("short-list");
    if (response.statusCode == null) response = await get("short-list");
    if (response.statusCode == null) response = await get("short-list");

    return _convert<short_list_employees.ShortlistedEmployees>(
      response,
      short_list_employees.ShortlistedEmployees.fromJson,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<Response> addToShortlist({required AddToShortListRequestModel addToShortListRequestModel}) async {
    Response response = await post("short-list/create", jsonEncode(addToShortListRequestModel.toJson()));
    if (response.statusCode == null) {
      response = await post("short-list/create", jsonEncode(addToShortListRequestModel.toJson()));
    }
    if (response.statusCode == null) {
      response = await post("short-list/create", jsonEncode(addToShortListRequestModel.toJson()));
    }
    if (response.statusCode == null) {
      response = await post("short-list/create", jsonEncode(addToShortListRequestModel.toJson()));
    }
    return _convert<Response>(
      response,
      (Map<String, dynamic> data) {},
      onlyErrorCheck: true,
    ).fold((CustomError l) => left(l), (Response r) => right(r));
  }

  @override
  EitherModel<Sources> fetchSources() async {
    var response = await get("sources/list-for-dropdown");
    if (response.statusCode == null) response = await get("sources/list-for-dropdown");
    if (response.statusCode == null) response = await get("sources/list-for-dropdown");
    if (response.statusCode == null) response = await get("sources/list-for-dropdown");

    return _convert<Sources>(
      response,
      Sources.fromJson,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<Response> updateShortlistItem({required UpdateShortListRequestModel updateShortListRequestModel}) async {
    Response response = await put("short-list/update", jsonEncode(updateShortListRequestModel.toJson()));
    if (response.statusCode == null) {
      response = await put("short-list/update", jsonEncode(updateShortListRequestModel.toJson()));
    }
    if (response.statusCode == null) {
      response = await put("short-list/update", jsonEncode(updateShortListRequestModel.toJson()));
    }
    if (response.statusCode == null) {
      response = await put("short-list/update", jsonEncode(updateShortListRequestModel.toJson()));
    }

    return _convert<Response>(
      response,
      (Map<String, dynamic> data) {},
      onlyErrorCheck: true,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<Response> deleteFromShortlist(String shortlistId) async {
    var response = await delete("short-list/delete/$shortlistId");
    if (response.statusCode == null) response = await delete("short-list/delete/$shortlistId");
    if (response.statusCode == null) response = await delete("short-list/delete/$shortlistId");
    if (response.statusCode == null) response = await delete("short-list/delete/$shortlistId");

    return _convert<Response>(
      response,
      (Map<String, dynamic> data) {},
      onlyErrorCheck: true,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<Response> hireConfirm(Map<String, dynamic> data) async {
    var response = await post("hired-histories/create", jsonEncode(data));
    if (response.statusCode == null) response = await post("hired-histories/create", jsonEncode(data));
    if (response.statusCode == null) response = await post("hired-histories/create", jsonEncode(data));
    if (response.statusCode == null) response = await post("hired-histories/create", jsonEncode(data));

    return _convert<Response>(
      response,
      (Map<String, dynamic> data) {},
      onlyErrorCheck: true,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<Response> addressToLatLng(String query) async {
    httpClient.baseUrl = "https://nominatim.openstreetmap.org/";
    var response = await get("search?q=$query&format=jsonv2");
    if (response.statusCode == null) response = await get("search?q=$query&format=jsonv2");
    if (response.statusCode == null) response = await get("search?q=$query&format=jsonv2");
    if (response.statusCode == null) response = await get("search?q=$query&format=jsonv2");
    httpClient.baseUrl = ServerUrls.serverLiveUrlUser;

    return _convert<Response>(
      response,
      (Map<String, dynamic> data) {},
      onlyErrorCheck: true,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<LatLngToAddress> latLngToAddress(double lat, double lng) async {
    httpClient.baseUrl = "https://nominatim.openstreetmap.org/";
    var response = await get("reverse?lat=$lat&lon=$lng&format=jsonv2");
    if (response.statusCode == null) response = await get("reverse?lat=$lat&lon=$lng&format=jsonv2");
    if (response.statusCode == null) response = await get("reverse?lat=$lat&lon=$lng&format=jsonv2");
    if (response.statusCode == null) response = await get("reverse?lat=$lat&lon=$lng&format=jsonv2");
    httpClient.baseUrl = ServerUrls.serverLiveUrlUser;

    return _convert<LatLngToAddress>(
      response,
      LatLngToAddress.fromJson,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  Future<void> submitAppError(Map<String, String> data) async {
    var response = await post("app-errors/create", jsonEncode(data));
    if (response.statusCode == null) response = await post("app-errors/create", jsonEncode(data));
  }

  @override
  EitherModel<TodayCheckInOutDetails> dailyCheckInCheckoutDetails(String employeeId) async {
    var response = await get("current-hired-employees/details/$employeeId");
    if (response.statusCode == null) response = await get("current-hired-employees/details/$employeeId");
    if (response.statusCode == null) response = await get("current-hired-employees/details/$employeeId");
    if (response.statusCode == null) response = await get("current-hired-employees/details/$employeeId");

    return _convert<TodayCheckInOutDetails>(
      response,
      TodayCheckInOutDetails.fromJson,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<CommonResponseModel> checkIn({required EmployeeCheckInRequestModel employeeCheckInRequestModel}) async {
    Response response = await post("current-hired-employees/create", jsonEncode(employeeCheckInRequestModel.toJson()));

    if (response.statusCode == null) {
      response = await post("current-hired-employees/create", jsonEncode(employeeCheckInRequestModel.toJson()));
    }
    if (response.statusCode == null) {
      response = await post("current-hired-employees/create", jsonEncode(employeeCheckInRequestModel.toJson()));
    }
    if (response.statusCode == null) {
      response = await post("current-hired-employees/create", jsonEncode(employeeCheckInRequestModel.toJson()));
    }

    return _convert<CommonResponseModel>(
      response,
      CommonResponseModel.fromJson,
    ).fold((CustomError l) => left(l), (CommonResponseModel r) => right(r));
  }

  @override
  EitherModel<Response> checkout({required EmployeeCheckOutRequestModel employeeCheckOutRequestModel}) async {
    var response = await put("current-hired-employees/update", jsonEncode(employeeCheckOutRequestModel.toJson()));
    if (response.statusCode == null) {
      response = await put("current-hired-employees/update", jsonEncode(employeeCheckOutRequestModel.toJson()));
    }
    if (response.statusCode == null) {
      response = await put("current-hired-employees/update", jsonEncode(employeeCheckOutRequestModel.toJson()));
    }
    if (response.statusCode == null) {
      response = await put("current-hired-employees/update", jsonEncode(employeeCheckOutRequestModel.toJson()));
    }

    return _convert<Response>(
      response,
      (Map<String, dynamic> data) {},
      onlyErrorCheck: true,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<Response> updateCheckInOutByClient(Map<String, dynamic> data) async {
    var response = await put("current-hired-employees/update-status", jsonEncode(data));
    if (response.statusCode == null) response = await put("current-hired-employees/update-status", jsonEncode(data));
    if (response.statusCode == null) response = await put("current-hired-employees/update-status", jsonEncode(data));
    if (response.statusCode == null) response = await put("current-hired-employees/update-status", jsonEncode(data));

    return _convert<Response>(
      response,
      (Map<String, dynamic> data) {},
      onlyErrorCheck: true,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<Response> deleteAccount(Map<String, dynamic> data) async {
    var response = await put("users/update-status", jsonEncode(data));
    if (response.statusCode == null) response = await put("users/update-status", jsonEncode(data));
    if (response.statusCode == null) response = await put("users/update-status", jsonEncode(data));
    if (response.statusCode == null) response = await put("users/update-status", jsonEncode(data));

    return _convert<Response>(
      response,
      (Map<String, dynamic> data) {},
      onlyErrorCheck: true,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<HiredEmployeesByDate> getHiredEmployeesByDate({String? date}) async {
    String url = "hired-histories/employee-list-for-client";

    if (date != null) url += "?filterDate=$date&utc=${DateTime.now().timeZoneOffset.inHours}";

    var response = await get(url);
    if (response.statusCode == null) response = await get(url);
    if (response.statusCode == null) response = await get(url);
    if (response.statusCode == null) response = await get(url);

    return _convert<HiredEmployeesByDate>(
      response,
      HiredEmployeesByDate.fromJson,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<TodayCheckInOutDetails> getTodayCheckInOutDetails(String employeeId) async {
    var response = await get("current-hired-employees/details/$employeeId");
    if (response.statusCode == null) response = await get("current-hired-employees/details/$employeeId");
    if (response.statusCode == null) response = await get("current-hired-employees/details/$employeeId");
    if (response.statusCode == null) response = await get("current-hired-employees/details/$employeeId");
    return _convert<TodayCheckInOutDetails>(
      response,
      TodayCheckInOutDetails.fromJson,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<CheckInCheckOutHistory> getCheckInOutHistory({
    String? filterDate,
    String? requestType,
    String? clientId,
    String? employeeId,
  }) async {
    String url = "check-in-check-out-histories?utc=${DateTime.now().timeZoneOffset.inHours}";

    if ((filterDate ?? "").isNotEmpty) url += "&filterDate=$filterDate";
    if ((requestType ?? "").isNotEmpty) url += "&requestType=$requestType";
    if ((clientId ?? "").isNotEmpty) url += "&clientId=$clientId";
    if ((employeeId ?? "").isNotEmpty) url += "&employeeId=$employeeId";

    Response response = await get(url);
    if (response.statusCode == null) response = await get(url);
    if (response.statusCode == null) response = await get(url);
    if (response.statusCode == null) response = await get(url);
    return _convert<CheckInCheckOutHistory>(
      response,
      CheckInCheckOutHistory.fromJson,
    ).fold((CustomError l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<CheckInCheckOutHistory> getEmployeeCheckInOutHistory() async {
    var response = await get("check-in-check-out-histories/list");
    if (response.statusCode == null) response = await get("check-in-check-out-histories/list");
    if (response.statusCode == null) response = await get("check-in-check-out-histories/list");
    if (response.statusCode == null) response = await get("check-in-check-out-histories/list");
    return _convert<CheckInCheckOutHistory>(
      response,
      CheckInCheckOutHistory.fromJson,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<Response> clientRequestForEmployee(Map<String, dynamic> data) async {
    var response = await post("request-employees/create", jsonEncode(data));
    if (response.statusCode == null) response = await put("request-employees/create", jsonEncode(data));
    if (response.statusCode == null) response = await put("request-employees/create", jsonEncode(data));
    if (response.statusCode == null) response = await put("request-employees/create", jsonEncode(data));

    return _convert<Response>(
      response,
      (Map<String, dynamic> data) {},
      onlyErrorCheck: true,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<requested_employees.RequestedEmployees> getRequestedEmployees({String? clientId}) async {
    String url = "request-employees?";

    if ((clientId ?? "").isNotEmpty) url += "clientId=$clientId";

    Response response = await get(url);
    if (response.statusCode == null) response = await get(url);
    if (response.statusCode == null) response = await get(url);
    if (response.statusCode == null) response = await get(url);

    return _convert<requested_employees.RequestedEmployees>(
      response,
      requested_employees.RequestedEmployees.fromJson,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<Response> addEmployeeAsSuggest(Map<String, dynamic> data) async {
    var response = await put("request-employees/update", jsonEncode(data));
    if (response.statusCode == null) response = await put("request-employees/update", jsonEncode(data));
    if (response.statusCode == null) response = await put("request-employees/update", jsonEncode(data));
    if (response.statusCode == null) response = await put("request-employees/update", jsonEncode(data));

    return _convert<Response>(
      response,
      (Map<String, dynamic> data) {},
      onlyErrorCheck: true,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<OneToOneMsg> getMsg(String senderId, String receiverId) async {
    var response = await get("messages?receiverId=$receiverId&senderId=$senderId");
    if (response.statusCode == null) response = await get("messages?receiverId=$receiverId&senderId=$senderId");
    if (response.statusCode == null) response = await get("messages?receiverId=$receiverId&senderId=$senderId");
    if (response.statusCode == null) response = await get("messages?receiverId=$receiverId&senderId=$senderId");

    return _convert<OneToOneMsg>(
      response,
      OneToOneMsg.fromJson,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<Response> sendMsg(Map<String, dynamic> data) async {
    var response = await post("messages/create", jsonEncode(data));
    if (response.statusCode == null) response = await put("messages/create", jsonEncode(data));
    if (response.statusCode == null) response = await put("messages/create", jsonEncode(data));
    if (response.statusCode == null) response = await put("messages/create", jsonEncode(data));

    return _convert<Response>(
      response,
      (Map<String, dynamic> data) {},
      onlyErrorCheck: true,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<EmployeeFullDetails> employeeFullDetails(String id) async {
    String url = "users/$id";

    var response = await get(url);
    if (response.statusCode == null) response = await get(url);
    if (response.statusCode == null) response = await get(url);
    if (response.statusCode == null) response = await get(url);

    return _convert<EmployeeFullDetails>(
      response,
      EmployeeFullDetails.fromJson,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<ClientRegistrationResponse> updateClientProfile(ClientProfileUpdate clientProfileUpdate) async {
    var response = await put("users/update-client", jsonEncode(clientProfileUpdate.toJson));
    if (response.statusCode == null) {
      response = await put("users/update-client", jsonEncode(clientProfileUpdate.toJson));
    }
    if (response.statusCode == null) {
      response = await put("users/update-client", jsonEncode(clientProfileUpdate.toJson));
    }
    if (response.statusCode == null) {
      response = await put("users/update-client", jsonEncode(clientProfileUpdate.toJson));
    }

    return _convert<ClientRegistrationResponse>(
      response,
      ClientRegistrationResponse.fromJson,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<ClientInvoiceModel> getClientInvoice(String clientId) async {
    String url = "invoices?clientId=$clientId";

    var response = await get(url);
    if (response.statusCode == null) response = await get(url);
    if (response.statusCode == null) response = await get(url);
    if (response.statusCode == null) response = await get(url);

    return _convert<ClientInvoiceModel>(
      response,
      ClientInvoiceModel.fromJson,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<Response> updatePaymentStatus(Map<String, dynamic> data) async {
    var response = await put("invoices/update-status", jsonEncode(data));
    if (response.statusCode == null) response = await put("invoices/update-status", jsonEncode(data));
    if (response.statusCode == null) response = await put("invoices/update-status", jsonEncode(data));
    if (response.statusCode == null) response = await put("invoices/update-status", jsonEncode(data));

    return _convert<Response>(
      response,
      (Map<String, dynamic> data) {},
      onlyErrorCheck: true,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<NotificationResponseModel> getNotifications() async {
    String url = "notifications/list";

    Response response = await get(url);
    if (response.statusCode == null) {
      response = await get(url);
    }
    if (response.statusCode == null) {
      response = await get(url);
    }
    if (response.statusCode == null) {
      response = await get(url);
    }
    return _convert<NotificationResponseModel>(
      response,
      NotificationResponseModel.fromJson,
    ).fold((CustomError l) => left(l), (NotificationResponseModel r) => right(r));
  }

  @override
  EitherModel<NotificationUpdateResponseModel> updateNotification(
      {required NotificationUpdateRequestModel notificationUpdateRequestModel}) async {
    Response response = await put("notifications/update-status", jsonEncode(notificationUpdateRequestModel.toJson()));
    if (response.statusCode == null) {
      response = await put("notifications/update-status", jsonEncode(notificationUpdateRequestModel.toJson()));
    }
    if (response.statusCode == null) {
      response = await put("notifications/update-status", jsonEncode(notificationUpdateRequestModel.toJson()));
    }
    if (response.statusCode == null) {
      response = await put("notifications/update-status", jsonEncode(notificationUpdateRequestModel.toJson()));
    }
    return _convert<NotificationUpdateResponseModel>(
      response,
      NotificationUpdateResponseModel.fromJson,
    ).fold((CustomError l) => left(l), (NotificationUpdateResponseModel r) => right(r));
  }

  @override
  EitherModel<BookingHistoryModel> getBookingHistory() async {
    String url = "notifications/details";

    Response response = await get(url);
    if (response.statusCode == null) {
      response = await get(url);
    }
    if (response.statusCode == null) {
      response = await get(url);
    }
    if (response.statusCode == null) {
      response = await get(url);
    }
    return _convert<BookingHistoryModel>(
      response,
      BookingHistoryModel.fromJson,
    ).fold((CustomError l) => left(l), (BookingHistoryModel r) => right(r));
  }

  @override
  EitherModel<BookingHistoryModel> cancelClientRequestFromAdmin({required String requestId}) async {
    String url = "request-employees/remove/$requestId";

    var response = await delete(url);
    if (response.statusCode == null) response = await delete(url);
    if (response.statusCode == null) response = await delete(url);
    if (response.statusCode == null) response = await delete(url);

    return _convert<BookingHistoryModel>(
      response,
      BookingHistoryModel.fromJson,
    ).fold((CustomError l) => left(l), (BookingHistoryModel r) => right(r));
  }

  @override
  EitherModel<BookingHistoryModel> cancelEmployeeSuggestionFromAdmin(
      {required String employeeId, required String requestId}) async {
    String url = "request-employees/cancel-suggest/$requestId";

    var response = await patch(url, jsonEncode({"employeeId": employeeId}));
    if (response.statusCode == null) response = await patch(url, jsonEncode({"employeeId": employeeId}));
    if (response.statusCode == null) response = await patch(url, jsonEncode({"employeeId": employeeId}));
    if (response.statusCode == null) response = await patch(url, jsonEncode({"employeeId": employeeId}));

    return _convert<BookingHistoryModel>(
      response,
      BookingHistoryModel.fromJson,
    ).fold((CustomError l) => left(l), (BookingHistoryModel r) => right(r));
  }

  @override
  EitherModel<StripeResponseModel> stripePayment({required StripeRequestModel stripeRequestModel}) async {
    String url = "payment/create-session";

    Response response = await post(url, jsonEncode(stripeRequestModel.toJson()));
    if (response.statusCode == null) await post(url, jsonEncode(stripeRequestModel.toJson()));
    if (response.statusCode == null) await post(url, jsonEncode(stripeRequestModel.toJson()));
    if (response.statusCode == null) await post(url, jsonEncode(stripeRequestModel.toJson()));

    return _convert<StripeResponseModel>(
      response,
      StripeResponseModel.fromJson,
    ).fold((CustomError l) => left(l), (StripeResponseModel r) => right(r));
  }

  @override
  EitherModel<EmployeePaymentHistory> employeePaymentHistory({required String employeeId}) async {
    String url = "employee-invoices?employeeId=$employeeId";

    var response = await get(url);
    if (response.statusCode == null) await get(url);
    if (response.statusCode == null) await get(url);
    if (response.statusCode == null) await get(url);

    return _convert<EmployeePaymentHistory>(
      response,
      EmployeePaymentHistory.fromJson,
    ).fold((CustomError l) => left(l), (EmployeePaymentHistory r) => right(r));
  }

  @override
  EitherModel<ReviewDialogModel> showReviewDialog() async {
    String url = "review/view-eligible";

    var response = await get(url);
    if (response.statusCode == null) await get(url);
    if (response.statusCode == null) await get(url);
    if (response.statusCode == null) await get(url);

    return _convert<ReviewDialogModel>(
      response,
      ReviewDialogModel.fromJson,
    ).fold((CustomError l) => left(l), (ReviewDialogModel r) => right(r));
  }

  @override
  EitherModel<CommonResponseModel> giveReview({required ReviewRequestModel reviewRequestModel}) async {
    String url = "review/create";

    var response = await post(url, jsonEncode(reviewRequestModel.toJson()));
    if (response.statusCode == null) await post(url, jsonEncode(reviewRequestModel.toJson()));
    if (response.statusCode == null) await post(url, jsonEncode(reviewRequestModel.toJson()));
    if (response.statusCode == null) await post(url, jsonEncode(reviewRequestModel.toJson()));

    return _convert<CommonResponseModel>(
      response,
      CommonResponseModel.fromJson,
    ).fold((CustomError l) => left(l), (CommonResponseModel r) => right(r));
  }

  @override
  EitherModel<CommonResponseModel> addToShortlistNew({required ShortListRequestModel shortListRequestModel}) async {
    String url = "request-employees/short-list-create";

    var response = await post(url, jsonEncode(shortListRequestModel.toJson()));
    if (response.statusCode == null) await post(url, jsonEncode(shortListRequestModel.toJson()));
    if (response.statusCode == null) await post(url, jsonEncode(shortListRequestModel.toJson()));
    if (response.statusCode == null) await post(url, jsonEncode(shortListRequestModel.toJson()));
    return _convert<CommonResponseModel>(
      response,
      CommonResponseModel.fromJson,
    ).fold((CustomError l) => left(l), (CommonResponseModel r) => right(r));
  }

  @override
  EitherModel<CalenderModel> getCalenderData({required String employeeId}) async {
    String url = "users/working-history/$employeeId";

    Response response = await get(url);
    if (response.statusCode == null) await get(url);
    if (response.statusCode == null) await get(url);
    if (response.statusCode == null) await get(url);
    return _convert<CalenderModel>(
      response,
      CalenderModel.fromJson,
    ).fold((CustomError l) => left(l), (CalenderModel r) => right(r));
  }

  @override
  EitherModel<CommonResponseModel> updateUnavailableDate(
      {required UpdateUnavailableDateRequestModel updateUnavailableDateRequestModel}) async {
    String url = "users/update-unavailable-date";

    Response response = await put(url, jsonEncode(updateUnavailableDateRequestModel.toJson()));
    if (response.statusCode == null) await put(url, jsonEncode(updateUnavailableDateRequestModel.toJson()));
    if (response.statusCode == null) await put(url, jsonEncode(updateUnavailableDateRequestModel.toJson()));
    if (response.statusCode == null) await put(url, jsonEncode(updateUnavailableDateRequestModel.toJson()));

    return _convert<CommonResponseModel>(
      response,
      CommonResponseModel.fromJson,
    ).fold((CustomError l) => left(l), (CommonResponseModel r) => right(r));
  }

  @override
  EitherModel<TodayWorkScheduleModel> getTodayWorkSchedule() async {
    String url = "check-in-check-out-histories/today-work-place";

    Response response = await get(url);
    if (response.statusCode == null) await get(url);
    if (response.statusCode == null) await get(url);
    if (response.statusCode == null) await get(url);
    return _convert<TodayWorkScheduleModel>(
      response,
      TodayWorkScheduleModel.fromJson,
    ).fold((CustomError l) => left(l), (TodayWorkScheduleModel r) => right(r));
  }

  @override
  EitherModel<EmployeeHiredHistoryModel> getHiredHistory() async {
    String url = "users/hired-history";

    Response response = await get(url);
    if (response.statusCode == null) await get(url);
    if (response.statusCode == null) await get(url);
    if (response.statusCode == null) await get(url);
    return _convert<EmployeeHiredHistoryModel>(
      response,
      EmployeeHiredHistoryModel.fromJson,
    ).fold((CustomError l) => left(l), (EmployeeHiredHistoryModel r) => right(r));
  }

  @override
  EitherModel<SingleBookingDetailsModel> getBookingDetails({required String notificationId}) async {
    String url = "notifications/$notificationId";

    Response response = await get(url);
    if (response.statusCode == null) await get(url);
    if (response.statusCode == null) await get(url);
    if (response.statusCode == null) await get(url);
    return _convert<SingleBookingDetailsModel>(
      response,
      SingleBookingDetailsModel.fromJson,
    ).fold((CustomError l) => left(l), (SingleBookingDetailsModel r) => right(r));
  }

  @override
  EitherModel<Response> updateRequestDate({required UpdateShortListRequestModel updateShortListRequestModel}) async {
    Response response =
        await put("notifications/update-request-date", jsonEncode(updateShortListRequestModel.toJson()));
    if (response.statusCode == null) {
      response = await put("notifications/update-request-date", jsonEncode(updateShortListRequestModel.toJson()));
    }
    if (response.statusCode == null) {
      response = await put("notifications/update-request-date", jsonEncode(updateShortListRequestModel.toJson()));
    }
    if (response.statusCode == null) {
      response = await put("notifications/update-request-date", jsonEncode(updateShortListRequestModel.toJson()));
    }

    return _convert<Response>(
      response,
      (Map<String, dynamic> data) {},
      onlyErrorCheck: true,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<TodayCheckInOutDetails> emergencyCheckIn(Map<String, dynamic> data) async {
    Response response = await post("current-hired-employees/create", jsonEncode(data));
    if (response.statusCode == null) response = await post("current-hired-employees/create", jsonEncode(data));
    if (response.statusCode == null) response = await post("current-hired-employees/create", jsonEncode(data));
    if (response.statusCode == null) response = await post("current-hired-employees/create", jsonEncode(data));

    return _convert<TodayCheckInOutDetails>(
      response,
      TodayCheckInOutDetails.fromJson,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<Response> emergencyCheckOut(Map<String, dynamic> data) async {
    Response response = await put("current-hired-employees/update", jsonEncode(data));
    if (response.statusCode == null) response = await put("current-hired-employees/update", jsonEncode(data));
    if (response.statusCode == null) response = await put("current-hired-employees/update", jsonEncode(data));
    if (response.statusCode == null) response = await put("current-hired-employees/update", jsonEncode(data));

    return _convert<Response>(
      response,
      (Map<String, dynamic> data) {},
      onlyErrorCheck: true,
    ).fold((l) => left(l), (r) => right(r));
  }
}
