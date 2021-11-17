import 'package:contacts_service/contacts_service.dart';
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:fake_call/Monetization/MyBannerWidget.dart';
import 'package:fake_call/Services/CallServices.dart';
import 'package:fake_call/UI/Home.dart';
import 'package:fake_call/View/ContactInfoAlert.dart';
import 'package:fake_call/database/HistoryDatabase.dart';
import 'package:fake_call/model/ListCallModel.dart';
import 'package:fake_call/monetization/AdsManager.dart';
import 'package:flutter/material.dart';


class CallNow extends StatefulWidget {
  @override
  _CallNowState createState() => _CallNowState();
}

class _CallNowState extends State<CallNow> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TimeOfDay _time;
  Contact _contact;
  int _value;
  String _message;
  TextEditingController _phoneController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _pickContact() async {
    try {
       await ContactsService.openDeviceContactPicker(
          iOSLocalizedLabels: iOSLocalizedLabels).then((value){
        if(value.phones.isEmpty) {
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
    } catch (e){
      print(e.toString());
    }
  }

  @override
  void initState() {
    // myBanner.load();
    // adWidget = AdWidget(ad: myBanner);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // appBar: new AppBar(
      //   backgroundColor: Colors.transparent,
      //   shadowColor: Colors.transparent,
      //   leading: Padding(
      //     padding: const EdgeInsets.only(top:4.0,bottom: 4.0,left: 8.0),
      //     child: InkWell(
      //       radius: 30,
      //       borderRadius: BorderRadius.circular(30),
      //       child: Icon(Icons.arrow_back_rounded,
      //         color: Colors.green,),
      //       onTap: (){
      //         Navigator.pop(context);
      //       },
      //     ),
      //   ),
      // ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    // physics: BouncingScrollPhysics(),
                    // padding: const EdgeInsets.only(bottom: 20.0),
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 12.0,right: 12.0,left: 12.0,bottom: 12.0),
                        //TODO
                        child: new MyBannerWidget(
                          placementId: callNowBannerAdUnitId(),
                          bannerSize: BannerSize.STANDARD,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: Image.asset(
                            'assets/images/call_illustation1.png'),
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
                        title: _contact == null ?
                        Text('Import Contact') : Text('${_contact.displayName}'),
                        subtitle: _message == null ? _contact == null ? null : Text('${_contact.phones.first.value}'): Text('$_message',style: TextStyle(
                          color: Colors.red
                        ),),
                        trailing: Container(
                          width: 30,
                          height: 30,
                          child: _contact == null ? InkWell(
                            borderRadius: BorderRadius.circular(30.0),
                            onTap: _value == 1 ? (){
                              _pickContact();
                            } : null,
                            child: Center(
                              child: Icon(
                                Icons.person_add_alt_1_rounded,
                                color: _value == 1 ? Colors.green : Colors.grey,
                              ),
                            ),
                          ) : InkWell(
                            borderRadius: BorderRadius.circular(30.0),
                            onTap: (){
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
                            onChanged: (thisValue){
                              setState(() {
                                _value = thisValue;
                                _phoneController.clear();
                              });
                            }),
                      ),
                      ListTile(
                        title: Padding(
                          padding: const EdgeInsets.only(top: 8.0,bottom: 8.0,left: 0.0,right: 0.0),
                          child: Column(
                            children: [
                              TextFormField(
                                // ignore: missing_return
                                validator: (validate){
                                  if(validate.toString() == '112'){
                                    _showSnackBar('Do not work with emergency numbers');
                                    return 'Do not work with emergency numbers';
                                  }else if(validate.toString().isEmpty){
                                    return 'Please enter a number';
                                  }
                                },
                                enabled: _value == 2 ? true : false,
                                maxLines: 1,
                                controller: _phoneController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(right: 12.0,left: 12.0),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          width: 2,
                                          color: Colors.green
                                      )
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          width: 2,
                                          color: Colors.green
                                      )
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          width: 2,
                                          color: Colors.green
                                      )
                                  ),
                                  labelText: 'Phone Number',
                                  labelStyle: TextStyle(
                                      color: _value == 2 ? Colors.green : null
                                  ),
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
                            onTap: _value == 2 ? (){
                              _showAlert(context);
                            } : null,
                            child: Center(
                              child: Icon(Icons.info_rounded,
                                color: _value == 2 ? Colors.green : Colors.grey,),
                            ),
                          ),
                        ),
                        leading: Radio(
                            value: 2,
                            groupValue: _value,
                            onChanged: (thisValue){
                              setState(() {
                                _value = thisValue;
                                _contact = null;
                              });
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0,bottom: 12.0),
                        child: Center(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.07,
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)
                              ),
                              color: Colors.green,
                              child: Row(

                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.call,
                                    color: Colors.white,),
                                  SizedBox(width: 15.0,),
                                  Text('Call now',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      //fontWeight: FontWeight.w500,
                                       color: Colors.white
                                    ),)
                                ],
                              ),
                              onPressed: (){
                                if(_value == 2){
                                  if(_formKey.currentState.validate()){
                                    _callNow();
                                  }
                                }else{
                                  _callNow();
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.only(left: 16,top: 40,bottom: 8),
                child: Tooltip(
                  message: 'Return',
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back_rounded,
                        color: Colors.green,),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _callNow(){
    setState(() {
      _time = TimeOfDay.now();
    });
    if(_contact!=null){
      HistoryDatabase().saveCall(
          ListCallModel(
               '${_contact.displayName}'
              , '${_contact.phones.first.value}'
              , _time.format(context)));
      DisplayCall(context: context).displayCall('${_contact.phones.first.value.toString()}');
    }else if(_phoneController.text.isNotEmpty){
      HistoryDatabase().saveCall(
          ListCallModel(
              '${_phoneController.text}'
              , '${_phoneController.text}'
              , _time.format(context)));
      DisplayCall(context: context).displayCall('${_phoneController.text.toString()}');
      print('Call now');
    }else _showSnackBar('Please import a contact to continue!');
  }

  _showSnackBar(String msg){
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        content: Text(msg),
      )
    );

  }

  _showAlert(BuildContext context) async{
    showDialog(
        context: context,
        builder: (context) => ContactInfoAlert());
  }
}
