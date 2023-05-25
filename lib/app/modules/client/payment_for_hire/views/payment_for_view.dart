import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_appbar.dart';
import '../../../../common/widgets/custom_bottombar.dart';
import '../../../../common/widgets/custom_payment_method.dart';
import '../../../../enums/selected_payment_method.dart';
import '../controllers/payment_for_hire_controller.dart';

class PaymentForHireView extends GetView<PaymentForHireController> {
  const PaymentForHireView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;

    return Scaffold(
      appBar: CustomAppbar.appbar(
        title: "Payment",
        context: context,
      ),
      bottomNavigationBar: _bottomBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _total,

            SizedBox(height: 20.h),

            _availablePaymentMethod,

          ],
        ),
      ),
    );
  }

  Widget get _total {
    return Container(
      height: Get.height * .2,
      width: double.infinity,
      margin: EdgeInsets.all(25.w),
      decoration: BoxDecoration(
        color: MyColors.c_C6A34F,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Introduction Fee",
            style: MyColors.white.regular15,
          ),

          SizedBox(height: 10.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '\$',
                style: MyColors.white.medium12.copyWith(fontSize: 45),
              ),

              SizedBox(width: 10.w),

              Text(
                controller.shortlistController.getIntroductionFeesWithDiscount().toStringAsFixed(2),
                style: MyColors.white.semiBold22.copyWith(fontSize: 45),
              ),
            ],
          ),

          Visibility(
            visible: controller.shortlistController.getIntroductionFeesWithDiscount() != controller.shortlistController.getIntroductionFeesWithoutDiscount(),
            child: Text(
              controller.shortlistController.getIntroductionFeesWithoutDiscount().toStringAsFixed(2),
              style: MyColors.white.semiBold22.copyWith(fontSize: 20).copyWith(
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ),

          Visibility(
              visible: controller.shortlistController.getIntroductionFeesWithDiscount() != controller.shortlistController.getIntroductionFeesWithoutDiscount(),
              child: Text("Discount ${controller.appController.user.value.client?.clientDiscount ??0}%")),
        ],
      ),
    );
  }

  Widget get _availablePaymentMethod {
    return CustomPaymentMethod(
      availablePaymentMethods: const [
        SelectedPaymentMethod.card,
        // PaymentMethod.bank,
      ],
      onChange: controller.onPaymentMethodChange,
    );
  }

  Widget _paymentMethodItem(String name) {
    return Image.asset(
      name,
      width: 60.w,
      height: 50.h,
    );
  }

  Widget get _paymentUnavailable {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 23.h),
      decoration: BoxDecoration(
        color: MyColors.c_C6A34F_22,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          width: .5,
          color: MyColors.c_C6A34F,
        ),
      ),
      child: Text(
        "SORRY! Our all payment options currently unavailable.",
        // textAlign: TextAlign.center,
        style: MyColors.c_C6A34F.semiBold15,
      ),
    );
  }

  Widget _bottomBar(BuildContext context) {
    return CustomBottomBar(
        child: CustomButtons.button(
          onTap: controller.onSubmitRequestClick,
          text: controller.shortlistController.getIntroductionFeesWithDiscount() == 0 ? "Submit Request" : "Pay",
          customButtonStyle: CustomButtonStyle.radiusTopBottomCorner,
        ));
  }
}
