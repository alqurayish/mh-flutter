import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../common/utils/exports.dart';
import '../../../../../../common/widgets/custom_dialog.dart';
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

    if(certificate.isEmpty
        || (certificate.last.certificateNameController.text.trim().isNotEmpty
        && certificate.last.file != null && certificate.length < 10)) {

      certificate..add(CertificateWithFile())..refresh();
    }
  }

  @override
  Future<void> onCertificateTap(int index) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      certificate[index].file = File(result.files.single.path!);
    } else {
      certificate[index].file = null;
    }

    certificate.refresh();
  }

  @override
  void onRemoveCertificateClick(int index) {
    certificate..removeAt(index)..refresh();
  }

  @override
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

  @override
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

  void onContinuePressed() {
    if(profileImage.isEmpty) {
      CustomDialogue.information(
        context: context!,
        description: "Please select a profile image",
        title: 'Invalid Input',
      );
    } else if(cv.isEmpty) {
      CustomDialogue.information(
        context: context!,
        description: "Please upload your cv",
        title: 'Invalid Input',
      );
    } else if(cv.isNotEmpty && cv.last.path.split(".").last.toLowerCase() != "pdf") {
      CustomDialogue.information(
        context: context!,
        description: "CV must be PDF format",
        title: 'Invalid Input',
      );
    }

    else if(certificate.isNotEmpty) {

      for(CertificateWithFile certificateWithFile in certificate) {
        if (certificateWithFile.certificateNameController.text.trim().isEmpty) {
          CustomDialogue.information(
            context: context!,
            description: "Certificate name and file are required",
            title: 'Invalid Input',
          );
          break;
        }
      }

    } else {
      Get.toNamed(Routes.registerLastStep);
    }
  }


}
