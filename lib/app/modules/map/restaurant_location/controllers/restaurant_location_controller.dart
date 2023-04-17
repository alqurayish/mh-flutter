import 'dart:async';

import 'package:geocoder2/geocoder2.dart';
import 'package:geocoder_buddy/geocoder_buddy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mh/app/repository/api_helper.dart';

import '../../../../common/controller/location_controller.dart';
import '../../../../common/utils/exports.dart';
import '../../../../models/address_to_lat_lng.dart';
import '../../../../models/lat_long_to_address.dart';
import '../../../auth/register/controllers/register_controller.dart';

class RestaurantLocationController extends GetxController {

  BuildContext? context;

  // current location
  Position? location;

  Set<Marker> markersList = {};


  final Completer<GoogleMapController> mapController = Completer<GoogleMapController>();

  RxBool fetchCurrentLocation = true.obs;
  RxString locationFetchError = "".obs;

  RxBool findAddress = false.obs;

  final RegisterController _registerController = Get.find();
  final ApiHelper _apiHelper = Get.find();

  /// default mh lat long
  Rx<LatLng> latLng = const LatLng(
    LocationController.mhLat,
    LocationController.mhLong,
  ).obs;

  TextEditingController tecAddress = TextEditingController();

  @override
  void onInit() {
    _getCurrentLocation();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onAddressSearch() {
    findAddress.value = true;
    _apiHelper.addressToLatLng(tecAddress.text.trim()).then((value) {
      findAddress.value = false;

      value.fold((l) {
        tecAddress.text = "${latLng.value.latitude}, ${latLng.value.longitude}";
      }, (r) async {
        AddressToLatLng addressToLatLng = AddressToLatLng.fromJson(r.body[0]);
        // tecAddress.text = addressToLatLng.displayName ?? "${latLng.value.latitude}, ${latLng.value.longitude}";

        latLng.value = LatLng(
          double.parse(addressToLatLng.lat ?? "0"),
          double.parse(addressToLatLng.lon ?? "0"),
        );

        latLng.refresh();

        final GoogleMapController controller = await mapController.future;
        controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(latLng.value.latitude, latLng.value.longitude),
          zoom: 14.4746,
        )));
      });
    });
  }

  void onConfirmPressed() {
    _registerController.restaurantLat = latLng.value.latitude;
    _registerController.restaurantLong = latLng.value.longitude;
    _registerController.restaurantAddressFromMap.value = tecAddress.text.trim();
    _registerController.tecRestaurantAddress.text = tecAddress.text.trim();
    Get.back();
  }

  void onCameraMove(CameraPosition? position) {
    if(position?.target != null && latLng.value != position?.target) {
      latLng.value = position!.target;
      latLng.refresh();
    }
  }

  void onCameraIdle() {
    tecAddress.text = "Fetching address...";
    findAddress.value = true;
    _apiHelper.latLngToAddress(latLng.value.latitude, latLng.value.longitude).then((value) {
      findAddress.value = false;

      value.fold((l) {
        tecAddress.text = "${latLng.value.latitude}, ${latLng.value.longitude}";
      }, (r) {
        tecAddress.text = r.displayName ?? "${latLng.value.latitude}, ${latLng.value.longitude}";
      });
    });
  }

  void _getCurrentLocation () {
    LocationController.determinePosition().then((value) {

      value.fold((l) {
        locationFetchError.value = l.msg;
      }, (Position position) {
        location = position;

        latLng.value = LatLng(location!.latitude, location!.longitude);

        markersList.add(
          Marker(
            markerId: const MarkerId('0'),
            position: latLng.value,
          ),
        );
      });

      fetchCurrentLocation.value = false;

    });
  }



}
