class EmployeePaymentModel {
  String week;
  String contractor;
  String restaurantName;
  String position;
  double contractorPerHoursRate;
  double totalHours;
  double amount;
  String status;

  EmployeePaymentModel({
    required this.week,
    required this.contractor,
    required this.restaurantName,
    required this.position,
    required this.contractorPerHoursRate,
    required this.totalHours,
    required this.amount,
    required this.status,
  });
}
