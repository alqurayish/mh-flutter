import 'dart:async';

import 'package:mh/app/common/controller/app_controller.dart';
import 'package:mh/app/repository/api_helper.dart';
import 'package:socket_io_client/socket_io_client.dart';


import '../../../../common/utils/exports.dart';
import '../../../../enums/chat_with.dart';
import '../../../../models/custom_error.dart';
import '../../../../models/one_to_one_msg.dart';

class OneToOneChatController extends GetxController {
  BuildContext? context;
  final String supportUserId = "6412b261b4706c4eb2163d47";

  final AppController appController = Get.find();
  final ApiHelper apiHelper = Get.find();

  late ChatWith chatWith;
  // late Socket _socket;

  TextEditingController tecController = TextEditingController();

  bool _connectionError = false;

  RxList<Message> msg = <Message>[].obs;

  late String senderId;
  late String? receiverId;

  bool loadFirstTime = true;

  String currentMsgShowDate = "";

  Timer? msgRefreshTimer;

  @override
  void onInit() {
    if(Get.arguments != null) {
      chatWith = Get.arguments[MyStrings.arg.chatWith];
      receiverId = Get.arguments[MyStrings.arg.data];
    }

    senderId = appController.user.value.userId;

    receiverId = chatWith == ChatWith.admin ? supportUserId : receiverId;

    // _socket = io(
    //   'http://44.204.212.181:8000',
    //   OptionBuilder().setTransports(['websocket']).setQuery({
    //     "senderId": senderId,
    //     "receiverId": receiverId,
    //   }).build(),
    // );
    //
    // _connectSocket();

    msgRefreshTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _getMsgTap();
    });

    _getMsgTap();

    super.onInit();
  }

  // void _connectSocket() {
  //   _socket.onConnect((data) {
  //     _connectionError = false;
  //     print('Connection established');
  //   });
  //
  //   _socket.onConnectError((data) {
  //     print('Connect Error: $data');
  //     _connectionError = true;
  //   });
  //
  //   _socket.onDisconnect((data) {
  //     print('Socket.IO server disconnected');
  //     _connectionError = true;
  //   });
  //   _socket.on(
  //     'message',
  //     (data) {
  //       print("new msg come");
  //       print(data);
  //
  //       msg.add(Message.fromJson(data));
  //       msg.refresh();
  //
  //     },
  //   );
  // }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    // _socket.disconnect();
    msgRefreshTimer?.cancel();
    super.onClose();
  }

  String getMsgDate(DateTime msgDate) {
    if(currentMsgShowDate == msgDate.toLocal().toString().split(" ").first) {
      return "";
    }

    currentMsgShowDate = msgDate.toLocal().toString().split(" ").first;
    return currentMsgShowDate;
  }

  double getVerticalMargin(int index) {
    if((index + 1 < msg.length) && (msg[index].senderId != msg[index + 1].senderId)) {
      return 20;
    }

    return 0;
  }

  Future<void> _getMsgTap() async {
    await apiHelper.getMsg(senderId, receiverId!).then((response) {
      response.fold((CustomError customError) {
      }, (OneToOneMsg oneToOneMsg) async {

        if(loadFirstTime) {
          msg.addAll(oneToOneMsg.messages ?? []);
          // msg.value = List.from(msg.reversed);
          msg.refresh();
          loadFirstTime = false;

          return;
        }

        for( Message message in oneToOneMsg.messages ?? [] ) {

          bool found = false;

          for(Message m in msg) {
            if(message.id == m.id) {
              found = true;
              break;
            }
          }

          if(!found) {
            msg..insert(0, message)..refresh();
          }

        }

      });
    });
  }


  Future<void> onSendTap() async {
    if(_connectionError) {
      print("connection error");
      return;
    }


    Map<String, dynamic> data = {
      "senderId": senderId,
      "receiverId": receiverId,
      "text": tecController.text.trim(),
    };

    tecController.clear();

    await apiHelper.sendMsg(data).then((response) {
      response.fold((CustomError customError) {
      }, (r) {
        Message message = Message.fromJson(r.body["details"]);
        msg..insert(0, message)..refresh();

      });
    });

    // _socket.emit('new_message', {
    //   "message": data,
    // });

    // msg.add(tecController.text.trim());
  }
}
