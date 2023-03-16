import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/restaurant_location_controller.dart';

class RestaurantLocationView extends GetView<RestaurantLocationController> {
  const RestaurantLocationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RestaurantLocationView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'RestaurantLocationView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
