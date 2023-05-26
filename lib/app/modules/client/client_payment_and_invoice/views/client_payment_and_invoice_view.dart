import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:mh/app/modules/client/client_payment_and_invoice/model/client_invoice.dart';

import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_appbar.dart';
import '../controllers/client_payment_and_invoice_controller.dart';

class ClientPaymentAndInvoiceView
    extends GetView<ClientPaymentAndInvoiceController> {
  const ClientPaymentAndInvoiceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;

    return Scaffold(
      appBar: CustomAppbar.appbar(
        title: MyStrings.invoicePayment.tr,
        context: context,
      ),
      body: Obx(
        () => controller.clientHomeController.isLoading.value
            ? _loading
            : (controller.clientHomeController.clientInvoice.value.invoices ?? []).isEmpty
                ? Center(
                    child: Text(
                    "No invoice found",
                    style: MyColors.l111111_dwhite(context).semiBold16,
                  ))
                : HorizontalDataTable(
                    leftHandSideColumnWidth: 143.w,
                    rightHandSideColumnWidth: 400.w,
                    isFixedHeader: true,
                    headerWidgets: _getTitleWidget(),
                    leftSideItemBuilder: _generateFirstColumnRow,
                    rightSideItemBuilder: _generateRightHandSideColumnRow,
                    itemCount: (controller.clientHomeController.clientInvoice.value.invoices ?? []).length,
                    rowSeparatorWidget: Container(
                      height: 6.h,
                      color: MyColors.lFAFAFA_dframeBg(context),
                    ),
                    leftHandSideColBackgroundColor:
                        MyColors.lffffff_dbox(context),
                    rightHandSideColBackgroundColor:
                        MyColors.lffffff_dbox(context),
                  ),
      ),
    );
  }

  Widget get _loading => const Center(
        child: CircularProgressIndicator(
          color: MyColors.c_C6A34F,
        ),
      );


  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('Week', 143.w),
      _getTitleItemWidget('Total\nEmployee', 100.w),
      _getTitleItemWidget('Amount', 100.w),
      _getTitleItemWidget('Invoice\nNo', 100.w),
      _getTitleItemWidget('Status', 100.w),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      width: width,
      height: 62.h,
      color: MyColors.c_C6A34F,
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: MyColors.lffffff_dframeBg(controller.context!).semiBold14,
        ),
      ),
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    Invoice invoice = controller.clientHomeController.clientInvoice.value.invoices![index];

    double height = 71.h;

    if(invoice.status != "PAID") {
      height = 100.h;
    }

    return SizedBox(
      width: 143.w,
      height: height,
      child: _cell(
        width: 143.w,
        height: height,
        value: '-',
        isPaid: invoice.status == "PAID",
        child: Row(
          children: [
            const Spacer(),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                      "${invoice.fromWeekDate.toString().split(" ").first}\n-\n${invoice.toWeekDate.toString().split(" ").first}",
                    textAlign: TextAlign.center,
                    style: MyColors.l7B7B7B_dtext(context).semiBold13,
                  ),
                ),

                Visibility(
                  visible: invoice.status != "PAID",
                  child: Column(
                    children: [

                      const SizedBox(height: 10),

                      CustomButtons.button(
                        text: "Pay",
                        height: 25,
                        onTap: () => controller.onPayClick(index),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        customButtonStyle: CustomButtonStyle.radiusTopBottomCorner,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Spacer(),

            Container(
              width: 4,
              height: 71.h,
              decoration: BoxDecoration(
                color: invoice.status == "PAID" ?  MyColors.c_00C92C : MyColors.c_FF5029,
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cell({
    required double width,
    required double height,
    required String value,
    required bool isPaid,
    String? clientUpdatedValue,
    Widget? child,
  }) =>
      Container(
        width: width,
        height: height,
        color: isPaid ? Colors.transparent : MyColors.c_FFEDEA,
        child: child ?? Center(
          child: Text.rich(
            TextSpan(
                text: value,
                children: [
                  TextSpan(
                      text: (clientUpdatedValue == null) || (clientUpdatedValue == value) ? "" : '\n$clientUpdatedValue',
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                      )
                  ),
                ]
            ),
            textAlign: TextAlign.center,
            style: MyColors.l7B7B7B_dtext(controller.context!).semiBold13,
          ),
        ),
      );

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {

    Invoice invoice = controller.clientHomeController.clientInvoice.value.invoices![index];

    double height = 71.h;

    if(invoice.status != "PAID") {
      height = 100.h;
    }

    return Row(
      children: <Widget>[
        _cell(width: 100.w, height: height, value: (invoice.totalEmployee ?? 0).toString(), isPaid: invoice.status == "PAID"),
        _cell(width: 100.w, height: height, value: (invoice.amount ?? 0).toStringAsFixed(2), isPaid: invoice.status == "PAID"),
        _cell(width: 100.w, height: height, value: invoice.invoiceNumber ?? "-", isPaid: invoice.status == "PAID"),
        _cell(width: 100.w,
          height: height,
          value: "-",
          child: Center(
            child: Text(invoice.status ?? "-",
              style: invoice.status == "PAID" ? MyColors.c_00C92C.semiBold18 : MyColors.c_FF5029.semiBold18,
            ),
          ),
          isPaid: invoice.status == "PAID",),
      ],
    );
  }
}
