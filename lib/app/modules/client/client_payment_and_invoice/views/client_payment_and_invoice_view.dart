import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_appbar.dart';
import '../controllers/client_payment_and_invoice_controller.dart';

class ClientPaymentAndInvoiceView  extends GetView<ClientPaymentAndInvoiceController> {
  const ClientPaymentAndInvoiceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;

    return Scaffold(
      appBar: CustomAppbar.appbar(
        title: MyStrings.invoicePayment.tr,
        context: context,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // SizedBox(height: 16.h),
          // _title,
          //
          // _items,

          Center(child: Text("No invoice found", style: MyColors.l111111_dwhite(context).semiBold16,)),
        ],
      ),
    );
  }

  Widget get _title {
    return Container(
      height: 60.h,
      decoration: const BoxDecoration(
        color: MyColors.c_C6A34F,
      ),
      child: Row(
        children: [
          _titleText("Week"),
          Container(
            height: 60.h,
            width: 3,
            decoration: BoxDecoration(
              color: MyColors.black.withOpacity(.1),
            ),
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _titleText("Total\nEmployee"),
                _titleText("Total\nHours"),
                _titleText("Amount"),
                _titleText("Invoice\nNo."),
                _titleText("Status"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _titleText(String text) => Center(
    child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: MyColors.white.semiBold14,
          ),
        ),
  );

  Widget get _items => Column(
    children: [
      _item(true),
      _item(false),
      _item(true),
      _item(true),
      _item(true),
    ],
  );

  Widget _item(bool isPaid) {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: isPaid ? MyColors.lightCard(controller.context!) : MyColors.c_FFEDEA,
      ),
      child: Row(
        children: [
          _titleText("Week"),
          Container(
            height: 60.h,
            width: 3,
            decoration: BoxDecoration(
              color: MyColors.black.withOpacity(.1),
            ),
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _valueString("Total\nEmployee"),
                _valueString("Total\nHours"),
                _valueString("Amount"),
                _valueString("Invoice\nNo."),
                _valueString("Status"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _valueString(String text) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: MyColors.white.semiBold13,
        ),
      );
}
