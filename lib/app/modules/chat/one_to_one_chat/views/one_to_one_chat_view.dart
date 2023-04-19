import 'package:mh/app/models/one_to_one_msg.dart';

import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_appbar.dart';
import '../../../../common/widgets/custom_bottombar.dart';
import '../controllers/one_to_one_chat_controller.dart';

class OneToOneChatView extends GetView<OneToOneChatController> {
  const OneToOneChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: CustomAppbar.appbar(
        title: "Help & Support",
        context: context,
        centerTitle: true,
      ),
      // bottomNavigationBar: _bottomBar(context),
      body: Stack(
        children: [
          Obx(
            () => ListView.builder(
              itemCount: controller.msg.length,
              padding: const EdgeInsets.symmetric(vertical: 10),
              reverse: true,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return _msg(index, controller.msg[index], index == 0);
              },
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomBottomBar(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1.5,
                          height: 54.w,
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(8, 56, 73, 0.5)
                              ),
                              BoxShadow(
                                offset: Offset(0, .5),
                                blurRadius: 1,
                                color: Color(0xFFF9F8F9),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(25),
                            color: MyColors.lnull_d111111(context),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: TextField(
                              controller: controller.tecController,
                              cursorColor: MyColors.l111111_dwhite(context),
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              style: MyColors.l111111_dwhite(context).regular16,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Message",
                                hintStyle: MyColors.text.regular16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 7),
                      GestureDetector(
                        onTap: controller.onSendTap,
                        child: Container(
                          width: 54.w,
                          height: 54.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: MyColors.c_C6A34F,
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Transform.translate(
                              offset: const Offset(-2, 2),
                              child: Image.asset(
                                MyAssets.msgSend,
                                width: 30,
                                height: 30,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  OutlineInputBorder get deco => const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(50.0),
        ),
      );

  Widget _msg(int index, Message msg, bool lastItem) {
    return Column(
      children: [
        // _msgDate(msg.createdAt!),

        msg.senderId == controller.senderId
            ? _senderMsg(index, msg.text ?? "-")
            : _receiverMsg(index, msg.text ?? "--"),

        Visibility(
          visible: lastItem,
          child: const SizedBox(
            height: 100,
          ),
        )
      ],
    );
  }

  Widget _msgDate(DateTime createdAt) {
    String date = controller.getMsgDate(createdAt);
    return Visibility(
      visible: date.isNotEmpty,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            date,
            style:  MyColors.l111111_dwhite(controller.context!).regular10,
          ),
        ),
      ),
    );
  }

  Widget _senderMsg(int index, String msg) => Align(
    alignment: Alignment.centerRight,
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 14).copyWith(
          bottom: 5,
          top: controller.getVerticalMargin(index)
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 4),
      decoration: BoxDecoration(
          color: MyColors.c_C6A34F,
          border: Border.all(color: MyColors.c_C6A34F),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(12),
            topLeft: Radius.circular(12),
            bottomLeft: Radius.circular(12),
          )
      ),
      child: Text(
        msg,
        style: MyColors.white.regular14,
      ),
    ),
  );

  Widget _receiverMsg(int index, String msg) => Align(
    alignment: Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 14).copyWith(
          bottom: 5,
        top: controller.getVerticalMargin(index)
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 4),
      decoration: BoxDecoration(
          color: MyColors.lightCard(controller.context!),
          border: Border.all(color: MyColors.c_C6A34F),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(12),
            topLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          )
      ),
      child: Text(
        msg,
        style: MyColors.l111111_dwhite(controller.context!).regular14,
      ),
    ),
  );
}
