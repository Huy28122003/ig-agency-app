import 'package:flutter/services.dart';

class KeyboardUtils {
  static void showKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.show');
  }

  static void hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }
}
