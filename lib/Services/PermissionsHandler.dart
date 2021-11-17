
import 'package:callkeep/callkeep.dart';
import 'package:fake_call/Services/CallServices.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../main.dart';


Future<void> askPermissions(BuildContext context) async {

  callKeep.on(CallKeepDidDisplayIncomingCall(), DisplayCall().didDisplayIncomingCall);
  callKeep.on(CallKeepPerformAnswerCallAction(), DisplayCall().answerCall);
  callKeep.on(CallKeepDidPerformDTMFAction(), DisplayCall().didPerformDTMFAction);
  callKeep.on(CallKeepDidReceiveStartCallAction(), DisplayCall().didReceiveStartCallAction);
  callKeep.on(CallKeepDidToggleHoldAction(), DisplayCall().didToggleHoldCallAction);
  callKeep.on(CallKeepDidPerformSetMutedCallAction(), DisplayCall().didPerformSetMutedCallAction);
  callKeep.on(CallKeepPerformEndCallAction(), DisplayCall().endCall);
  callKeep.on(CallKeepPushKitToken(), DisplayCall().onPushKitToken);


  Map<Permission, PermissionStatus> permissionStatus = await _getContactPermission();
  permissionStatus.forEach((key, value) {
    if(value != PermissionStatus.granted){
      if(key == Permission.contacts && value != PermissionStatus.granted){
        print('Permission not granted');
      }
    }
    else {
      callKeep.setup( context ,<String, dynamic>{
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
      }, backgroundMode: true);
    }
  });

  final bool hasPhoneAccount = await callKeep.hasPhoneAccount();
  if (!hasPhoneAccount) {

    await callKeep.hasDefaultPhoneAccount( context , <String, dynamic>{
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