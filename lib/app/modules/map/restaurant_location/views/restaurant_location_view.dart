import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mh/app/common/app_info/app_credentials.dart';
import 'package:mh/app/common/controller/location_controller.dart';

import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_text_input_field.dart';
import '../controllers/restaurant_location_controller.dart';

class RestaurantLocationView extends GetView<RestaurantLocationController> {
  const RestaurantLocationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.onConfirmPressed,
        backgroundColor: MyColors.c_C6A34F,
        label: const Text("Confirm"),
      ),
      body: Obx(
        () => controller.fetchCurrentLocation.value
            ? _loading
            : controller.locationFetchError.value.isNotEmpty
                ? _locationFetchError
                : Stack(
                    children: [
                      GoogleMap(
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        // padding: EdgeInsets.only(top: Get.height / 2),
                        initialCameraPosition: CameraPosition(
                          target: controller.latLng.value,
                          zoom: 14.4746,
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          this.controller.mapController.complete(controller);
                        },
                        onCameraMove: controller.onCameraMove,
                        onCameraIdle: controller.onCameraIdle,
                      ),

                      Transform.translate(
                        offset: const Offset(0, -10),
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 35),
                              child: Image.asset(
                                MyAssets.locationPin,
                                width: 50,
                                height: 50,
                              ),
                            )
                        ),
                      ),

                      Positioned(
                        top: 40,
                        left: 0,
                        right: 0,
                        child: CustomTextInputField(
                          controller: controller.tecAddress,
                          label: "Address",
                          prefixIcon: Icons.add_business,
                          onSubmit: controller.onAddressSearch,
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget get _loading => SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text("Fetch current location"),
          ],
        ),
      );

  Widget get _locationFetchError => Center(
        child: Text(
          controller.locationFetchError.value,
        ),
      );

}
