import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../common/local_storage/storage_helper.dart';
import '../common/utils/exports.dart';
import '../common/utils/logcat.dart';
import '../common/utils/type_def.dart';
import '../enums/error_from.dart';
import '../models/client_details.dart';
import '../models/commons.dart';
import '../models/custom_error.dart';
import '../models/employees_by_id.dart';
import '../models/sources.dart';
import '../modules/auth/login/model/login.dart';
import '../modules/auth/login/model/login_response.dart';
import '../modules/auth/register/models/client_register.dart';
import '../modules/auth/register/models/client_register_response.dart';
import '../modules/auth/register/models/employee_registration.dart';
import '../modules/client/client_shortlisted/models/shortlisted_employees.dart';
import '../modules/client/client_terms_condition_for_hire/models/terms_condition_for_hire.dart';
import 'api_error_handel.dart';
import 'api_helper.dart';

part 'api_urls.dart';

class ApiHelperImpl extends GetConnect with ApiHelper {
  @override
  void onInit() {
    httpClient.baseUrl = _ApiUrls.base;
    httpClient.timeout = const Duration(seconds: 120);

    httpClient.addRequestModifier<dynamic>((request) {
      Logcat.msg(request.url.toString());
      if (StorageHelper.hasToken) {
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
      if (response == null || response.statusCode == null || response.statusText!.contains("SocketException")) {
        return left(CustomError(
          errorCode: response?.statusCode ?? 500,
          errorFrom: ErrorFrom.noInternet,
          msg: "No internet connection",
        ));
      }

      Either<CustomError, Response> hasError = ApiErrorHandle.checkError(response);

      if (hasError.isLeft()) return left(hasError.asLeft);

      if (onlyErrorCheck) return right(response as T);

      return right(base(response.body) as T);
    } catch (e, s) {
      Logcat.msg(e.toString());
      Logcat.stack(s);

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

    return _convert<LoginResponse>(
      response,
      LoginResponse.fromJson,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<ClientRegistrationResponse> clientRegister(
    ClientRegistration clientRegistration,
  ) async {
    var response = await get("users/client-register");

    return _convert<ClientRegistrationResponse>(
      response,
      ClientRegistrationResponse.fromJson,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<ClientRegistrationResponse> employeeRegister(
    EmployeeRegistration employeeRegistration,
  ) async {
    var response = await get("users/employee-register");

    return _convert<ClientRegistrationResponse>(
      response,
      ClientRegistrationResponse.fromJson,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<ClientDetails> clientDetails(
    String id,
  ) async {
    var response = await get("users/$id");

    return _convert<ClientDetails>(
      response,
      ClientDetails.fromJson,
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
    String url = "users?";

    if ((positionId ?? "").isNotEmpty) url += "positionId=$positionId";
    if ((rating ?? "").isNotEmpty) url += "&rating=$rating";
    if ((employeeExperience ?? "").isNotEmpty) url += "&employeeExperience=$employeeExperience";
    if ((minTotalHour ?? "").isNotEmpty) url += "&minTotalHour=$minTotalHour";
    if ((maxTotalHour ?? "").isNotEmpty) url += "&maxTotalHour=$maxTotalHour";
    if (isReferred ?? false) url += "&isReferred=${isReferred!.toApiFormat}";

    var response = await get(url);

    print(response.body);

    return _convert<Employees>(
      response,
      Employees.fromJson,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<TermsConditionForHire> getTermsConditionForHire() async {
    var response = await get("terms-conditions");

    return _convert<TermsConditionForHire>(
      response,
      TermsConditionForHire.fromJson,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<ShortlistedEmployees> fetchShortlistEmployees() async {
    var response = await get("short-list");

    print(response.body);

    return _convert<ShortlistedEmployees>(
      response,
      ShortlistedEmployees.fromJson,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<Response> addToShortlist(
    Map<String, dynamic> data,
  ) async {
    var response = await post("short-list/create", jsonEncode(data));

    return _convert<Response>(
      response,
      (Map<String, dynamic> data) {},
      onlyErrorCheck: true,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<Sources> fetchSources() async {
    var response = await get("sources");

    print(response.body);

    return _convert<Sources>(
      response,
      Sources.fromJson,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<Response> updateShortlistItem(Map<String, dynamic> data) async {
    var response = await put("short-list/update", jsonEncode(data));

    return _convert<Response>(
      response,
      (Map<String, dynamic> data) {},
      onlyErrorCheck: true,
    ).fold((l) => left(l), (r) => right(r));
  }

  @override
  EitherModel<Response> deleteFromShortlist(String shortlistId) async {
    var response = await delete("short-list/delete/$shortlistId");

    print(response.body);

    return _convert<Response>(
      response,
      (Map<String, dynamic> data) {},
      onlyErrorCheck: true,
    ).fold((l) => left(l), (r) => right(r));
  }
}
