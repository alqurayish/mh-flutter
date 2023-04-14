import 'package:mh/app/common/controller/app_controller.dart';
import 'package:mh/app/repository/api_helper.dart';
import 'package:socket_io_client/socket_io_client.dart';


import '../../../../common/utils/exports.dart';
import '../../../../enums/chat_with.dart';
import '../../../../models/custom_error.dart';
import '../../../../models/one_to_one_msg.dart';

class OneToOneChatController extends GetxController {
  final String supportUserId = "642db18a895938c9567bccef";

  final AppController appController = Get.find();
  final ApiHelper apiHelper = Get.find();

  late ChatWith chatWith;
  late Socket _socket;

  TextEditingController tecController = TextEditingController();

  bool _connectionError = false;

  RxList<Message> msg = <Message>[].obs;

  late String senderId;
  late String? receiverId;

  @override
  void onInit() {
    if(Get.arguments != null) {
      chatWith = Get.arguments[MyStrings.arg.chatWith];
    }

    senderId = appController.user.value.userId;
    receiverId = Get.arguments[MyStrings.arg.data];

    receiverId = chatWith == ChatWith.admin ? supportUserId : receiverId;

    _socket = io(
      'http://44.204.212.181:8000',
      OptionBuilder().setTransports(['websocket']).setQuery({
        "senderId": senderId,
        "receiverId": receiverId,
      }).build(),
    );

    _connectSocket();

    super.onInit();
  }

  void _connectSocket() {
    _socket.onConnect((data) {
      _connectionError = false;
      print('Connection established');
    });

    _socket.onConnectError((data) {
      print('Connect Error: $data');
      _connectionError = true;
    });

    _socket.onDisconnect((data) {
      print('Socket.IO server disconnected');
      _connectionError = true;
    });
    _socket.on(
      'message',
      (data) {
        print("new msg come");
        print(data);

        msg.add(Message.fromJson(data));
        msg.refresh();

      },
    );
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    _socket.disconnect();
    super.onClose();
  }

  Future<void> onSendTap() async {
    if(_connectionError) {
      print("connection error");
      return;
    }

    print(senderId);
    print(receiverId);

    Map<String, dynamic> data = {
      "senderId": senderId,
      "receiverId": receiverId,
      "text": tecController.text.trim(),
    };

    // await apiHelper.sendMsg(data).then((response) {
    //   response.fold((CustomError customError) {
    //
    //     print("msg send error");
    //
    //     // Utils.errorDialog(context!, customError..onRetry = _getClients);
    //
    //   }, (r) {
    //
    //     print(r.body);
    //
    //   });
    // });

    _socket.emit('new_message', {
      "message": data,
    });

    // msg.add(tecController.text.trim());
    tecController.clear();
  }
}
