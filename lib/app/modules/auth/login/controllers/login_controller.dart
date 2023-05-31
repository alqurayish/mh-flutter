import '../../../../common/controller/app_controller.dart';
import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_dialog.dart';
import '../../../../common/widgets/custom_loader.dart';
import '../../../../models/custom_error.dart';
import '../../../../repository/api_helper.dart';
import '../../../../routes/app_pages.dart';
import '../interface/login_view_interface.dart';
import '../model/login.dart';
import '../model/login_response.dart';

class LoginController extends GetxController implements LoginViewInterface {
  BuildContext? context;

  final ApiHelper _apiHelper = Get.find();
  final AppController _appController = Get.find();

  final formKey = GlobalKey<FormState>();

  TextEditingController tecUserId = TextEditingController();
  TextEditingController tecPassword = TextEditingController();

  @override
  void onForgotPasswordPressed() {
    // TODO: implement onForgotPasswordPressed
  }

  @override
  void onLoginPressed() {
    Utils.unFocus();

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      _login();
    }
  }

  @override
  void onRegisterPressed() {
    Get.offAndToNamed(Routes.register);
  }

  Future<void> _login() async {
    Login login = Login(password: tecPassword.text.trim());

    if (GetUtils.isEmail(tecUserId.text.trim())) {
      login.email = tecUserId.text.trim();
    } else {
      login.userIdNumber = tecUserId.text.trim();
    }

    CustomLoader.show(context!);

    await _apiHelper.login(login).then((response) {
      CustomLoader.hide(context!);

      response.fold((CustomError customError) {
        Utils.errorDialog(context!, customError..onRetry = _login);
      }, (LoginResponse loginResponse) {
        if (loginResponse.statusCode == 200) {
          _goToNextRoute(loginResponse.token ?? "");
        } else if (loginResponse.statusCode == 401) {
          _accountBan();
        } else {
          String errorTitle = "Invalid Information";

          if ((loginResponse.message ?? "").contains("email")) {
            errorTitle = "Invalid Email";
          } else if ((loginResponse.message ?? "").contains("password")) {
            errorTitle = "Wrong Password";
          } else {
            errorTitle = "Something wrong! Please contact to support";
          }

          CustomDialogue.information(
            context: context!,
            title: errorTitle,
            description: loginResponse.message ?? "You provide invalid credential",
          );
        }
      });
    });
  }

  Future<void> _goToNextRoute(String token) async {
    await _appController.afterSuccessLogin(token);
  }

  void _accountBan() {

  }
}
