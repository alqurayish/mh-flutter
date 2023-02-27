import 'dart:io';

import 'package:flutter/cupertino.dart';

class CertificateWithFile {
  TextEditingController certificateNameController = TextEditingController();
  File? file;

  CertificateWithFile({
    this.file,
  });
}
