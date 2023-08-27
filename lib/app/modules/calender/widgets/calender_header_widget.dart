import 'package:flutter/material.dart';
import 'package:mh/app/modules/calender/widgets/calender_status_widget.dart';

class CalenderHeaderWidget extends StatelessWidget {
  const CalenderHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CalenderStatusWidget(backgroundColor: Colors.black, title: 'Unavailable'),
        CalenderStatusWidget(backgroundColor: Colors.red, title: 'Booked'),
        CalenderStatusWidget(
          backgroundColor: Colors.yellow,
          title: 'Pending',
        ),
        CalenderStatusWidget(
          backgroundColor: Colors.green,
          title: 'Available',
        ),
      ],
    );
  }
}
