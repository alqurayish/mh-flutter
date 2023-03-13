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
  List<String> languages;
  String higherEducation;
  String licensesNo;
  String emmergencyContact;
  List<String> skills;
  String sourceId;
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
    required this.languages,
    required this.higherEducation,
    required this.licensesNo,
    required this.emmergencyContact,
    required this.skills,
    required this.sourceId,
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
        "languages": languages,
        "higherEducation": higherEducation,
        "licensesNo": licensesNo,
        "emmergencyContact": emmergencyContact,
        "skills": skills,
        "sourceId": sourceId,
        if(referPersonId.isNotEmpty) "referPersonId": referPersonId,
        "employeeExperience": employeeExperience,
      };
}
