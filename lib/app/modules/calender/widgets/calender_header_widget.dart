import 'package:mh/app/common/utils/exports.dart';
import 'package:mh/app/modules/calender/widgets/calender_status_widget.dart';

class CalenderHeaderWidget extends StatelessWidget {
  const CalenderHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CalenderStatusWidget(backgroundColor: MyColors.l111111_dwhite(context), title: 'Unavailable'),
            const SizedBox(height: 10),
            const CalenderStatusWidget(backgroundColor: Colors.red, title: 'Booked')
          ],
        ),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CalenderStatusWidget(
              backgroundColor: Colors.green,
              title: 'Available',
            ),
            SizedBox(height: 10),
            CalenderStatusWidget(
              backgroundColor: Colors.amber,
              title: 'Pending',
            )
          ],
        ),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CalenderStatusWidget(backgroundColor: MyColors.c_C6A34F, title: 'Selected'),
            SizedBox(height: 10),
            CalenderStatusWidget(backgroundColor: Colors.grey, title: 'Disabled')
          ],
        ),
      ],
    );
  }
}
