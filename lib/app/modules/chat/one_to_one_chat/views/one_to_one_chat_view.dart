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
          ListView.builder(
            itemCount: 10,
            itemBuilder: (index, context) {
              return Text("hello");
            },
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
                      Container(
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

              Container(
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
            ],
          ),
        ),
      );

  OutlineInputBorder get deco => const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(50.0),
        ),
      );
}
