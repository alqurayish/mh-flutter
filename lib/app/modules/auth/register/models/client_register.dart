class ClientRegistration {
  String restaurantName;
  String restaurantAddress;
  String email;
  String phoneNumber;
  String sourceId;
  String referPersonId;
  String password;
  String lat;
  String long;

  ClientRegistration({
    required this.restaurantName,
    required this.restaurantAddress,
    required this.email,
    required this.phoneNumber,
    required this.sourceId,
    required this.referPersonId,
    required this.password,
    required this.lat,
    required this.long,
  });

  Map<String, dynamic> get toJson => {
        "restaurantName": restaurantName,
        "restaurantAddress": restaurantAddress,
        "email": email,
        "phoneNumber": phoneNumber,
        "sourceId": sourceId,
        if(referPersonId.isNotEmpty) "referPersonId": referPersonId,
        "password": password,
        "lat": lat,
        "long": long,
      };
}
