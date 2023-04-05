import '../common/utils/exports.dart';
import '../common/utils/type_def.dart';
import '../models/address_to_lat_lng.dart';
import '../models/check_in_out_histories.dart';
import '../models/client_details.dart';
import '../models/commons.dart';
import '../models/employees_by_id.dart';
import '../models/lat_long_to_address.dart';
import '../models/sources.dart';
import '../modules/auth/login/model/login.dart';
import '../modules/auth/login/model/login_response.dart';
import '../modules/auth/register/models/client_register.dart';
import '../modules/auth/register/models/client_register_response.dart';
import '../modules/auth/register/models/employee_registration.dart';
import '../modules/client/client_dashboard/models/current_hired_employees.dart';
import '../modules/client/client_shortlisted/models/shortlisted_employees.dart' as shortlistEmployees;
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

  EitherModel<ClientDetails> clientDetails(
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

  EitherModel<TermsConditionForHire> getTermsConditionForHire();

  EitherModel<shortlistEmployees.ShortlistedEmployees> fetchShortlistEmployees();

  EitherModel<Sources> fetchSources();

  EitherModel<Response> addToShortlist(Map<String, dynamic> data);

  EitherModel<Response> updateShortlistItem(Map<String, dynamic> data);

  EitherModel<Response> deleteFromShortlist(String shortlistId);

  EitherModel<Response> hireConfirm(Map<String, dynamic> data);

  EitherModel<LatLngToAddress> latLngToAddress(double lat, double lng);

  EitherModel<Response> addressToLatLng(String query);

  void submitAppError(Map<String, String> data);

  EitherModel<TodayCheckInOutDetails> dailyCheckinCheckoutDetails(String employeeId);

  EitherModel<TodayCheckInOutDetails> checkin(Map<String, dynamic> data);

  EitherModel<Response> checkout(Map<String, dynamic> data);

  EitherModel<Response> deleteAccount(Map<String, dynamic> data);

  EitherModel<CurrentHiredEmployees> getAllCurrentHiredEmployees();

  EitherModel<TodayCheckInOutDetails> getTodayCheckInOutDetails(String employeeId);

  EitherModel<CheckInCheckOutHistory> getCheckInOutHistory({
    String? filterDate,
    String? requestType,
    String? clientId,
    String? employeeId,
  });

  EitherModel<CheckInCheckOutHistory> getEmployeeCheckInOutHistory();
}
