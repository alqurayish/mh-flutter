import 'package:mh/app/common/utils/exports.dart';

class WelcomeBackTextWidget extends StatelessWidget {
  const WelcomeBackTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Welcome Back!', style: MyColors.l5C5C5C_dwhite(context).semiBold20),
        const SizedBox(height: 10),
        Text('Change your password with strong characters', style: MyColors.l5C5C5C_dwhite(context).medium16),
      ],
    );
  }
}
