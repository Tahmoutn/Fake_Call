
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroProvider with ChangeNotifier {

  bool _checkboxValue = false;

  bool get checkboxValue => _checkboxValue;

  void changeCheckboxValue(bool v){
    _checkboxValue = v;
    _acceptingAgreement(v);
    notifyListeners();
  }

  _acceptingAgreement(bool v) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('acceptingAgreement', v);
  }

  Future<bool> getAcceptingAgreementState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('acceptingAgreement') ?? false ;
  }
}
