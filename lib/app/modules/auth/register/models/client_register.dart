class ClientRegistration {
  String restaurantName;
  String restaurantAddress;
  String email;
  String phoneNumber;
  String sourceId;
  String referPersonId;
  String password;

  ClientRegistration({
    required this.restaurantName,
    required this.restaurantAddress,
    required this.email,
    required this.phoneNumber,
    required this.sourceId,
    required this.referPersonId,
    required this.password,
  });

  Map<String, dynamic> get toJson => {
        "restaurantName": restaurantName,
        "restaurantAddress": restaurantAddress,
        "email": email,
        "phoneNumber": phoneNumber,
        "sourceId": sourceId,
        if(referPersonId.isNotEmpty) "referPersonId": referPersonId,
        "password": password,
      };
}
