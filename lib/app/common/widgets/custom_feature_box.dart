import '../style/my_decoration.dart';
import '../utils/exports.dart';

class CustomFeatureBox extends StatelessWidget {
  final String title;
  final String icon;
  final bool visibleMH;
  final Function() onTap;

  const CustomFeatureBox({
    Key? key,
    required this.title,
    required this.icon,
    this.visibleMH = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 156.h,
      decoration: MyDecoration.cardBoxDecoration(context: context),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                icon,
                width: 70.w,
                height: 70.w,
              ),
              SizedBox(height: 6.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Visibility(
                    visible: visibleMH,
                    child: Text(
                      MyStrings.mh.tr,
                      style: MyColors.c_C6A34F.semiBold16,
                    ),
                  ),

                  Text(
                    title,
                    style: MyColors.l111111_dwhite(context).medium16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
