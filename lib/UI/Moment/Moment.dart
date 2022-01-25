import 'package:callkeep/callkeep.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:fake_call/Services/CallServices.dart';
import 'package:fake_call/Services/PermissionsHandler.dart';
import 'package:fake_call/UI/Home/Home.dart';
import 'package:fake_call/View/ContactInfoAlert.dart';
import 'package:fake_call/database/HistoryDatabase.dart';
import 'package:fake_call/model/HistoriesDatabaseModel.dart';
import 'package:fake_call/monetization/AdsManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_applovin_max/banner.dart';
import 'package:flutter_applovin_max/flutter_applovin_max.dart';

final FlutterCallkeep _callKeep = FlutterCallkeep();

class Moment extends StatefulWidget {
  @override
  _MomentState createState() => _MomentState();
}

class _MomentState extends State<Moment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Contact _contact;
  int _value;
  String _message;
  TextEditingController _phoneController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _pickContact() async {
    try {
      await ContactsService.openDeviceContactPicker(
              iOSLocalizedLabels: iOSLocalizedLabels)
          .then((value) {
        if (value.phones.isEmpty) {
          setState(() {
            _message = 'This contact does not have phone';
          });
          return null;
        }
        setState(() {
          _message = null;
          _contact = value;
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    FlutterApplovinMax.initInterstitialAd(interstitialAdUnitId());
    super.initState();
  }

  initInterstitialAd() async{
    try{
      FlutterApplovinMax.isInterstitialLoaded(AdsManager().listener).then((value){
        if (value) {
          FlutterApplovinMax.showInterstitialVideo((AppLovinAdListener event) => AdsManager().listener(event));
        }
      });
    }catch(e){

    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.green.withOpacity(0.05),
        elevation: 5,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Receive now'),
        titleTextStyle: TextStyle(
            fontSize: 20,
            color: Colors.green,
            fontFamily: 'myFont',
            fontWeight: FontWeight.w600),
        leading: SizedBox(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: Tooltip(
              message: 'Back',
              child: SizedBox(
                height: 40,
                width: 40,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      key: _scaffoldKey,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.only(bottom: 40.0),
        child: Form(
          key: _formKey,
          child: Column(
            // physics: BouncingScrollPhysics(),
            // padding: const EdgeInsets.only(bottom: 20.0),
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Card(
                margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                shadowColor: Colors.green.withOpacity(0.4),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                ),
                child: Container(
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                            color: Colors.green.shade50,
                            width: 0.8)),
                  ),
                  // height: BannerSize.STANDARD.height * 2.4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                top: 8.0,
                                left: 18,
                                right: 8.0,
                                bottom: 10),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(10),
                                ),
                              ),
                            ),
                            child: Text(
                              'Announcement.',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.green,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.warning_rounded,
                            color: Colors.green,
                            size: 20,
                          )
                        ],
                      ),
                      Container(
                        // height: BannerSize.STANDARD.height * 1.0,
                        // width: BannerSize.STANDARD.width * 1.0,
                        padding: EdgeInsets.all(0),
                        child:
                        BannerMaxView(
                                (AppLovinAdListener event) =>
                                    AdsManager().listener(event),
                            BannerAdSize.banner,
                            momentBannerAdUnitId()
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Divider(
                  height: 30,
                  indent: 20,
                  endIndent: 20,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.36,
                child:
                Image.asset('assets/images/call_illustation2.png'),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 12.0),
              //   child: Container(
              //     alignment: Alignment.center,
              //     child: adWidget,
              //     width: myBanner.size.width.toDouble(),
              //     height: myBanner.size.height.toDouble(),
              //   ),
              // ),
              ListTile(
                title: _contact == null
                    ? Text('Select contact')
                    : Text('${_contact.displayName}'),
                subtitle: _message == null
                    ? _contact == null
                    ? null
                    : Text('${_contact.phones.first.value}')
                    : Text(
                  '$_message',
                  style: TextStyle(color: Colors.red),
                ),
                trailing: Container(
                  width: 30,
                  height: 30,
                  child: _contact == null
                      ? InkWell(
                    borderRadius: BorderRadius.circular(30.0),
                    onTap: _value == 1
                        ? () {
                      _pickContact();
                    }
                        : null,
                    child: Center(
                      child: Icon(
                        Icons.contacts_rounded,
                        color: _value == 1
                            ? Colors.green
                            : Colors.grey,
                      ),
                    ),
                  )
                      : InkWell(
                    borderRadius: BorderRadius.circular(30.0),
                    onTap: () {
                      setState(() {
                        _contact = null;
                      });
                    },
                    child: Center(
                      child: Icon(
                        Icons.remove_circle_rounded,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ),
                leading: Radio(
                    value: 1,
                    groupValue: _value,
                    onChanged: (thisValue) {
                      setState(() {
                        _value = thisValue;
                        _phoneController.clear();
                      });
                    }),
              ),
              ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, bottom: 8.0, left: 0.0, right: 0.0),
                  child: Column(
                    children: [
                      TextFormField(
                        // ignore: missing_return
                        validator: (validate) {
                          if (validate.toString() == '112') {
                            _showSnackBar(
                                'Do not work with emergency numbers');
                            return 'Do not work with emergency numbers';
                          } else if (validate.toString().isEmpty) {
                            return 'Please enter a number';
                          }
                        },
                        enabled: _value == 2 ? true : false,
                        maxLines: 1,
                        controller: _phoneController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding:
                          EdgeInsets.only(right: 12.0, left: 12.0),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  width: 2, color: Colors.green)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  width: 2, color: Colors.green)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  width: 2, color: Colors.green)),
                          labelText: 'Phone Number',
                          labelStyle: TextStyle(
                              color: _value == 2 ? Colors.green : null),
                        ),
                      ),
                    ],
                  ),
                ),
                trailing: Container(
                  width: 30,
                  height: 30,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30.0),
                    onTap: _value == 2
                        ? () {
                      _showAlert(context);
                    }
                        : null,
                    child: Center(
                      child: Icon(
                        Icons.info_outline_rounded,
                        color: _value == 2 ? Colors.green : Colors.grey,
                      ),
                    ),
                  ),
                ),
                leading: Radio(
                    value: 2,
                    groupValue: _value,
                    onChanged: (thisValue) {
                      setState(() {
                        _value = thisValue;
                        _contact = null;
                      });
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 12.0),
                child: FloatingActionButton.extended(
                  tooltip: 'Make the call now',
                  icon: Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Icon(Icons.call_received_rounded),
                  ),
                  label: Text("Receive now"),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  onPressed: () async {
                    if (_value == 2) {
                      if (_formKey.currentState.validate()) {
                        _callNow();
                      }
                    } else {
                      _callNow();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _callNow() async{
    final bool hasPhoneAccount = await _callKeep.hasPhoneAccount();
    if(hasPhoneAccount){
      if (_contact != null) {
        HistoryDatabase().saveCall(HistoriesDataBaseModel(
            '${_contact.displayName}',
            '${_contact.phones.first.value}',
            TimeOfDay.now().toString()));
        DisplayCall(context: context)
            .displayCall('${_contact.phones.first.value.toString()}');
        initInterstitialAd();
      } else if (_phoneController.text.isNotEmpty) {
        HistoryDatabase().saveCall(HistoriesDataBaseModel(
            '${_phoneController.text}',
            '${_phoneController.text}',
            TimeOfDay.now().toString()));
        DisplayCall(context: context)
            .displayCall('${_phoneController.text.toString()}');
        initInterstitialAd();
      } else
        _showSnackBar('Please import a contact to continue!');
    }else{
      askPermissions(context);
    }
  }

  _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: Text(msg),
    ));
  }

  _showAlert(BuildContext context) async {
    showDialog(
        barrierColor: Colors.green.withOpacity(0.1),
        context: context,
        builder: (context) => ContactInfoAlert());
  }

  bool isRewardedVideoAvailable = false;

  void _showAds() {
    Future.delayed(new Duration(seconds: 10), () {
    }).then((value) async{
      isRewardedVideoAvailable = await FlutterApplovinMax.isInterstitialLoaded((listener) => AdsManager().listener(listener));
      if(isRewardedVideoAvailable){
        FlutterApplovinMax.showInterstitialVideo((listener) => AdsManager().listener(listener));
      }
    });
  }
}
