import 'package:dartz/dartz.dart';
import 'package:mh/app/common/widgets/custom_loader.dart';
import 'package:mh/app/models/custom_error.dart';
import 'package:mh/app/modules/client/client_shortlisted/models/add_to_shortlist_request_model.dart';
import 'package:mh/app/modules/client/client_shortlisted/models/update_shortlist_request_model.dart';
import 'package:mh/app/modules/client/client_shortlisted/widgets/client_short_listed_request_date_widget.dart';

import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_dialog.dart';
import '../../../../repository/api_helper.dart';
import '../../../../routes/app_pages.dart';
import '../../common/shortlist_controller.dart';
import '../models/shortlisted_employees.dart';

class ClientShortlistedController extends GetxController {
  BuildContext? context;

  final ApiHelper _apiHelper = Get.find();

  final ShortlistController shortlistController = Get.find();

  void onSelectClick(ShortList shortList) {
    shortlistController.onSelectClick(shortList);
  }

  void onBookAllClick() {
    if (shortlistController.shortList.isEmpty) {
      CustomDialogue.information(
        context: context!,
        title: "Empty Shortlist",
        description: "Please add employee to shortlist then continue",
      );
    } else if (shortlistController.isDateRangeSetForSelectedUser()) {
      Get.toNamed(Routes.clientTermsConditionForHire);
    } else {
      CustomDialogue.information(
        context: context!,
        title: "Invalid Input",
        description: "Please select the date and time range for when you want to hire an employee",
      );
    }
  }

  void onDaysSelectedClick({required List<RequestDateModel> requestDateList, required String shortListId}) {
    if (requestDateList.isEmpty) {
      Utils.showSnackBar(
          message: 'You have not any selected dates currently.\nPlease select the dates first', isTrue: false);
    } else {
      Get.dialog(Dialog(
        backgroundColor: MyColors.lightCard(Get.context!),
        insetPadding: EdgeInsets.symmetric(horizontal: 20.0.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: ClientShortListedRequestDateWidget(requestDateList: requestDateList, shortListId: shortListId),
      ));
    }
  }

  void onDateRemoveClick(
      {required int index, required String shortListId, required List<RequestDateModel> requestDateList}) {
    CustomDialogue.confirmation(
      context: Get.context!,
      title: "Confirm?",
      msg: "Are you sure you want to remove this range?",
      confirmButtonText: "Remove",
      onConfirm: () async {
        Get.back();
        requestDateList.removeAt(index);
        UpdateShortListRequestModel updateShortListRequestModel =
            UpdateShortListRequestModel(shortListId: shortListId, requestDateList: requestDateList);
        await updateShortListDateOrTime(updateShortListRequestModel: updateShortListRequestModel);
      },
    );
  }

  Future<void> updateShortListDateOrTime({required UpdateShortListRequestModel updateShortListRequestModel}) async {
    CustomLoader.show(context!);
    Either<CustomError, Response> response =
        await _apiHelper.updateShortlistItem(updateShortListRequestModel: updateShortListRequestModel);
    CustomLoader.hide(context!);
    Get.back();
    response.fold((l) {
      Logcat.msg(l.msg);
    }, (r) async {
      if ([200, 201].contains(r.statusCode)) {
        await shortlistController.fetchShortListEmployees();
      } else {
        CustomDialogue.information(
          context: Get.context!,
          title: "Error",
          description: "Something went wrong",
        );
      }
    });
  }
}
