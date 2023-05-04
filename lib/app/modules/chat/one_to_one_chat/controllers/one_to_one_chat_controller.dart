import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mh/app/common/controller/app_controller.dart';
import 'package:mh/app/models/employee_full_details.dart';
import 'package:mh/app/repository/api_helper.dart';
import 'package:socket_io_client/socket_io_client.dart';


import '../../../../common/utils/exports.dart';
import '../../../../enums/chat_with.dart';
import '../../../../models/custom_error.dart';
import '../../../../models/one_to_one_msg.dart';
import 'package:dio/dio.dart';


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

  CollectionReference onChatScreenCollection = FirebaseFirestore.instance.collection('onChatScreen');
  CollectionReference onUnreadCollection = FirebaseFirestore.instance.collection('unreadMsg');

  RxBool isReceiverOnline = false.obs;
  String receiverToken = "";
  String receiverName = "";

  List<dynamic> adminUnread = [];
  List<dynamic> clientUnread = [];
  List<dynamic> employeeUnread = [];

  @override
  void onInit() {
    if(Get.arguments != null) {
      chatWith = Get.arguments[MyStrings.arg.chatWith];
      receiverId = Get.arguments[MyStrings.arg.receiverId];
      receiverName = Get.arguments[MyStrings.arg.receiverName] ?? "";
    }

    senderId = appController.user.value.userId;

    receiverId = chatWith == ChatWith.admin ? supportUserId : receiverId;

    _getReceiverToken();

    _updateChatScreenStatus(true);

    _trackBothUserAreOnline();


    _updateUnreadMsgToRead();

    _getUnreadMsg();

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
    _updateChatScreenStatus(false);
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

  Future<void> _getReceiverToken() async {
    await apiHelper.employeeFullDetails(receiverId!).then((response) {

      response.fold((l) {
        Logcat.msg(l.msg);
      }, (EmployeeFullDetails r) {
        receiverToken = r.details?.pushNotificationDetails?.fcmToken ?? "";
        print("receiverToken = $receiverToken");
      });

    });
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
        _sendMsgNotification(message.text!);
      });
    });

    // _socket.emit('new_message', {
    //   "message": data,
    // });

    // msg.add(tecController.text.trim());
  }

  void _updateChatScreenStatus(bool active) {
    onChatScreenCollection.doc(senderId).set({
      "active" : active,
    });
  }

  void _trackBothUserAreOnline() {

    onChatScreenCollection.doc(receiverId).get().then((value) {
      if(value.exists) {
        onChatScreenCollection.doc(receiverId).snapshots().listen((DocumentSnapshot doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          isReceiverOnline.value = data["active"];
        });
      } else {
        print("user not enter in chat screen");
      }
    });

  }

  Future<void> _sendMsgNotification(String s) async {
    _addUnreadMsg();
    if(!isReceiverOnline.value && receiverToken.isNotEmpty) {
      final Dio dio = Dio();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "key=AAAAwaSQwc4:APA91bH5pzh_j3LHx3O2oKcn557nkJ6juoizHpe-ltzai3t1I2ChyzYSXLK3g_LZBNP1MiYHS_Wll3x0ED1Tj9zCAaA8G5jeY_qHsq_Zx7RiO-cdS2Mu6H-az-WbrGwBfsCdO8NRohNg";


      final response = await dio.post(
        'https://fcm.googleapis.com/fcm/send',
        data: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'title': '${appController.user.value.userName} send a massage',
              'body': s,
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'ONE_TO_ONE_CHAT',
              'send_from': senderId,
              'sender_name': appController.user.value.userName,
              'chat_with': appController.user.value.userRole
            },
            'to': receiverToken,
          },
        ),
      );

      print("push result = ${response.data}");
    } else {
      print("isReceiverOnline.value = ${isReceiverOnline.value}");
      print("receiverToken = $receiverToken");
    }
  }

  void _updateUnreadMsgToRead() {
    onUnreadCollection.doc(senderId).get().then((DocumentSnapshot doc) {
      if(doc.exists) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

        List admin = data["admin"];
        List client = data["client"];
        List employee = data["employee"];

        admin.remove(receiverId);
        client.remove(receiverId);
        employee.remove(receiverId);

        onUnreadCollection.doc(senderId).set({
          "admin" : admin,
          "client" : client,
          "employee" : employee,
        }, SetOptions(merge: true));

      }
    });
  }

  void _getUnreadMsg() {
    onUnreadCollection.doc(receiverId).get().then((DocumentSnapshot doc) {
      if(doc.exists) {
        onUnreadCollection.doc(receiverId).snapshots().listen((event) {
          Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
          adminUnread = data["admin"];
          clientUnread = data["client"];
          employeeUnread = data["employee"];

          print("snapshot");
          print(adminUnread);
          print(clientUnread);
          print(employeeUnread);
        });
      }
    });
  }

  void _addUnreadMsg() {
    if(appController.user.value.isAdmin) {
      if(!adminUnread.contains(appController.user.value.userId)) {
        adminUnread.add(appController.user.value.userId);
        _updateUnreadMsg();
      }
    }
    else if(appController.user.value.isClient) {
      if(!clientUnread.contains(appController.user.value.userId)) {
        clientUnread.add(appController.user.value.userId);
        _updateUnreadMsg();
      }
    }
    else if(appController.user.value.isEmployee) {
      if(!employeeUnread.contains(appController.user.value.userId)) {
        employeeUnread.add(appController.user.value.userId);
        _updateUnreadMsg();
      }
    }
  }

  void _updateUnreadMsg() {
    print("before update");
    print(adminUnread);
    print(clientUnread);
    print(employeeUnread);

    onUnreadCollection.doc(receiverId).set({
      "admin" : adminUnread,
      "client" : clientUnread,
      "employee" : employeeUnread,
    }, SetOptions(merge: true));
  }
}
