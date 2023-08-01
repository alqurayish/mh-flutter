import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class InvoicePdfController extends GetxController {
  late File invoiceFile;

  late BuildContext context;

  @override
  void onInit() {
    invoiceFile = Get.arguments[0];
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

  void onDownloadPressed() {
    if (invoiceFile.path.isNotEmpty) {
      // Download the PDF using the share package.
      downloadInvoicePDF();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invoice has been downloaded')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Generate the invoice first.')),
      );
    }
  }

  // Function to download the invoice PDF using the share package.
  Future<void> downloadInvoicePDF() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String downloadPath = '${appDocDir.path}/invoice.pdf';

    // Copy the generated PDF to the download path.
    await invoiceFile.copy(downloadPath);

    // Convert the File to an XFile using image_picker.
    final XFile xFile = XFile(downloadPath);

    // Show the share dialog to allow the user to download the PDF.
    await Share.shareXFiles([xFile], text: 'Invoice PDF Download');
  }

  void enableFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }
}