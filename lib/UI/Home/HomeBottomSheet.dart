
import 'package:callkeep/callkeep.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:fake_call/Services/PermissionsHandler.dart';
import 'package:fake_call/UI/Home/Home.dart';
import 'package:fake_call/View/ContactInfoAlert.dart';
import 'package:fake_call/providers/HomeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

final FlutterCallkeep _callKeep = FlutterCallkeep();

class HomeBottomSheet {
  final BuildContext context;
  final int index;
  final String title;
  HomeBottomSheet(this.context,this.index,this.title);

  final _formKey = GlobalKey<FormState>();

  Future<bool> bottomSheet() async{
    return await showModalBottomSheet(
        context: context,
        elevation: 16,
        isScrollControlled: true,
        builder: (_){
          return StatefulBuilder(
            builder: (context,setState){
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 80.0,
                          child: Center(
                            child: Text('Please select your choice ($title).'),
                          ),
                        ),
                        ListTile(
                          title: context.watch<HomeProvider>().contact == null ?
                          Text('Select contact') : Text('${context.watch<HomeProvider>().contact.displayName}'),
                          subtitle: context.watch<HomeProvider>().message == null ? context.watch<HomeProvider>().contact == null ? null : Text('${context.watch<HomeProvider>().contact.phones.first.value}'): Text('${context.watch<HomeProvider>().message}',style: TextStyle(
                              color: Colors.red
                          ),),
                          trailing: Container(
                            width: 30,
                            height: 30,
                            child: context.watch<HomeProvider>().contact == null ? InkWell(
                              borderRadius: BorderRadius.circular(30.0),
                              onTap: context.watch<HomeProvider>().homeRadioGroup == 1 ? (){
                                _pickContact();
                              } : null,
                              child: Center(
                                child: Icon(
                                  Icons.contacts_rounded,
                                  color: context.watch<HomeProvider>().homeRadioGroup == 1 ? Colors.green : Colors.grey,
                                ),
                              ),
                            ) : InkWell(
                              borderRadius: BorderRadius.circular(30.0),
                              onTap: (){
                                context.read<HomeProvider>().setContact(null);
                                context.read<HomeProvider>().setMessageError(null);
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
                              groupValue: context.watch<HomeProvider>().homeRadioGroup,
                              onChanged: (radioValue){
                                _onRadioTap(radioValue);
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
                                      //_showSnackBar('Do not work with emergency numbers');
                                      return 'Do not work with emergency numbers';
                                    }else if(validate.toString().isEmpty){
                                      return 'Please enter a number';
                                    }
                                  },
                                  enabled: context.watch<HomeProvider>().homeRadioGroup == 2 ? true : false,
                                  maxLines: 1,
                                  controller: context.watch<HomeProvider>().phoneController,
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
                                    labelText: 'Phone number',
                                    labelStyle: TextStyle(
                                        color: context.watch<HomeProvider>().homeRadioGroup == 2 ? Colors.green : null
                                    ),
                                    errorStyle: TextStyle(
                                      color: Colors.deepOrange
                                    )
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
                              onTap: context.watch<HomeProvider>().homeRadioGroup == 2 ? (){
                                showDialog(
                                    barrierColor: Colors.green.withOpacity(0.1),
                                    context: context,
                                    builder: (context) => ContactInfoAlert());
                              } : null,
                              child: Center(
                                child: Icon(Icons.info_outline_rounded,
                                  color: context.watch<HomeProvider>().homeRadioGroup == 2 ? Colors.green : Colors.grey,),
                              ),
                            ),
                          ),
                          leading: Radio(
                              value: 2,
                              groupValue:context.watch<HomeProvider>().homeRadioGroup,
                              onChanged: (radioValue){
                                _onRadioTap(radioValue);
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: FloatingActionButton.extended(
                            tooltip: 'Take action',
                            icon: Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: Icon(Icons.arrow_right_alt_rounded),
                            ),
                            label: Text("Submit"),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            onPressed: () async{
                              final bool hasPhoneAccount = await _callKeep.hasPhoneAccount();
                              if(hasPhoneAccount) {
                                if(Provider.of<HomeProvider>(context, listen: false).homeRadioGroup == 1){

                                  if(Provider.of<HomeProvider>(context, listen: false).contact == null){
                                    context.read<HomeProvider>().setMessageError('Please, select contact');
                                    return ;
                                  }
                                  context.read<HomeProvider>().setCardInformation(index);
                                  clearState();
                                  Navigator.pop(_,true);
                                }
                                if(Provider.of<HomeProvider>(context, listen: false).homeRadioGroup == 2){

                                  if(_formKey.currentState.validate()){
                                    context.read<HomeProvider>().setCardInformation(index);
                                    clearState();
                                    Navigator.pop(_,true);
                                  }
                                }
                              }else{
                                askPermissions(context);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        barrierColor: Colors.green.withOpacity(0.05),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(20)
            )
        )
    );
  }

  Future<void> _pickContact() async {
    try {
      await ContactsService.openDeviceContactPicker(
          iOSLocalizedLabels: iOSLocalizedLabels).then((value){
        if(value.phones.isEmpty) {
          context.read<HomeProvider>().setMessageError('This contact does not have phone');
          return null;
        }
        context.read<HomeProvider>().setMessageError(null);
        context.read<HomeProvider>().setContact(value);
      });
    } catch (e){
      print(e.toString());
    }
  }

  void _onRadioTap(int radioValue) {
    context.read<HomeProvider>().setRadioGroupValue(radioValue);
    clearState();
  }

  void clearState(){
    context.read<HomeProvider>().cleanContact();
    context.read<HomeProvider>().clearPhoneController();
    context.read<HomeProvider>().setMessageError(null);
    _formKey.currentState.reset();
  }
}
