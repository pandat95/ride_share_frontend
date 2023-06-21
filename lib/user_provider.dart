import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  //String firstName = '';
  String Name='';
  String email='';
  String phone='';
  String token='';
  int stu_id=0;

  void setName(String value1,value2) {
    Name = value1+' '+value2;
    notifyListeners();
  }
  void setEmail(String value) {
    email = value;
    notifyListeners();
  }
  void setPhone(String value) {
    phone = value;
    notifyListeners();
  }
  void setToken(String value) {
    token = value;
    notifyListeners();
  }
  void setStu_id(int value) {
    stu_id = value;
    notifyListeners();
  }

}
