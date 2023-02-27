import '../../../../enums/user_type.dart';
import '../../../../models/gender.dart';
import '../../../../models/position.dart';

abstract class RegisterInterface {
  void onTermsAndConditionCheck(bool active);

  void onTermsAndConditionPressed();

  void onLoginPressed();

  void onContinuePressed();

  void onUserTypeClick(UserType userType);

  void onPageChange(int index);

  void  onGenderChange(String? gender);

  void  onPositionChange(String? position);
}
