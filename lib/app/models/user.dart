import '../enums/user_type.dart';
import 'client.dart';

class User {
  UserType? userType;

  Client? client;

  bool get isClient => userType == UserType.client;
  bool get isEmployee => userType == UserType.employee;
  bool get isAdmin => userType == UserType.admin;

  User({
    this.userType,
    this.client,
  });
}
