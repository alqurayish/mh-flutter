import 'dart:isolate';

import '../../../../../../common/controller/app_controller.dart';
import '../../../../../../common/local_storage/storage_helper.dart';
import '../../../../../../common/utils/exports.dart';
import '../../../../../../common/widgets/custom_dialog.dart';
import '../../../../../../common/widgets/custom_loader.dart';
import '../../../../../../enums/user_type.dart';
import '../../../../../../models/custom_error.dart';
import '../../../../../../models/employees_by_id.dart';
import '../../../../../../models/sources.dart';
import '../../../../../../repository/api_helper.dart';
import '../../../../../../repository/api_helper_impl_with_file_upload.dart';
import '../../../../../../routes/app_pages.dart';
import '../../../controllers/register_controller.dart';
import '../../../models/client_register.dart';
import '../../../models/client_register_response.dart';
import '../../../models/employee_registration.dart';
import '../../register_employee_step_2/controllers/register_employee_step_2_controller.dart';
import '../../register_employee_step_3/controllers/register_employee_step_3_controller.dart';
import '../../register_employee_step_4/controllers/register_employee_step_4_controller.dart';

import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';

class RegisterLastStepController extends GetxController {
  final ApiHelper _apiHelper = Get.find();
  final AppController _appController = Get.find();
  final RegisterController _registerController = Get.find();

  BuildContext? context;

  final formKey = GlobalKey<FormState>();

  // fetch sources
  Sources? sources;
  Employees? employees;

  String selectedSource = "";
  String selectedRefer = "Other";

  RxBool loading = true.obs;

  /// file upload percent and title
  RxString uploadTitle = "Profile image and cv uploading...".obs;
  RxInt uploadPercent = 0.obs;

  @override
  void onInit() {
    super.onInit();

    _fetchSourceAndRefers();
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
      if("${element.name} - ${element.userIdNumber}" == selectedRefer) {
        return element.id!;
      }
    }

    return "";
  }

  void onRegisterClick() {

    Utils.unFocus();

    _appController.user.value.userType = _registerController.isClientRegistration
            ? UserType.client
            : UserType.employee;

    if(_appController.user.value.isClient) {
      _clientRegistration();
    } else if(_appController.user.value.isEmployee) {
      _employeeRegistration();
    }
  }

  @override
  void onSourceChange(String? value) {
    selectedSource = value!;
  }

  @override
  void onReferChange(String? value) {
    selectedRefer = value!;
  }

  Future<void> _clientRegistration() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      ClientRegistration clientRegistration = ClientRegistration(
        restaurantName: _registerController.tecRestaurantName.text,
        restaurantAddress: _registerController.tecRestaurantAddress.text,
        email: _registerController.tecEmailAddress.text,
        phoneNumber: _registerController.selectedClientCountry.dialCode + _registerController.tecPhoneNumber.text,
        sourceId: _getSourceId(),
        referPersonId: _getReferPersonId(),
        password: _registerController.tecPassword.text,
      );

      CustomLoader.show(context!);

      await _apiHelper.clientRegister(clientRegistration).then((response) {

        CustomLoader.hide(context!);

        response.fold((CustomError customError) {
          Utils.errorDialog(context!, customError..onRetry = _clientRegistration);
        }, (ClientRegistrationResponse clientRegistrationResponse) async {
          _afterSuccessfullyRegister(clientRegistrationResponse, true);
        });
      });
    }
  }

  Future<void> _employeeRegistration() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      RegisterEmployeeStep2Controller step2 = Get.find();
      RegisterEmployeeStep3Controller step3 = Get.find();

      EmployeeRegistration employeeRegistration = EmployeeRegistration(
          name : _registerController.tecEmployeeFullName.text.trim(),
          positionId : Utils.getPositionId(_registerController.selectedPosition.value.trim()),
          gender : _registerController.selectedGender.value.trim(),
          dateOfBirth : _registerController.dateOfBirth.value.toString().split(" ").first,
          email : _registerController.tecEmployeeEmail.text.trim(),
          phoneNumber : _registerController.selectedEmployeeCountry.dialCode + _registerController.tecEmployeePhone.text.trim(),
          countryName : step2.selectedCountry.value.trim(),
          presentAddress : step2.tecPresentAddress.text.trim(),
          permanentAddress : step2.tecPermanentAddress.text.trim(),
          languages : step2.selectedLanguageList.value,
          higherEducation : step3.tecEducation.text.trim(),
          licensesNo : step3.tecLicence.text.trim(),
          emmergencyContact : step3.selectedCountry.dialCode + step3.tecEmergencyContact.text.trim(),
          skills : Utils.getSkillIds(step3.selectedSkillList.value),
          sourceId : _getSourceId(),
          referPersonId : _getReferPersonId(),
          employeeExperience : 0,
      );

      CustomLoader.show(context!);

      await _apiHelper.employeeRegister(employeeRegistration).then((response) {

        CustomLoader.hide(context!);

        response.fold((CustomError customError) {
          Utils.errorDialog(context!, customError..onRetry = _clientRegistration);
        }, (ClientRegistrationResponse clientRegistrationResponse) async {
          _afterSuccessfullyRegister(clientRegistrationResponse, false);
        });
      });
    }
  }


  Future<void> _afterSuccessfullyRegister(ClientRegistrationResponse clientRegistrationResponse, bool clientRegistration) async {
    if (clientRegistrationResponse.statusCode == 201) {

      if(clientRegistration) {
        await _appController.afterSuccessRegister(clientRegistrationResponse.token!);
      } else {
        _uploadImageAndCv(clientRegistrationResponse.details!.id!);
      }

    } else if (clientRegistrationResponse.statusCode == 400) {
      String errorTitle = "Invalid Information";
      String msg = "";

      for(var element in (clientRegistrationResponse.errors ?? []).reversed) {
        if(element.value != null) {
          msg = element.msg ?? "You Provide invalid value";
          break;
        }
      }

      CustomDialogue.information(
        context: context!,
        title: errorTitle,
        description: msg,
      );
    } else {
      CustomDialogue.information(
        context: context!,
        title: 'Error!',
        description: "Something wrong. Please try after sometime or contact us",
      );
    }
  }

  Future<void> _uploadImageAndCv(String id) async {
    RegisterEmployeeStep4Controller step4 = Get.find();

    dio.FormData formData = dio.FormData.fromMap({
      "id": id,
    });

    formData.files.add(MapEntry(
        "profilePicture",
        await dio.MultipartFile.fromFile(
          step4.profileImage.last.path,
          filename: step4.profileImage.last.path.split("/").last,
          contentType: MediaType("image", "jpeg"),
        )));

    formData.files.add(MapEntry(
        "cv",
        await dio.MultipartFile.fromFile(
          step4.cv.last.path,
          filename: step4.cv.last.path.split("/").last,
          contentType: MediaType("application", "pdf"),
        )));


    _startUploadImageAndCv(id, formData);
  }

  Future<void> _startUploadImageAndCv(String id, dio.FormData formData) async {
    // show dialog
    _showPercentIsolate();

    ReceivePort responseReceivePort = ReceivePort();
    ReceivePort percentReceivePort = ReceivePort();

    responseReceivePort.listen((response) async {
      percentReceivePort.close();
      responseReceivePort.close();

      if (response != null) {
        if ([200, 201].contains(response["data"]["statusCode"])) {
          _uploadCertificates(id, 0);
        }  else {
          Get.back();
          _uploadErrorDialog(response["data"]["message"] ?? "Sorry! Failed to upload profile image and cv. Please try again or contact to our support");
        }
      } else {
        Get.back(); // hide dialog
        _uploadErrorDialog("Server Error! Failed to upload profile image and cv");
      }
    });

    percentReceivePort.listen((message) {
      uploadPercent.value = message;
    });

    Map<String, dynamic> data = {
      "formData": formData,
      "responseReceivePort": responseReceivePort.sendPort,
      "percentReceivePort": percentReceivePort.sendPort,
      "token": "",
    };

    await Isolate.spawn(ApiHelperImplementWithFileUpload.uploadProfileImageAndCv, data);
  }

  Future<void> _uploadCertificates(String id, int imageIndex) async {
    RegisterEmployeeStep4Controller step4 = Get.find();

    if(step4.certificate.isEmpty || imageIndex == step4.certificate.length) {
      Get.back(); // hide dialog
      await _appController.afterSuccessRegister("");
      return;
    }

    uploadTitle.value = "Uploading certificate ${imageIndex + 1} of ${step4.certificate.length}";
    uploadPercent.value = 0;

    dio.FormData formData = dio.FormData.fromMap({
      "id": id,
      "certificateName": step4.certificate[imageIndex].certificateNameController.text.trim(),
    });

    formData.files.add(MapEntry(
        "attachment",
        await dio.MultipartFile.fromFile(
          step4.profileImage.last.path,
          filename: step4.profileImage.last.path.split("/").last,
          contentType: MediaType("image", "jpeg"),
        )));

    await _startUploadCertificates(id, imageIndex, formData);
  }

  Future<void> _startUploadCertificates(String id, int imageIndex, dio.FormData formData) async {

    ReceivePort responseReceivePort = ReceivePort();
    ReceivePort percentReceivePort = ReceivePort();

    responseReceivePort.listen((response) async {
      percentReceivePort.close();
      responseReceivePort.close();

      if (response != null) {
        if ([200, 201].contains(response["data"]["statusCode"])) {
          _uploadCertificates(id, imageIndex + 1);
        }  else {
          Get.back();
          _uploadErrorDialog(response["data"]["message"] ?? "Sorry! Failed to upload certificate. Please try again or contact to our support");
        }
      } else {
        Get.back(); // hide dialog
        _uploadErrorDialog("Server Error! Failed to upload certificate.");
      }
    });

    percentReceivePort.listen((message) {
      uploadPercent.value = message;
    });

    Map<String, dynamic> data = {
      "formData": formData,
      "responseReceivePort": responseReceivePort.sendPort,
      "percentReceivePort": percentReceivePort.sendPort,
      "token": "",
    };

    await Isolate.spawn(ApiHelperImplementWithFileUpload.uploadCertificates, data);
  }

  void _uploadErrorDialog(String msg) {
    CustomDialogue.information(
      context: context!,
      title: 'Upload Failed',
      description: msg,
    );
  }

  Future _showPercentIsolate() {
    return showDialog(
      context: context!,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
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
}
