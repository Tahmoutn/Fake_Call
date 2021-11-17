
import 'package:flutter/material.dart';

class IntroProvider with ChangeNotifier {

  bool _checkboxValue = false;

  bool get checkboxValue => _checkboxValue;

  void changeCheckboxValue(bool v){
    _checkboxValue = v;
    notifyListeners();
  }
}
