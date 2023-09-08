import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:mh/app/common/utils/exports.dart';
import 'package:mh/app/common/widgets/custom_appbar_back_button.dart';
import 'package:mh/app/modules/client/client_shortlisted/models/add_to_shortlist_request_model.dart';
import '../controllers/employee_booked_history_details_controller.dart';

class EmployeeBookedHistoryDetailsView extends GetView<EmployeeBookedHistoryDetailsController> {
  const EmployeeBookedHistoryDetailsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.theme.scaffoldBackgroundColor,
      child: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                  stretch: true,
                  iconTheme: const IconThemeData(
                    color: MyColors.white, //change your color here
                  ),
                  pinned: true,
                  floating: false,
                  leading: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: CustomAppbarBackButton(),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  expandedHeight: MediaQuery.of(context).size.height * 0.3,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: ClipPath(
                        clipper: MyClipper(),
                        child: Image.asset(MyAssets.restaurant,
                            fit: BoxFit.cover,
                            colorBlendMode: BlendMode.darken,
                            color: MyColors.black.withOpacity(0.6))),
                  )),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                        width: Get.width * 0.8,
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0), color: MyColors.c_C6A34F),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('You have been booked for ', style: MyColors.white.semiBold15),
                            Text('${controller.bookingHistory.requestDateList?.calculateTotalDays()}',
                                style: MyColors.white.semiBold24),
                            Text(' days', style: MyColors.white.semiBold15),
                          ],
                        )),
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 100,
                        autoPlay: controller.bookingHistory.requestDateList!.length > 1 ? true : false,
                        viewportFraction: 0.99,
                      ),
                      items: controller.bookingHistory.requestDateList!.map((RequestDateModel url) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          width: double.infinity,
                          child: Container(
                            height: 100,
                            padding: const EdgeInsets.all(10.0),
                            margin: const EdgeInsets.only(top: 15.0, right: 15.0, left: 15.0),
                            decoration:
                                BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10.0)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(MyAssets.calender2, height: 20, width: 20),
                                    Text(
                                        ' ${DateFormat('E, dd MMM, yyyy').format(DateTime.parse(url.startDate ?? ''))}  -  ',
                                        style: MyColors.black.medium12),
                                    Text(DateFormat('E, dd MMM, yyyy').format(DateTime.parse(url.endDate ?? '')),
                                        style: MyColors.black.medium12),
                                  ],
                                ),
                                _timeRangeWidget(requestDate: url)
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 50),
                    Material(
                      child: ListTile(
                        minVerticalPadding: 0.0,
                        minLeadingWidth: 0.0,
                        isThreeLine: true,
                        leading: const CircleAvatar(
                          backgroundColor: MyColors.c_C6A34F,
                          child: Icon(Icons.notifications_active_outlined, color: MyColors.white),
                        ),
                        title: Text('${controller.bookingHistory.text}',
                            style: MyColors.l111111_dwhite(context).semiBold15),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(controller.bookingHistory.restaurantAddress ?? ''),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Material(
                      child: ListTile(
                          minVerticalPadding: 0.0,
                          minLeadingWidth: 0.0,
                          leading: const CircleAvatar(
                            backgroundColor: Colors.teal,
                            child: Icon(Icons.location_city, color: MyColors.white),
                          ),
                          title: Text(
                              'This restaurant is situated at a distance of ${(controller.employeeHomeController.restaurantDistanceFromEmployee(targetLat: double.parse(controller.bookingHistory.hiredByLat.toString()), targetLng: double.parse(controller.bookingHistory.hiredByLong.toString())) / 1609).toStringAsFixed(2)} miles from your location',
                              style: MyColors.l111111_dwhite(context).semiBold15)),
                    ),
                  ],
                ),
              )
            ],
          ),
          Positioned.fill(
              child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: Material(
                      child: InkWell(
                        onTap: () => controller.employeeHomeController
                            .updateNotification(id: controller.bookingHistory.id ?? '', hiredStatus: "ALLOW"),
                        child: Container(
                          color: MyColors.c_C6A34F,
                          height: 50,
                          child: Center(child: Text('ALLOW ALL', style: MyColors.white.semiBold15)),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Material(
                      child: InkWell(
                        onTap: () => controller.employeeHomeController
                            .updateNotification(id: controller.bookingHistory.id ?? '', hiredStatus: "DENY"),
                        child: Container(
                          color: Colors.red,
                          height: 50,
                          child: Center(child: Text('DENY ALL', style: MyColors.white.semiBold15)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }

  Widget _timeRangeWidget({required RequestDateModel requestDate}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _timeWidget(time: requestDate.startTime ?? ''),
        Container(width: 20, color: Colors.grey, height: 2),
        _timeWidget(time: requestDate.endTime ?? ''),
      ],
    );
  }

  Widget _timeWidget({required String time}) {
    return Container(
      width: 130,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
      decoration: BoxDecoration(
          color: MyColors.lightCard(Get.context!),
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(5.0)),
      child: Row(
        children: [
          Image.asset(MyAssets.clock, height: 20, width: 20),
          const SizedBox(width: 10),
          Text(time, style: MyColors.black.medium12)
        ],
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(Get.width / 2, size.height, Get.width, size.height - 40);
    path.lineTo(Get.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
