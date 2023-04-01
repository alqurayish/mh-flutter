import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_appbar.dart';
import '../controllers/one_to_one_chat_controller.dart';

class OneToOneChatView extends GetView<OneToOneChatController> {
  const OneToOneChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar.appbar(
        title: "Chat",
        context: context,
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Coming Soon...',
          style: MyColors.l111111_dtext(context).semiBold22,
        ),
      ),
    );
  }
}
