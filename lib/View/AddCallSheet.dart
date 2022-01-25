import 'package:contacts_service/contacts_service.dart';
import 'package:fake_call/Services/TimeCalculator.dart';
import 'package:fake_call/UI/Home/Home.dart';
import 'package:fake_call/View/ContactInfoAlert.dart';
import 'package:fake_call/database/database.dart';
import 'package:fake_call/model/DataBaseModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddCallSheet extends StatefulWidget {

  @override
  _AddCallSheetState createState() => _AddCallSheetState();

}

class _AddCallSheetState extends State<AddCallSheet> {

  int _value;
  Contact _contact;
  TimeOfDay selectedTime = TimeOfDay.now();
  String time = 'now';
  TextEditingController _phoneController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Color valueOneColor = Colors.black87;
  String timeWarning = '';
  String _message;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: selectedTime);
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
      });
  }

  void _setCall() async{
    if(_value == 1){
      if(_contact!=null){
        // setCallOnDataBase(
        //     DataBaseModel(
        //     _contact.displayName,
        //     _contact.phones.first.value,
        //       TimeOfDay.now().toString()
        //     )).then((result){
        //   Navigator.of(context).pop(true);
        // });
      }else{
        setState(() {
          valueOneColor = Colors.red;
        });
      }
    }else if(_phoneController.text.isNotEmpty){
      // setCallOnDataBase(DataBaseModel(
      //     _phoneController.text.toString(),
      //     _phoneController.text.toString(),
      //     TimeOfDay.now().toString()
      // )).then((result){
      //   Navigator.of(context).pop(true);
      // });
    }
  }

  Future setCallOnDataBase(DataBaseModel call) async {
    await DatabaseHelper().db;
    var dbHelper =  DatabaseHelper();
    await dbHelper.saveCall(call);
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickContact() async {
    try {
       await ContactsService.openDeviceContactPicker(
          iOSLocalizedLabels: iOSLocalizedLabels).then((value) {
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

  Future<bool> _onWillPop() async{
    Navigator.of(context).pop(false);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
         statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark
        ),
        child: Container(
          padding: EdgeInsets.only(
            top: 25.0,
            bottom: 10.0,
            right: 12.0,
            left: 12.0,
          ),
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Wrap(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30.0),
                                onTap:(){
                                  Navigator.of(context).pop();
                                },
                                child: Center(
                                  child: Icon(
                                    Icons.cancel_rounded,
                                    color: Colors.deepOrange,
                                  ),
                                ),
                              ),
                            ),
                            Text('ADD NEW FAKE CALL',
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800
                              ),
                            ),
                            Container(
                              width: 30,
                              height: 30,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30.0),
                                onTap: () async{
                                  if('${TimeCalculator().calculate(selectedTime)}' != 'now'){
                                    if(_value == 2){
                                      if(_formKey.currentState.validate()){
                                        _setCall();
                                      }
                                    }else if(_value == 1) {
                                      _setCall();
                                    }
                                  }else{
                                    setState(() {
                                      timeWarning = ' Please change to up or down!';
                                    });
                                  }
                                },
                                child: Center(
                                  child: Icon(
                                    Icons.done_rounded,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Tooltip(
                          message: 'Beta',
                          child: Card(
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(
                                    color: Colors.blue,
                                    width: 0.5
                                )
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                  'assets/svg/beta.svg',
                                  semanticsLabel: 'Beta',
                                  color: Colors.blue,
                                  height: 20,
                                  width: 20,
                                )
                              // Text('Beta',
                              //   style: TextStyle(
                              //       color: Colors.blue,
                              //       fontSize: 20,
                              //       fontWeight: FontWeight.w500
                              //   ),),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Divider(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0,left: 8.0),
                        child: Row(
                          children: [
                            Text('Contact',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w800,
                              ),),
                            Flexible(
                              child: Text(_message == null ? '' : ' • $_message',
                                  style: TextStyle(
                                  color: Colors.red,
                                  )
                              ),
                            )
                          ],
                        ),
                      ),
                      ListTile(
                        title: _contact == null ?
                        Text('Import Contact',
                        style: TextStyle(
                          color: valueOneColor
                        ),) : Text('${_contact.displayName}'),
                        subtitle: _contact == null ? null : Text('${_contact.phones.first.value}'),
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

                        // IconButton(
                        //   icon: Icon(
                        //     Icons.person_add_alt_1_rounded,
                        //     color: _value == 1 ? Colors.green : Colors.green[100],
                        //   ),
                        //   onPressed: _value == 1 ? (){
                        //     print('Add Person');
                        //   } : null,
                        // ),
                        leading: Radio(
                            value: 1,
                            groupValue: _value,
                            onChanged: (thisValue){
                              setState(() {
                                _value = thisValue;
                              });
                            } ),
                      ),
                      Divider(
                        height: 1,
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
                                    setState(() {
                                      _phoneController.clear();
                                    });
                                    return 'Do not work with emergency numbers';
                                  }else if(validate.isEmpty){
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
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            width: 2,
                                            color: Colors.red
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
                                    errorStyle: TextStyle(
                                      color: Colors.red
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
                        leading : Radio(
                            value: 2,
                            groupValue: _value,
                            onChanged: (thisValue){
                              setState(() {
                                _value = thisValue;
                                _contact = null;
                              });
                            }),
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
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Divider(
                          height: 1,
                        ),
                      ),
                      // Time
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0,left: 8.0),
                        child: Row(
                          children: [
                            Text('Time',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w800,
                              ),),
                            Flexible(
                              child: RichText(
                                overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(text :' • After ${TimeCalculator().calculate(selectedTime)}',
                                        style: TextStyle(
                                          color: Colors.black45,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      TextSpan(text: '$timeWarning',
                                      style: TextStyle(
                                        color: Colors.red,
                                      ))
                                    ]
                                  )),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                              color: Colors.black12,
                              width: 0.5,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 14.0,
                                left: 14.0),
                            child: Container(
                              height: 100,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('You will receive the call at'),
                                      Text('${selectedTime.format(context)}',
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 40
                                        ),),
                                    ],
                                  ),
                                  FloatingActionButton(
                                      tooltip: 'Change timer',
                                      elevation: 2,
                                      isExtended: true,
                                      child: Icon(Icons.timer_rounded),
                                      onPressed: (){
                                        _selectTime(context);
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showAlert(BuildContext context) async{
    showDialog(
        context: context,
        builder: (context) => ContactInfoAlert());
  }
}
