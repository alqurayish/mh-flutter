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

  String get userId {
    String id = '';

    if(isClient) {
      id = client?.id ?? "Client id get failed";
    } else if(isEmployee) {
      id = employee?.id ?? "Employee id get failed";
    } else if(isAdmin) {
      id = "Admin id not set yet";
    }

    return id;
  }

  User({
    this.userType,
    this.client,
    this.employee,
  });
}
