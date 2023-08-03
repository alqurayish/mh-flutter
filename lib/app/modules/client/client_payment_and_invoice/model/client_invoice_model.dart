class ClientInvoiceModel {
  String? status;
  int? statusCode;
  List<InvoiceModel>? invoices;
  ClientInvoiceModel({this.status, this.statusCode, this.invoices});

  ClientInvoiceModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['statusCode'];
    if (json['invoices'] != null) {
      invoices = <InvoiceModel>[];
      json['invoices'].forEach((v) {
        invoices!.add(InvoiceModel.fromJson(v));
      });
    }
  }
}

class InvoiceModel {
  String? sId;
  double? amount;
  int? totalEmployee;
  DateTime? fromWeekDate;
  DateTime? toWeekDate;
  DateTime? invoiceDate;
  String? restaurantName;
  String? restaurantAddress;
  String? restaurantEmail;
  String? restaurantPhone;
  String? invoiceNumber;
  String? status;

  InvoiceModel(
      {this.sId,
      this.amount,
      this.totalEmployee,
      this.fromWeekDate,
      this.toWeekDate,
      this.invoiceDate,
      this.restaurantName,
      this.restaurantAddress,
      this.restaurantEmail,
      this.restaurantPhone,
      this.invoiceNumber,
      this.status});

  InvoiceModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    amount = json['amount'] == null ? 0.0 : double.parse(json['amount'].toString());
    totalEmployee = json['totalEmployee'];
    fromWeekDate = json["fromWeekDate"] == null ? null : DateTime.parse(json["fromWeekDate"]);
    toWeekDate = json["toWeekDate"] == null ? null : DateTime.parse(json["toWeekDate"]);
    invoiceDate = json["invoiceDate"] == null ? null : DateTime.parse(json["invoiceDate"]);
    restaurantName = json['restaurantName'];
    restaurantAddress = json['restaurantAddress'];
    restaurantEmail = json['restaurantEmail'];
    restaurantPhone = json['restaurantPhone'];
    invoiceNumber = json['invoiceNumber'];
    status = json['status'];
  }
}
