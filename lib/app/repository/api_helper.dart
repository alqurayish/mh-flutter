import '../common/utils/exports.dart';
import '../common/utils/type_def.dart';
import '../models/client_details.dart';
import '../models/commons.dart';
import '../models/employees_by_id.dart';
import '../models/sources.dart';
import '../modules/auth/login/model/login.dart';
import '../modules/auth/login/model/login_response.dart';
import '../modules/auth/register/models/client_register.dart';
import '../modules/auth/register/models/client_register_response.dart';
import '../modules/auth/register/models/employee_registration.dart';
import '../modules/client/client_shortlisted/models/shortlisted_employees.dart';
import '../modules/client/client_terms_condition_for_hire/models/terms_condition_for_hire.dart';

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

  EitherModel<TermsConditionForHire> getTermsConditionForHire();

  EitherModel<ShortlistedEmployees> fetchShortlistEmployees();

  EitherModel<Sources> fetchSources();

  EitherModel<Response> addToShortlist(Map<String, dynamic> data);
}
