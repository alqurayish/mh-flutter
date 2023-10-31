import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mh/app/common/extensions/extensions.dart';
import 'package:mh/app/common/values/my_color.dart';
import 'package:mh/app/common/widgets/time_range_widget.dart';
import 'package:mh/app/modules/client/client_shortlisted/models/add_to_shortlist_request_model.dart';

class EmployeeHiredHistoryDetailsWidget extends StatelessWidget {
  final List<RequestDateModel> requestDateList;
  const EmployeeHiredHistoryDetailsWidget({super.key, required this.requestDateList});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: Get.width,
          decoration: BoxDecoration(color: MyColors.lightCard(Get.context!), borderRadius: BorderRadius.circular(10.0)),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 2.0),
                    decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.only(topRight: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
                        color: MyColors.c_C6A34F),
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(text: 'You have been booked for ', style: MyColors.white.semiBold15),
                      TextSpan(text: '${requestDateList.calculateTotalDays()}', style: MyColors.white.semiBold24),
                      TextSpan(text: ' days', style: MyColors.white.semiBold15),
                    ])),
                  ),
                  SizedBox(
                    height: Get.width*0.9,
                    child: ListView.builder(
                        itemCount: requestDateList.length,
                        shrinkWrap: true,
                        primary: true,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return TimeRangeWidget(requestDate: requestDateList[index], hasDeleteOption: false, onTap: (){});
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
            child: Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: InkWell(
              onTap: () => Get.back(),
              child: const CircleAvatar(
                radius: 12,
                backgroundColor: Colors.red,
                child: Icon(CupertinoIcons.clear, color: MyColors.white, size: 15),
              ),
            ),
          ),
        ))
      ],
    );
  }
}
