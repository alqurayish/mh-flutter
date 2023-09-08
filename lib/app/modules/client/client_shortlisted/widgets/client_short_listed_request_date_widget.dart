import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mh/app/common/extensions/extensions.dart';
import 'package:mh/app/common/values/my_assets.dart';
import 'package:mh/app/common/values/my_color.dart';
import 'package:mh/app/common/widgets/custom_appbar_back_button.dart';
import 'package:mh/app/modules/client/client_shortlisted/models/add_to_shortlist_request_model.dart';

class ClientShortListedRequestDateWidget extends StatelessWidget {
  final List<RequestDateModel> requestDateList;
  const ClientShortListedRequestDateWidget({Key? key, required this.requestDateList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomAppbarBackButton(),
                Text('${requestDateList.calculateTotalDays()} Days Selected',
                    style: MyColors.l111111_dwhite(context).semiBold15),
                const Wrap()
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: requestDateList.length,
                  itemBuilder: (context, index) {
                    RequestDateModel requestDate = requestDateList[index];
                    return Container(
                      height: 100,
                      padding: const EdgeInsets.all(10.0),
                      margin: const EdgeInsets.only(top: 15.0),
                      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10.0)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(MyAssets.calender2, height: 20, width: 20),
                                  Text(
                                      ' ${DateFormat('E, dd MMM, yyyy').format(DateTime.parse(requestDate.startDate ?? ''))}  -  ',
                                      style: MyColors.black.medium12),
                                  Text(DateFormat('E, dd MMM, yyyy').format(DateTime.parse(requestDate.endDate ?? '')),
                                      style: MyColors.black.medium12),
                                ],
                              ),
                              InkWell(onTap: () {}, child: const Icon(Icons.remove, color: Colors.red))
                            ],
                          ),
                          _timeRangeWidget(requestDate: requestDate)
                        ],
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget _timeRangeWidget({required RequestDateModel requestDate}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _timeWidget(time: requestDate.startTime ?? ''),
        const Text('  -  '),
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
        children: [Image.asset(MyAssets.clock, height: 20, width: 20), const SizedBox(width: 10), Text(time)],
      ),
    );
  }
}
