import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mh/app/modules/employee/employee_home/controllers/employee_home_controller.dart';
import 'package:mh/app/modules/employee/employee_home/widgets/emloyee_home_promotion_widget.dart';
import 'package:mh/app/modules/employee/employee_home/widgets/employee_home_card_widget.dart';
import 'package:mh/app/modules/employee/employee_home/widgets/employee_location_distance_widget.dart';
import 'package:mh/app/modules/employee/employee_home/widgets/employee_location_widget.dart';
import 'package:mh/app/modules/employee/employee_home/widgets/employee_name_widget.dart';
import 'package:mh/app/modules/employee/employee_home/widgets/employee_restaurant_address_widget.dart';
import 'employee_todays_dashboard_widget.dart';

class EmployeeHomeBodyWidget extends GetWidget<EmployeeHomeController> {
  const EmployeeHomeBodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: RefreshIndicator(
        onRefresh: controller.refreshPage,
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: const Column(
              children: [
                Flexible(
                  flex: 4,
                  child: SingleChildScrollView(
                    primary: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EmployeeNameWidget(),
                        EmployeeHomePromotionWidget(),
                        EmployeeLocationDistanceWidget(),
                        EmployeeRestaurantAddressWidget(),
                        EmployeeHomeCardWidget()
                      ],
                    ),
                  ),
                ),
                Flexible(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          EmployeeTodayDashboardWidget(),
                          EmployeeLocationWidget(),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
