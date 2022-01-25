import 'dart:async';
import 'package:callkeep/callkeep.dart';
import 'package:fake_call/Services/PermissionsHandler.dart';
import 'package:fake_call/model/Call.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

final FlutterCallkeep _callKeep = FlutterCallkeep();
Map<String, Call> calls = {};
String newUUID() => Uuid().v4();

class DisplayCall {
  final BuildContext context;
  DisplayCall({this.context});
  Future<Map> displayCall(String number) async {
    final String callUUID = newUUID();
    calls[callUUID] = Call(number);

    _callKeep.displayIncomingCall(callUUID, number,
        handleType: 'number', hasVideo: false);
    return calls;
  }

  Future<void> answerCall(CallKeepPerformAnswerCallAction event) async {
    final String callUUID = event.callUUID;
    final String number = calls[callUUID].number;
    _callKeep.startCall(event.callUUID, number, number);
    Timer(const Duration(seconds: 1), () {
      _callKeep.setCurrentCallActive(callUUID);
    });
  }

  void didDisplayIncomingCall(CallKeepDidDisplayIncomingCall event) {
    var callUUID = event.callUUID;
    var number = event.handle;
    print('after 20 seconds');
    calls[callUUID] = Call(number);
  }

  Future<void> didPerformDTMFAction(CallKeepDidPerformDTMFAction event) async {
    print('[didPerformDTMFAction] ${event.callUUID}, digits: ${event.digits}');
  }

  Future<void> didReceiveStartCallAction(CallKeepDidReceiveStartCallAction event) async {
    if (event.handle == null) {
      return;
    }
    final String callUUID = event.callUUID ?? newUUID();

    calls[callUUID] = Call(event.handle);
    _callKeep.startCall(callUUID, event.handle, event.handle);

    Timer(const Duration(seconds: 1), () {
      _callKeep.setCurrentCallActive(callUUID);
    });
  }

  Future<void> didToggleHoldCallAction(CallKeepDidToggleHoldAction event) async {
    setCallHeld(event.callUUID, event.hold);
  }

  void setCallHeld(String callUUID, bool held) {
    calls[callUUID].held = held;
  }

  Future<void> didPerformSetMutedCallAction(CallKeepDidPerformSetMutedCallAction event) async {
    setCallMuted(event.callUUID, event.muted);
  }

  void setCallMuted(String callUUID, bool muted) {
    calls[callUUID].muted = muted;
  }

  void removeCall(String callUUID) {
    calls.remove(callUUID);
  }

  Future<void> endCall(CallKeepPerformEndCallAction event) async {
    removeCall(event.callUUID);
  }

  void onPushKitToken(CallKeepPushKitToken event) {

  }

  Future<void> hangup(String callUUID) async {
    _callKeep.endCall(callUUID);
    removeCall(callUUID);
  }

  Future<void> setOnHold(String callUUID, bool held) async {
    _callKeep.setOnHold(callUUID, held);
    setCallHeld(callUUID, held);
  }

  Future<void> setMutedCall(String callUUID, bool muted) async {
    _callKeep.setMutedCall(callUUID, muted);
    setCallMuted(callUUID, muted);
  }

  Future<void> updateDisplay(String callUUID) async {
    final String number = calls[callUUID].number;
    if (isIOS) {
      _callKeep.updateDisplay(callUUID,
          displayName: 'New Name', handle: number);
    } else {
      _callKeep.updateDisplay(callUUID,
          displayName: number, handle: 'New Name');
    }
  }
}