import 'package:mh/app/models/one_to_one_msg.dart';

import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_appbar.dart';
import '../../../../common/widgets/custom_bottombar.dart';
import '../controllers/one_to_one_chat_controller.dart';

class OneToOneChatView extends GetView<OneToOneChatController> {
  const OneToOneChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              padding: EdgeInsets.symmetric(vertical: 10),
              itemBuilder: (context, index) {
                return _msg(controller.msg[index]);
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
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: TextField(
                              controller: controller.tecController,
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Message",
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

  Widget _bottomBar(BuildContext context) => CustomBottomBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Row(
            children: [

              Expanded(child: SizedBox(
                height: 54,
                child: Align(
                  alignment: Alignment.center,
                  child: TextField(
                    controller: controller.tecController,
                    decoration: InputDecoration(
                      filled: true,
                      border: deco,
                      focusedBorder: deco,
                      enabledBorder: deco,
                      errorBorder: deco,
                      disabledBorder: deco,
                    ),
                  ),
                ),
              ),),

              const SizedBox(width: 10),

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
      );

  OutlineInputBorder get deco => const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(50.0),
        ),
      );

  Widget _msg(Message msg) => msg.senderId == controller.senderId
      ? _senderMsg(msg.text ?? "-")
      : _receiverMsg(msg.text ?? "--");

  Widget _senderMsg(String msg) => Align(
    alignment: Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 14).copyWith(
          top: 5
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
      ),
    ),
  );

  Widget _receiverMsg(String msg) => Align(
    alignment: Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 14).copyWith(
          top: 5
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 4),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: MyColors.c_C6A34F),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(12),
            topLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          )
      ),
      child: Text(
        msg,
      ),
    ),
  );
}
