import 'package:dotted_border/dotted_border.dart';

import '../../../../../../common/utils/exports.dart';
import '../../../../../../common/utils/validators.dart';
import '../../../../../../common/widgets/custom_text_input_field.dart';
import '../controllers/register_employee_step_4_controller.dart';
import '../models/certificate_with_file.dart';

class RegisterEmployeeStep4View extends GetView<RegisterEmployeeStep4Controller> {
  const RegisterEmployeeStep4View({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    Utils.setStatusBarColorColor(Theme.of(context).brightness);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        height: double.infinity,
        child: Stack(
          children: [
            Positioned(
              left: -65.w,
              top: -100.h,
              child: _topLeftBg,
            ),

            Positioned(
              right: -75.w,
              bottom: -130.h,
              child: _bottomRightBg,
            ),

            _mainContent,
          ],
        ),
      ),
    );
  }

  Widget get _mainContent => Form(
    key: controller.formKey,
    child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 60.h),

          Image.asset(
            MyAssets.logo,
            width: 112.w,
            height: 100.h,
          ),

          SizedBox(height: 45.h),

          _pageContentTitle,

          SizedBox(height: 18.h),

          _steps,

          SizedBox(height: 30.h),

          _profileImage,

          SizedBox(height: 30.h),

          _certificateHeader,

          Container(
            margin: EdgeInsets.symmetric(horizontal: 18.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Obx(
              () => Column(
                children: [
                  ...controller.certificate.asMap().entries.map((e) {
                        return _certificateItem(
                          e.key,
                          e.value,
                          e.key == controller.certificate.length - 1,
                        );
                      }),
                ],
              ),
            ),
          ),

          SizedBox(height: 53.h),

          CustomButtons.button(
            text: MyStrings.continue_.tr,
            onTap: controller.onContinuePressed,
            margin: const EdgeInsets.symmetric(horizontal: 18),
          ),

          SizedBox(height: 52.h),
        ],
      ),
    ),
  );

  Widget get _topLeftBg => Container(
    width: 180.w,
    height: 180.h,
    decoration: BoxDecoration(
      color: Theme.of(controller.context!).cardColor,
      shape: BoxShape.circle,
    ),
  );

  Widget get _pageContentTitle => Text(
    MyStrings.imageCertificate.tr,
    style: Theme.of(controller.context!).textTheme.headline1!.copyWith(
      fontSize: 18.sp,
    ),
  );

  Widget get _steps => Padding(
    padding: const EdgeInsets.only(left: 18),
    child: Text(
      MyStrings.steps.trParams({'step': '4'}),
      style: Theme.of(controller.context!).textTheme.headline3!.copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        fontFamily: MyAssets.fontMontserrat,
      ),
    ),
  );

  Widget get _bottomRightBg => Container(
    width: 200.w,
    height: 200.h,
    decoration: BoxDecoration(
      color: Theme.of(controller.context!).cardColor,
      shape: BoxShape.circle,
    ),
  );

  Widget get _certificateHeader => Container(
        margin: EdgeInsets.all(18.w),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(width: .5, color: Colors.blue),
          color: Theme.of(controller.context!).cardColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: GestureDetector(
          onTap: controller.onAddNewCertificateClick,
          child: Row(
            children: [
              const Icon(Icons.file_copy),
              const SizedBox(width: 12),
              Text("Upload your certificates",
              style: Theme.of(controller.context!).textTheme.bodyText1!.copyWith(

              ),),
              const Spacer(),
              Container(
                decoration: const BoxDecoration(
                  color: MyColors.c_C6A34F,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add,
                  color: Theme.of(controller.context!).cardColor,
                ),
              ),
            ],
          ),
        ),
      );

  Widget get _profileImage => DottedBorder(
    borderType: BorderType.Circle,
    dashPattern: const [11],
    strokeWidth: 2,
    color: MyColors.c_C6A34F,
    child: Container(
          height: 162.w,
          width: 162.w,
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: MyColors.c_C6A34F_22,
            shape: BoxShape.circle,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.camera_alt, color: MyColors.c_C6A34F, size: 50),
              const SizedBox(height: 5),
              Text(MyStrings.uploadYourPhoto.tr,
              textAlign: TextAlign.center,
              style: Theme.of(controller.context!).textTheme.bodyText2!.copyWith(
                fontSize: 12.sp,
              ),),
            ],
          ),
        ),
  );

  Widget _certificateItem(
    int index,
    CertificateWithFile value,
    bool isLastItem,
  ) =>
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomTextInputField(
                          label: "Certificate Name",
                          controller: value.certificateNameController,
                          prefixIcon: Icons.card_membership,
                          padding: EdgeInsets.zero,
                          validator: (String? value) => Validators.emptyValidator(
                            value,
                            MyStrings.required.tr,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => controller.onRemoveCertificateClick(index),
                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 7),

                  GestureDetector(
                    onTap: () => controller.onCertificateTap(index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
                      decoration: BoxDecoration(
                        color: Theme.of(controller.context!).cardColor,
                        border: Border.all(width: .5, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: value.file == null
                          ? Row(
                              children: [
                                const Icon(
                                  Icons.upload_file_outlined,
                                  color: MyColors.c_7B7B7B,
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "Choose certificate",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      "Only PDF allowed",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.upload,
                                  color: MyColors.c_7B7B7B,
                                  size: 18,
                                ),
                                SizedBox(width: 10.w),
                              ],
                            )
                          : Row(
                              children: const [
                                Icon(Icons.upload_file_outlined),
                                SizedBox(width: 12),
                                Text("Training on manager"),
                                SizedBox(width: 12),
                                Icon(Icons.close),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),

            Visibility(visible: !isLastItem, child: const Divider(thickness: .1)),
          ],
        ),
      );
}
