import 'dart:io';
import '../../../../../../common/utils/exports.dart';
import '../../../../../../routes/app_pages.dart';
import '../interface/register_employee_step_4_interface.dart';
import '../models/certificate_with_file.dart';

class RegisterEmployeeStep4Controller extends GetxController implements RegisterEmployeeStep4Interface {
  BuildContext? context;

  final formKey = GlobalKey<FormState>();

  RxList<File> profileImage = <File>[].obs;

  RxList<File> cv = <File>[].obs;

  RxList<CertificateWithFile> certificate = <CertificateWithFile>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void onAddNewCertificateClick() {
    Utils.unFocus();

    if(certificate.isEmpty || (certificate.last.certificateNameController.text.trim().isNotEmpty && certificate.length < 10)) {
      certificate..add(CertificateWithFile())..refresh();
    }
  }

  @override
  void onCertificateTap(int index) {
    // TODO: implement onCertificateTap
  }

  @override
  void onRemoveCertificateClick(int index) {
    certificate..removeAt(index)..refresh();
  }

  @override
  void onCvClick() {
    // TODO: implement onCvClick
  }

  @override
  void onProfileImageClick() {
    // TODO: implement onProfileImageClick
  }

  void onContinuePressed() {
    Get.toNamed(Routes.registerLastStep);
  }


}
