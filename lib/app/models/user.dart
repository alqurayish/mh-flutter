import '../enums/user_type.dart';
import 'admin.dart';
import 'client.dart';
import 'employee.dart';

class User {
  UserType? userType;

  Client? client;
  Employee? employee;
  Admin? admin;

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
      id = admin?.id ?? "Admin id get failed";
    }

    return id;
  }

  User({
    this.userType,
    this.client,
    this.employee,
  });
}
