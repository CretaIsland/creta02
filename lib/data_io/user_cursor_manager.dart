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
    userCursorList[index].cursor_x = dx;
    userCursorList[index].cursor_y = dy;
    notifyListeners();
  }

  int getIndex(String userID) {
    return userCursorList.indexWhere((userCursor) => userCursor.userID == userID);
  }
}


class UserCursor {
  String userID = "";
  double cursor_x = 0.0;
  double cursor_y = 0.0;

  UserCursor(this.userID, this.cursor_x, this.cursor_y);

  void changePosition(double dx, double dy) {
    cursor_x = dx;
    cursor_y = dy;
  }
}