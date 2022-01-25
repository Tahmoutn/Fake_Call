import 'package:callkeep/callkeep.dart';
import 'package:fake_call/Services/CallServices.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../main.dart';

Future<void> askPermissions(BuildContext context) async {

  callKeep.on(
      CallKeepDidDisplayIncomingCall(), DisplayCall().didDisplayIncomingCall);
  callKeep.on(CallKeepPerformAnswerCallAction(), DisplayCall().answerCall);
  callKeep.on(
      CallKeepDidPerformDTMFAction(), DisplayCall().didPerformDTMFAction);
  callKeep.on(CallKeepDidReceiveStartCallAction(),
      DisplayCall().didReceiveStartCallAction);
  callKeep.on(
      CallKeepDidToggleHoldAction(), DisplayCall().didToggleHoldCallAction);
  callKeep.on(CallKeepDidPerformSetMutedCallAction(),
      DisplayCall().didPerformSetMutedCallAction);
  callKeep.on(CallKeepPerformEndCallAction(), DisplayCall().endCall);
  callKeep.on(CallKeepPushKitToken(), DisplayCall().onPushKitToken);

  Map<Permission, PermissionStatus> permissionStatus =
      await _getContactPermission();
  if(permissionStatus.isNotEmpty){
    permissionStatus.forEach((key, value) {
      if (value != PermissionStatus.granted) {
        showMyMaterialBanner(context);
      }
    });
  }else{
    print(permissionStatus.isEmpty);
  }

  if (permissionStatus.values.first.isGranted) {
    callKeep.setup(
        context,
        <String, dynamic>{
          'ios': {
            'appName': 'CallKeepDemo',
          },
          'android': {
            'alertTitle': 'Permissions required',
            'alertDescription':
                'This application needs to access your phone accounts',
            'cancelButton': 'Cancel',
            'okButton': 'ok',
            'foregroundService': {
              'channelId': 'com.next_studio.com',
              'channelName': 'Foreground service for FAKE CALL App',
              'notificationTitle': 'Fake call app is running on background',
              'notificationIcon': 'assets/images/favicon.png',
            },
          },
        },
        backgroundMode: true);
  }

  final bool hasPhoneAccount = await callKeep.hasPhoneAccount();
  if (!hasPhoneAccount) {
    await callKeep.hasDefaultPhoneAccount(context, <String, dynamic>{
      'alertTitle': 'Permissions required',
      'alertDescription':
          'This application needs to access your phone accounts',
      'cancelButton': 'Cancel',
      'okButton': 'ok',
      'foregroundService': {
        'channelId': 'com.next-studio.com',
        'channelName': 'Foreground service for FAKE CALL App',
        'notificationTitle': 'Fake call app is running on background',
        'notificationIcon': 'assets/images/favicon.png',
      },
    }).then((value) {
      if (!value) {
        showMyMaterialBanner(context);
      } else {
        ScaffoldMessenger.of(context).clearMaterialBanners();
      }
    });
  }
}

Future<Map<Permission, PermissionStatus>> _getContactPermission() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.contacts,
    Permission.phone,
    Permission.microphone
  ].request();

  return statuses;
}

showMyMaterialBanner(BuildContext context) {
  ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
    overflowAlignment: OverflowBarAlignment.start,
    contentTextStyle: TextStyle(color: Colors.deepOrange.shade800),
    content: Text(
      'This app needs some permissions to run perfectly.',
    ),
    backgroundColor: Colors.deepOrange.shade50,
    actions: [
      OutlinedButton(
        onPressed: () {
          try{
            askPermissions(context);
            ScaffoldMessenger.of(context).clearMaterialBanners();
          }catch(e){
            print('error');
          }
        },
        child: Text('Request'),
      )
    ],
  ));
}
