import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_text_input_field.dart';
import '../controllers/restaurant_location_controller.dart';

class RestaurantLocationView extends GetView<RestaurantLocationController> {
  const RestaurantLocationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Scaffold(
      floatingActionButton: Obx(
        ()=> Visibility(
          visible: !controller.fetchCurrentLocation.value && !controller.findAddress.value,
          child: FloatingActionButton.extended(
            onPressed: controller.onConfirmPressed,
            backgroundColor: MyColors.c_C6A34F,
            label: const Text("Confirm"),
          ),
        ),
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

  Widget get _loading => const SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text("Fetch current location"),
          ],
        ),
      );

  Widget get _locationFetchError => Stack(
    children: [
      SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_off,
              size: 50,
              color: MyColors.c_C6A34F,
            ),
            const SizedBox(height: 15),
            Text(
              controller.locationFetchError.value,
              style: MyColors.l111111_dwhite(controller.context!).semiBold15,
            ),
            const SizedBox(height: 15),
            Text(
              "Please turn on you location and try again",
              style: MyColors.l111111_dwhite(controller.context!).regular12,
            ),
          ],
        ),
      ),
      Positioned(
        left: 20,
        top: 50,
        child: GestureDetector(
          onTap: Get.back,
          child: Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: MyColors.c_C6A34F,
            ),
            child: Transform.translate(
              offset: const Offset(2, 0),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
