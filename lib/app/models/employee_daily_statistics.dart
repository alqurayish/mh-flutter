class UserDailyStatistics {
  String date;
  String displayCheckInTime;
  String displayCheckOutTime;
  String displayBreakTime;
  String clientCheckInTime;
  String clientCheckOutTime;
  String clientBreakTime;
  String employeeCheckInTime;
  String employeeCheckOutTime;
  String employeeBreakTime;
  String workingHour;
  String amount;

  UserDailyStatistics({
    required this.date,
    required this.displayCheckInTime,
    required this.displayCheckOutTime,
    required this.displayBreakTime,
    required this.clientCheckInTime,
    required this.clientCheckOutTime,
    required this.clientBreakTime,
    required this.employeeCheckInTime,
    required this.employeeCheckOutTime,
    required this.employeeBreakTime,
    required this.workingHour,
    required this.amount,
  });
}
