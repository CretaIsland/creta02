
import 'package:creta02/common/util/config.dart';
import 'package:creta02/common/util/exceptions.dart';
import 'package:creta02/common/util/logger.dart';
import 'package:creta02/data_io/user_cursor_manager.dart';
import 'package:creta02/hycop/socket/socket_utils.dart';
// ignore: depend_on_referenced_packages
import 'package:socket_io_client/socket_io_client.dart';


class SocketClient {

  late Socket socket;
  late String roomID;

  
  void initialize() {
    socket = io(
      myConfig!.serverConfig!.socketConnInfo.serverUrl + myConfig!.serverConfig!.socketConnInfo.serverPort.toString(),  // url:port
      <String, dynamic> {
        "transports" : ["websocket"],
        "autoConnect" : false
      }
    );
  }

  Future<void> connectServer(String contentBookID) async {

    roomID = SocketUtils.getRoomID(contentBookID);
  

    socket.connect().onConnectError((err) => 
      throw CretaException(message: err.toString())
    );

    socket.emit("join", {"roomID" : roomID, "userID" : "test@gmail.com"});


    socket.on("connect", (data) {
      logger.finest("connect");
    });
    socket.on("disconnect", (data) {
      logger.finest("disconnect");
      disconnect();
    });
    socket.on("joinUser", (data) {
      joinUser(data);
    });
    socket.on("leaveUser", (data) {
      leaveUser(data);
    });
    socket.on("changeData", (data) {
      changeData();
    });
    socket.on("changeCursor", (data) {
      changeCursor(data);
    });

  }


  void joinUser(Map<String, dynamic> data) {
    userManagerHolder!.joinUser(data["userList"]);
  }

  void leaveUser(Map<String, dynamic> data) {
    userManagerHolder!.leaveUser(data["userID"]);
  }

  void updateData() {
    socket.emit("updateData", {
      "roomID" : roomID,
      "userID" : "test@gmail.com",
      "message" : "",
      "changeDate" : DateTime.now().toString().substring(0, 16)
    });
  }

  void changeData() {
    // reload Data
  }

  void moveCursor(double dx, double dy) {
    socket.emit("moveCursor", {
      "roomID" : roomID,
      "userID" : "test@gmail.com",
      "cursor_x" : dx,
      "cursor_y" : dy
    });
  }

  void changeCursor(Map<String, dynamic> data) {
    userManagerHolder!.changePosition(
      userManagerHolder!.getIndex(data["userID"]),
      data["cursor_x"],
      data["cursor_y"]
    );
  }

  void disconnect() {
    socket.disconnect().onError((err) {
      throw CretaException(message: err.toString());
    });
    socket.destroy();
  }


}