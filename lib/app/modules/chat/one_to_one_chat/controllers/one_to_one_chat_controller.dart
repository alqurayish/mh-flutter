import 'package:socket_io_client/socket_io_client.dart';


import '../../../../common/utils/exports.dart';
import '../../../../enums/chat_with.dart';

class OneToOneChatController extends GetxController {
  final String supportUserId = "642db18a895938c9567bccef";

  late ChatWith chatWith;
  late Socket _socket;

  TextEditingController tecController = TextEditingController();

  bool _connectionError = false;

  @override
  void onInit() {
    if(Get.arguments != null) {
      chatWith = Get.arguments[MyStrings.arg.chatWith];
    }

    _socket = io(
      'http://localhost:3000',
      OptionBuilder().setTransports(['websocket']).setQuery({
        'username': "TODO USER NAME HERE",
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
      (data) => print("new msg come"),
    );
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onSendTap() {
    if(_connectionError) {
      print("connection error");
      return;
    }

    _socket.emit('message', {
      'message': "hell world",
      'sender': "who am i"
    });

    tecController.clear();
  }
}
