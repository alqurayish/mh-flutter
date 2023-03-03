class EmployeeRegistration {

  String name;
  String positionId;
  String gender;
  String dateOfBirth;
  String email;
  String phoneNumber;
  String countryName;
  String presentAddress;
  String permanentAddress;
  List<String> language;
  String higherEducation;
  String licensesNo;
  String emmergencyContact;
  String skillId;
  String sourceFrom;
  String referPersonId;
  int employeeExperience;

  EmployeeRegistration({
    required this.name,
    required this.positionId,
    required this.gender,
    required this.dateOfBirth,
    required this.email,
    required this.phoneNumber,
    required this.countryName,
    required this.presentAddress,
    required this.permanentAddress,
    required this.language,
    required this.higherEducation,
    required this.licensesNo,
    required this.emmergencyContact,
    required this.skillId,
    required this.sourceFrom,
    required this.referPersonId,
    required this.employeeExperience,
  });

  Map<String, dynamic> get toJson => {
        "name": name,
        "positionId": positionId,
        "gender": gender,
        "dateOfBirth": dateOfBirth,
        "email": email,
        "phoneNumber": phoneNumber,
        "countryName": countryName,
        "presentAddress": presentAddress,
        "permanentAddress": permanentAddress,
        "language": language.toString(),
        "higherEducation": higherEducation,
        "licensesNo": licensesNo,
        "emmergencyContact": emmergencyContact,
        "skillId": skillId,
        "sourceFrom": sourceFrom,
        "referPersonId": referPersonId,
        "employeeExperience": employeeExperience,
      };
}
