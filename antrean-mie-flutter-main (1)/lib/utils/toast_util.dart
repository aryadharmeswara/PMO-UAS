import 'package:fluttertoast/fluttertoast.dart';

class Toast {
  showToastMessage(String message) {
    Fluttertoast.showToast(msg: message);
  }
}