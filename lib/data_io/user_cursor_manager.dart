import 'package:flutter/material.dart';



UserManager? userManagerHolder;

class UserManager extends ChangeNotifier {

  List<UserCursor> userCursorList = [];

  void joinUser(List<dynamic> userList) {
    for(var element in userList) {
      userCursorList.add(UserCursor(element["userID"], 0.0, 0.0));
    }
    notifyListeners();
  }

  void leaveUser(String userID) {
    userCursorList.removeWhere((userCursor) => userCursor.userID == userID);
    notifyListeners();
  }

  void changePosition(int index, double dx, double dy) {
    userCursorList[index].cursorX = dx;
    userCursorList[index].cursorY = dy;
    notifyListeners();
  }

  int getIndex(String userID) {
    return userCursorList.indexWhere((userCursor) => userCursor.userID == userID);
  }
}


class UserCursor {
  String userID = "";
  double cursorX = 0.0;
  double cursorY = 0.0;

  UserCursor(this.userID, this.cursorX, this.cursorY);

  void changePosition(double dx, double dy) {
    cursorX = dx;
    cursorY = dy;
  }
}