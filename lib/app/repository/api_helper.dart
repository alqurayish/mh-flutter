import 'package:mh/app/modules/calender/models/calender_model.dart';
import 'package:mh/app/modules/calender/models/update_unavailable_date_request_model.dart';
import 'package:mh/app/modules/client/client_suggested_employees/models/short_list_request_model.dart';
import 'package:mh/app/modules/employee/employee_home/models/common_response_model.dart';
import 'package:mh/app/modules/employee/employee_home/models/review_dialog_model.dart';
import 'package:mh/app/modules/employee/employee_home/models/review_request_model.dart';
import 'package:mh/app/modules/employee/employee_home/models/single_notification_model_for_employee.dart';
import 'package:mh/app/modules/employee/employee_payment_history/models/employee_payment_history_model.dart';
import 'package:mh/app/modules/notifications/models/notification_response_model.dart';
import 'package:mh/app/modules/notifications/models/notification_update_request_model.dart';
import 'package:mh/app/modules/notifications/models/notification_update_response_model.dart';
import 'package:mh/app/modules/stripe_payment/models/stripe_request_model.dart';
import 'package:mh/app/modules/stripe_payment/models/stripe_response_model.dart';

import '../common/utils/exports.dart';
import '../common/utils/type_def.dart';
import '../models/all_admins.dart';
import '../models/check_in_out_histories.dart';
import '../models/commons.dart';
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

abstract class ApiHelper {
  EitherModel<Commons> commons();

  EitherModel<LoginResponse> login(
    Login login,
  );

  EitherModel<ClientRegistrationResponse> clientRegister(
    ClientRegistration clientRegistration,
  );

  EitherModel<ClientRegistrationResponse> employeeRegister(
    EmployeeRegistration employeeRegistration,
  );

  EitherModel<Response> updateFcmToken({bool isLogin = true});

  EitherModel<UserInfo> clientDetails(
    String id,
  );

  EitherModel<Employees> getEmployees({
    String? positionId,
    String? rating,
    String? employeeExperience,
    String? minTotalHour,
    String? maxTotalHour,
    bool? isReferred,
  });

  EitherModel<Employees> getAllUsersFromAdmin({
    String? positionId,
    String? rating,
    String? employeeExperience,
    String? minTotalHour,
    String? maxTotalHour,
    bool? isReferred,
    String? requestType,
    bool? active,
  });

  EitherModel<AllAdmins> getAllAdmins();

  EitherModel<TermsConditionForHire> getTermsConditionForHire();

  EitherModel<short_list_employees.ShortlistedEmployees> fetchShortlistEmployees();

  EitherModel<Sources> fetchSources();

  EitherModel<Response> addToShortlist(Map<String, dynamic> data);

  EitherModel<Response> updateShortlistItem(Map<String, dynamic> data);

  EitherModel<Response> deleteFromShortlist(String shortlistId);

  EitherModel<Response> hireConfirm(Map<String, dynamic> data);

  EitherModel<LatLngToAddress> latLngToAddress(double lat, double lng);

  EitherModel<Response> addressToLatLng(String query);

  void submitAppError(Map<String, String> data);

  EitherModel<TodayCheckInOutDetails> dailyCheckInCheckoutDetails(String employeeId);

  EitherModel<TodayCheckInOutDetails> checkIn(Map<String, dynamic> data);

  EitherModel<Response> checkout(Map<String, dynamic> data);

  EitherModel<Response> updateCheckInOutByClient(Map<String, dynamic> data);

  EitherModel<Response> deleteAccount(Map<String, dynamic> data);

  EitherModel<HiredEmployeesByDate> getHiredEmployeesByDate({String? date});

  EitherModel<TodayCheckInOutDetails> getTodayCheckInOutDetails(String employeeId);

  EitherModel<CheckInCheckOutHistory> getCheckInOutHistory({
    String? filterDate,
    String? requestType,
    String? clientId,
    String? employeeId,
  });

  EitherModel<CheckInCheckOutHistory> getEmployeeCheckInOutHistory();

  EitherModel<Response> clientRequestForEmployee(Map<String, dynamic> data);

  EitherModel<requested_employees.RequestedEmployees> getRequestedEmployees({String? clientId});

  EitherModel<Response> addEmployeeAsSuggest(Map<String, dynamic> data);

  EitherModel<OneToOneMsg> getMsg(String senderId, String receiverId);

  EitherModel<Response> sendMsg(Map<String, dynamic> data);

  EitherModel<EmployeeFullDetails> employeeFullDetails(String id);

  EitherModel<ClientRegistrationResponse> updateClientProfile(ClientProfileUpdate clientProfileUpdate);

  EitherModel<ClientInvoiceModel> getClientInvoice(String clientId);

  EitherModel<Response> updatePaymentStatus(Map<String, dynamic> data);

  EitherModel<NotificationResponseModel> getNotifications();

  EitherModel<NotificationUpdateResponseModel> updateNotification(
      {required NotificationUpdateRequestModel notificationUpdateRequestModel});

  EitherModel<SingleNotificationModelForEmployee> singleNotificationForEmployee();

  EitherModel<SingleNotificationModelForEmployee> cancelClientRequestFromAdmin({required String requestId});

  EitherModel<SingleNotificationModelForEmployee> cancelEmployeeSuggestionFromAdmin(
      {required String employeeId, required String requestId});

  EitherModel<StripeResponseModel> stripePayment({required StripeRequestModel stripeRequestModel});

  EitherModel<EmployeePaymentHistory> employeePaymentHistory({required String employeeId});

  EitherModel<ReviewDialogModel> showReviewDialog();

  EitherModel<CommonResponseModel> giveReview({required ReviewRequestModel reviewRequestModel});

  EitherModel<CommonResponseModel> addToShortlistNew({required ShortListRequestModel shortListRequestModel});

  EitherModel<CalenderModel> getCalenderData({required String employeeId});

  EitherModel<CommonResponseModel> updateUnavailableDate(
      {required UpdateUnavailableDateRequestModel updateUnavailableDateRequestModel});
}
