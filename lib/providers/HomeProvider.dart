import 'package:contacts_service/contacts_service.dart';
import 'package:fake_call/Services/TimeCalculator.dart';
import 'package:fake_call/UI/Home/Home.dart';
import 'package:fake_call/database/database.dart';
import 'package:fake_call/model/DataBaseModel.dart';
import 'package:fake_call/notifications/notifications_api.dart';
import 'package:flutter/material.dart';

const String NAME_TXT = "Contact name";
const String NUMBER_TXT = "Phone number";
class HomeProvider with ChangeNotifier {

  bool _showAdsCond = true;

  bool _afterFiveMinuets = false;
  bool _afterThirtyMinuets = false;
  bool _afterOneHour = false;
  bool _afterFiveHours = false;

  String _nameOfFirstCard = NAME_TXT;
  String _numberOfFirstCard = NUMBER_TXT;

  String _nameOfSecondCard = NAME_TXT;
  String _numberOfSecondCard = NUMBER_TXT;

  String _nameOfThirdCard = NAME_TXT;
  String _numberOfThirdCard = NUMBER_TXT;

  String _nameOfForthCard = NAME_TXT;
  String _numberOfForthCard = NUMBER_TXT;

  String get nameOfFirstCard => _nameOfFirstCard;
  String get numberOfFirstCard => _numberOfFirstCard;

  String get nameOfSecondCard => _nameOfSecondCard;
  String get numberOfSecondCard => _numberOfSecondCard;

  String get nameOfThirdCard => _nameOfThirdCard;
  String get numberOfThirdCard => _numberOfThirdCard;

  String get nameOfForthCard => _nameOfForthCard;
  String get numberOfForthCard => _numberOfForthCard;

  Contact _contact;
  int _homeRadioGroup;
  String _message;
  TextEditingController _phoneController = new TextEditingController();

  Contact get contact => _contact;
  int get homeRadioGroup => _homeRadioGroup;
  String get message => _message;
  TextEditingController get phoneController => _phoneController;

  bool get afterFiveMinuets => _afterFiveMinuets;
  bool get afterThirtyMinuets => _afterThirtyMinuets;
  bool get afterOneHour => _afterOneHour;
  bool get afterFiveHours => _afterFiveHours;

  bool get showAdsCond => _showAdsCond;

  void setAdsCondExpired(bool value){
    this._showAdsCond = value;
    notifyListeners();
  }


  List<DataBaseModel> list = [null,null,null,null];
  BuildContext context;

  Future<List<DataBaseModel>> _databaseModel () async {
    await DatabaseHelper().db;
    var dbHelper =  DatabaseHelper();
    return dbHelper.getCalls();
  }

  void initProviderState(BuildContext context,bool fromInitState) async {
    this.context = context;
     await _databaseModel().then((value){
       if(fromInitState) NotificationApi.cancelAll();
      value.forEach((element) {
        print(element.id);
        switch(element.id){
          case 1 : {
            list.isNotEmpty ? list.remove(list[0])
                : null;
            list.insert(0, element);
            if(fromInitState) setCardInformationFromDb(element);
            break;
          }
          case 2 : {
            list.isNotEmpty ? list.remove(list[1])
                : null;
            list.insert(1, element);
            if(fromInitState) setCardInformationFromDb(element);
            break;
          }
          case 3 : {
            list.isNotEmpty ? list.remove(list[2])
                : null;
            list.insert(2, element);
            if(fromInitState) setCardInformationFromDb(element);
            break;
          }
          case 4 : {
            list.isNotEmpty ? list.remove(list[3])
                : null;
            list.insert(3, element);
            if(fromInitState) setCardInformationFromDb(element);
            break;
          }
        }
        notifyListeners();
      });
    });
  }

  setCardInformationFromDb(DataBaseModel element){

    list.forEach((elements) {
      if(elements != null){
        switch(element.id){
          case 1 :{
            if(
            TimeCalculator().isAfter(element.time).values.first &&
            TimeCalculator().isAfter(element.time).values.last[0] == 0 &&
            TimeCalculator().isAfter(element.time).values.last[1] <= 5
            ){
              _afterFiveMinuets = true;
              _numberOfFirstCard = element.number;
              _nameOfFirstCard = element.name;
              print('${TimeCalculator().isAfter(element.time).values.last[0]}' '${ 5 - TimeCalculator().isAfter(element.time).values.last[1]}');
              Home().createState().startScheduledCall(0,
                  Duration(
                    hours: TimeCalculator().isAfter(element.time).values.last[0],
                    minutes: 5 - TimeCalculator().isAfter(element.time).values.last[1]),context,true);
            }else{
                 Home().createState().deleteDataFromSqfLite(element.id - 1, context);
                 Home().createState().cancelTimerAndNotifications(0);
            }
            break;
          }
          case 2 :{
            if(
            TimeCalculator().isAfter(element.time).values.first &&
                TimeCalculator().isAfter(element.time).values.last[0] == 0 &&
                TimeCalculator().isAfter(element.time).values.last[1] <= 30
            ){
              _afterThirtyMinuets = true;
              _numberOfSecondCard = element.number;
              _nameOfSecondCard = element.name;
              Home().createState().startScheduledCall(1,
                  Duration(
                      hours: TimeCalculator().isAfter(element.time).values.last[0],
                      minutes: 30 - TimeCalculator().isAfter(element.time).values.last[1]),context,true);
            }else{
              Home().createState().deleteDataFromSqfLite(element.id - 1, context);
              Home().createState().cancelTimerAndNotifications(1);
            }
            break;
          }
          case 3 :{
            if(
            TimeCalculator().isAfter(element.time).values.first &&
                TimeCalculator().isAfter(element.time).values.last[0] == 0 &&
                TimeCalculator().isAfter(element.time).values.last[1] <= 59
            ){
              _afterOneHour = true;
              _numberOfThirdCard = element.number;
              _nameOfThirdCard = element.name;
              Home().createState().startScheduledCall(2,
                  Duration(
                      hours: TimeCalculator().isAfter(element.time).values.last[0],
                      minutes: 59 - TimeCalculator().isAfter(element.time).values.last[1]),context,true);
            }else{
              Home().createState().deleteDataFromSqfLite(element.id - 1, context);
              Home().createState().cancelTimerAndNotifications(2);
            }
            break;
          }
          case 4 :{
            if(
            TimeCalculator().isAfter(element.time).values.first &&
                TimeCalculator().isAfter(element.time).values.last[0] <= 4 &&
                TimeCalculator().isAfter(element.time).values.last[1] <= 59
            ){
              _afterFiveHours = true;
              _numberOfForthCard = element.number;
              _nameOfForthCard = element.name;
              Home().createState().startScheduledCall(3,
                  Duration(
                      hours: 4 - TimeCalculator().isAfter(element.time).values.last[0],
                      minutes: 59 - TimeCalculator().isAfter(element.time).values.last[1]),context,true);
            }else{
              Home().createState().deleteDataFromSqfLite(element.id - 1, context);
              Home().createState().cancelTimerAndNotifications(3);
            }
            break;
          }
        }
      }else{
      }
      notifyListeners();
    });
  }

  void changeSwitchValue(int index,bool v){

    switch(index){
      case 0 : _afterFiveMinuets = v;
      break;
      case 1 : _afterThirtyMinuets = v;
      break;
      case 2 : _afterOneHour = v;
      break;
      case 3 : _afterFiveHours = v;
      break;
    }
    notifyListeners();
  }

  bool getCardStatusIndex(int index){
    switch(index){
      case 0 : return _afterFiveMinuets;
      break;
      case 1 : return _afterThirtyMinuets;
      break;
      case 2 : return _afterOneHour;
      break;
      case 3 : return _afterFiveHours;
    }
  }

  void setMessageError(String message){
    _message = message;
    notifyListeners();
  }

  void setCardInformation(int index){
    switch(index){
      case 0 : {
        if(_phoneController.text.isEmpty){
          if(_contact != null){
            _nameOfFirstCard = _contact.displayName;
            _numberOfFirstCard = _contact.phones.first.value;
          }
        } else {
          _nameOfFirstCard = _phoneController.text;
          _numberOfFirstCard = _phoneController.text;
        }
        break;
      }
      case 1 : {
        if(_phoneController.text.isEmpty){
          if(_contact != null){
            _nameOfSecondCard = _contact.displayName;
            _numberOfSecondCard = _contact.phones.first.value;
          }
        } else {
          _nameOfSecondCard = _phoneController.text;
          _numberOfSecondCard = _phoneController.text;
        }
        break;
      }
      case 2 : {
        if(_phoneController.text.isEmpty){
          if(_contact != null){
            _nameOfThirdCard = _contact.displayName;
            _numberOfThirdCard = _contact.phones.first.value;
          }
        } else {
          _nameOfThirdCard = _phoneController.text;
          _numberOfThirdCard = _phoneController.text;
        }
        break;
      }
      case 3 : {
        if(_phoneController.text.isEmpty){
          if(_contact != null){
            _nameOfForthCard = _contact.displayName;
            _numberOfForthCard = _contact.phones.first.value;
          }
        } else {
          _nameOfForthCard = _phoneController.text;
          _numberOfForthCard = _phoneController.text;
        }
        break;
      }
    }
    notifyListeners();
  }

  void setContact(Contact contact){
    _contact = contact;
    notifyListeners();
  }

  void setRadioGroupValue(int v){
    _homeRadioGroup = v;
    notifyListeners();
  }

  void clearPhoneController(){
    _phoneController = new TextEditingController();
    notifyListeners();
  }

  void cleanContact(){
    _contact = null;
    notifyListeners();
  }

  void cancelScheduledCall(int index){
    switch(index){
      case 0 : {
        _afterFiveMinuets = false;
        _nameOfFirstCard = NAME_TXT ;
        _numberOfFirstCard = NUMBER_TXT;
        break;
      }
      case 1 : {
        _afterThirtyMinuets = false;
        _nameOfSecondCard = NAME_TXT;
        _numberOfSecondCard = NUMBER_TXT;
        break;
      }
      case 2 : {
        _afterOneHour = false;
        _nameOfThirdCard = NAME_TXT;
        _numberOfThirdCard = NUMBER_TXT;
        break;
      }
      case 3 : {
        _afterFiveHours = false;
        _nameOfForthCard = NAME_TXT;
        _numberOfForthCard = NUMBER_TXT;
        break;
      }
    }
    notifyListeners();
  }

}