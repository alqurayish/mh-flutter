import 'dart:io';
import 'dart:isolate';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/countries.dart';

import '../../../../common/controller/app_controller.dart';
import '../../../../common/data/data.dart';
import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_dialog.dart';
import '../../../../common/widgets/custom_loader.dart';
import '../../../../enums/user_type.dart';
import '../../../../models/custom_error.dart';
import '../../../../models/employees_by_id.dart';
import '../../../../models/sources.dart';
import '../../../../repository/api_helper.dart';
import '../../../../repository/api_helper_impl_with_file_upload.dart';
import '../../../../routes/app_pages.dart';
import '../interface/register_interface.dart';
import '../models/client_register.dart';
import '../models/client_register_response.dart';
import '../models/employee_registration.dart';

import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';

class RegisterController extends GetxController implements RegisterInterface {
  BuildContext? context;

  final ApiHelper _apiHelper = Get.find();
  final AppController appController = Get.find();

  /// user type will change when user click on employee or client
  /// or swipe page
  Rx<UserType> userType = UserType.client.obs;

  final formKeyClient = GlobalKey<FormState>();
  final formKeyEmployee = GlobalKey<FormState>();

  final PageController pageController = PageController();

  /// getter
  bool get isClientRegistration => userType.value == UserType.client;
  bool get isEmployeeRegistration => userType.value == UserType.employee;

  RxBool termsAndConditionCheck = true.obs;

  RxString restaurantAddressFromMap = "".obs;
  double restaurantLat = 0;
  double restaurantLong = 0;


  /// client information
  TextEditingController tecRestaurantName = TextEditingController();
  TextEditingController tecRestaurantAddress = TextEditingController();
  TextEditingController tecEmailAddress = TextEditingController();
  TextEditingController tecPhoneNumber = TextEditingController();
  TextEditingController tecPassword = TextEditingController();
  TextEditingController tecConfirmPassword = TextEditingController();

  // fetch sources
  Sources? sources;
  Employees? employees;

  String selectedSource = "";
  String selectedRefer = "Other";

  RxBool loading = true.obs;

  /// file upload percent and title
  RxString uploadTitle = "Creating new account...".obs;

  RxInt uploadPercent = 0.obs;

  /// employee information
  TextEditingController tecEmployeeFirstName = TextEditingController();
  TextEditingController tecEmployeeLastName = TextEditingController();
  // TextEditingController tecEmployeeDob = TextEditingController();
  TextEditingController tecEmployeeEmail = TextEditingController();
  TextEditingController tecEmployeePhone = TextEditingController();

  RxString selectedCountry = "United Kingdom".obs;

  // Rx<DateTime> dateOfBirth = DateTime.now().obs;

  // RxString selectedGender = Data.genders.first.name!.obs;

  RxString selectedPosition = Data.positions.first.name!.obs;

  RxList<File> profileImage = <File>[].obs;
  RxList<File> cv = <File>[].obs;

  // phone number country code
  Country selectedEmployeeCountry = countries.where((element) => element.code == "GB").first;
  Country selectedClientCountry = countries.where((element) => element.code == "GB").first;


  @override
  void onInit() {
    _fetchSourceAndRefers();
    super.onInit();
  }


  @override
  void onPageChange(int index) {
    onUserTypeClick(UserType.values[index + 1]);
  }

  void onCountryChange(String? country) {
    selectedCountry.value = country!;
  }

  void onSourceChange(String? value) {
    selectedSource = value!;
  }

  void onReferChange(String? value) {
    selectedRefer = value!;
  }

  void onRestaurantAddressPressed() {
    Get.toNamed(Routes.restaurantLocation);
  }

  @override
  void onContinuePressed() {
    Utils.unFocus();
    if (isClientRegistration) {
      _clientRegisterPressed();
    } else if (isEmployeeRegistration) {
      _employeeRegisterPressed();
    }
  }

  @override
  void onLoginPressed() {
    Get.toNamed(Routes.login);
  }

  @override
  void onTermsAndConditionCheck(bool active) {
    termsAndConditionCheck.value = active;
  }

  @override
  void onTermsAndConditionPressed() {
    Get.toNamed(Routes.termsAndCondition);
  }

  @override
  void onUserTypeClick(UserType userType) {
    if (this.userType.value != userType) {
      this.userType.value = userType;

      pageController.jumpToPage(UserType.values.indexOf(userType) - 1);
    }
  }

  // @override
  // void onGenderChange(String? gender) {
  //   selectedGender.value = gender!;
  // }

  @override
  void onPositionChange(String? position) {
    selectedPosition.value = position!;
  }

  void onClientCountryChange(Country country) {
    selectedClientCountry = country;
  }

  void onEmployeeCountryChange(Country country) {
    selectedEmployeeCountry = country;
  }

  // void onDatePicked(DateTime dateTime) {
  //   dateOfBirth.value = dateTime;
  //   tecEmployeeDob.text = dateTime.toString().split(" ").first.trim();
  //   dateOfBirth.refresh();
  // }

  void _clientRegisterPressed() {
    if (formKeyClient.currentState!.validate()) {
      formKeyClient.currentState!.save();

      if(!termsAndConditionCheck.value) {
        _errorDialog("Invalid Input", "you must accept our terms and condition");
      } else {
        _clientRegister();
      }
    }
  }

  void _employeeRegisterPressed() {
    if (formKeyEmployee.currentState!.validate()) {
      formKeyEmployee.currentState!.save();

      if (cv.isNotEmpty && cv.last.path.split(".").last.toLowerCase() != "pdf") {
        _errorDialog("Invalid Input", "CV must be PDF format");
      } else if (!termsAndConditionCheck.value) {
        _errorDialog("Invalid Input", "you must accept our terms and condition");
      } else {
        _employeeRegister();
      }
    }
  }

  void _errorDialog(String title, String details) {
    CustomDialogue.information(
      context: context!,
      title: title,
      description: details,
    );
  }

  String _getSourceId() {
    for (Source element in (sources?.sources ?? [])) {
      if(element.name == selectedSource) {
        return element.id;
      }
    }
    return '';
  }

  String _getReferPersonId() {
    if (selectedRefer == "Other") return "";

    for (Employee element in (employees?.users ?? [])) {
      if("${element.firstName} ${element.lastName} - ${element.userIdNumber}" == selectedRefer) {
        return element.id!;
      }
    }

    return "";
  }

  Future<void> _clientRegister() async {
    ClientRegistration clientRegistration = ClientRegistration(
      restaurantName: tecRestaurantName.text.trim(),
      restaurantAddress: tecRestaurantAddress.text.trim(),
      email: tecEmailAddress.text.trim().toLowerCase(),
      phoneNumber: selectedClientCountry.dialCode + tecPhoneNumber.text.trim(),
      sourceId: _getSourceId(),
      referPersonId: _getReferPersonId(),
      password: tecPassword.text.trim(),
      lat: restaurantLat.toString(),
      long: restaurantLong.toString()
    );

    CustomLoader.show(context!);

    await _apiHelper.clientRegister(clientRegistration).then((response) {

      CustomLoader.hide(context!);

      response.fold((CustomError customError) {
        Utils.errorDialog(context!, customError..onRetry = _clientRegister);
      }, (ClientRegistrationResponse clientRegistrationResponse) async {
        if(clientRegistrationResponse.statusCode == 201) {
          await appController.afterSuccessRegister(clientRegistrationResponse.token!);
        } else if((clientRegistrationResponse.errors ?? []).isNotEmpty) {
          _errorDialog("Invalid Input", clientRegistrationResponse.errors?.first.msg ?? "Please check you input field and try again");
        } else {
          _errorDialog("Something  Wrong", clientRegistrationResponse.message ?? "Failed to Register");
        }
      });
    });
  }

  Future<void> _employeeRegister() async {
    EmployeeRegistration employeeRegistration = EmployeeRegistration(
      firstName: tecEmployeeFirstName.text.trim(),
      lastName: tecEmployeeLastName.text.trim(),
      email: tecEmployeeEmail.text.trim(),
      phoneNumber: tecEmployeePhone.text.trim(),
      countryName: selectedCountry.value,
      positionId: Utils.getPositionId(selectedPosition.value.trim()),
    );

    // update dialogue text

    if(cv.isNotEmpty) {
      uploadTitle.value = "Uploading CV...";
    }
    if(profileImage.isNotEmpty) {
      uploadTitle.value = "Uploading profile image...";
    }
    if(cv.isNotEmpty && profileImage.isNotEmpty) {
      uploadTitle.value = "Uploading CV and profile image...";
    }


    // show dialog
    _showPercentIsolate();

    ReceivePort responseReceivePort = ReceivePort();
    ReceivePort percentReceivePort = ReceivePort();

    responseReceivePort.listen((response) async {
      percentReceivePort.close();
      responseReceivePort.close();

      Get.back(); // hide dialog

      if (response != null) {
        if ([200, 201].contains(response["data"]["statusCode"])) {
          await appController.afterSuccessRegister("");
        } else {
          _errorDialog("Something wrong", response["data"]["message"] ?? "Failed to register. Please check you data and try again");
        }
      } else {
        _errorDialog("Server Error", "Failed to register. Please try again");
      }
    });

    percentReceivePort.listen((message) {
      uploadPercent.value = message;
    });

    Map<String, dynamic> data = {
      "basicData" : employeeRegistration.toJson,
      "profilePicture": profileImage.isEmpty ? null : profileImage.last.path,
      "cv": cv.isEmpty ? null : cv.last.path,
      "responseReceivePort": responseReceivePort.sendPort,
      "percentReceivePort": percentReceivePort.sendPort,
      "token": "",
    };

    await Isolate.spawn(ApiHelperImplementWithFileUpload.employeeRegister, data);
  }

  Future _showPercentIsolate() {
    return showDialog(
      context: context!,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(
                color: MyColors.c_C6A34F,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Text(
                        uploadTitle.value,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Obx(() => Text("${uploadPercent.value}%")),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      barrierDismissible: false,
    );
  }

  Future<void> onCvClick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      cv..clear()..add(File(result.files.single.path!));
    } else {
      cv.clear();
    }
  }

  Future<void> onProfileImageClick() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

    if (pickedFile != null) {
      profileImage..clear()..add(File(pickedFile.path));
    } else {
      profileImage.clear();
    }
  }

  Future<void> _fetchSourceAndRefers() async {

    await Future.wait([
      _apiHelper.fetchSources(),
      _apiHelper.getEmployees(isReferred: true),
    ]).then((response) {

      response[0].fold((CustomError customError) {
        Utils.errorDialog(context!, customError..onRetry = _fetchSourceAndRefers);
      }, (r) {
        sources = r as Sources;
      });

      response[1].fold((CustomError customError) {
        Utils.errorDialog(context!, customError..onRetry = _fetchSourceAndRefers);
      }, (r) {
        employees = r as Employees;
      });

      loading.value = false;

    });
  }

}
