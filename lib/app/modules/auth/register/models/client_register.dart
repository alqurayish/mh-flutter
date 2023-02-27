class ClientRegistration {
  String restaurantName;
  String restaurantAddress;
  String email;
  String phoneNumber;
  String sourceFrom;
  String referPersonName;
  String password;

  ClientRegistration({
    required this.restaurantName,
    required this.restaurantAddress,
    required this.email,
    required this.phoneNumber,
    required this.sourceFrom,
    required this.referPersonName,
    required this.password,
  });

  Map<String, String> get toJson => {
        "restaurantName": restaurantName,
        "restaurantAddress": restaurantAddress,
        "email": email,
        "phoneNumber": phoneNumber,
        "sourceFrom": sourceFrom,
        "referPersonName": referPersonName,
        "password": password,
      };
}
