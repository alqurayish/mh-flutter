import '../enums/user_type.dart';
import 'client.dart';
import 'employee.dart';

class User {
  UserType? userType;

  Client? client;
  Employee? employee;

  bool get isClient => userType == UserType.client;
  bool get isEmployee => userType == UserType.employee;
  bool get isAdmin => userType == UserType.admin;
  bool get isGuest => userType == UserType.guest;

  User({
    this.userType,
    this.client,
    this.employee,
  });
}
