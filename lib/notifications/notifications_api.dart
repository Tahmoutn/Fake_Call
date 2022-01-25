import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';


class NotificationApi  {
  static final _notification = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String>();

  static String title(int minutes){
    return 'Fake phone call after $minutes minutes';
  }

  static String body (String name){
    return 'Caller - ${name.length <= 5 ? name : '${name.substring(0,5)}...'} • Tap to start application.';
  }


  static Future _notificationDetails() async {

    // final largeIcon = await Utils.downloadFile(
    //     'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRy1Yqg_okA7LHxNuCduFWehr7jKjz4iyjW-w&usqp=CAU',
    //     'largeIcon'
    // );
    //
    // final bigPicture = await Utils.downloadFile(
    //     'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWsvCqDvmfRVW4e2sPKrqyha1uRKNSW0GXjw&usqp=CAU',
    //     'bigPicture'
    // );
    //
    // final styleInformation = BigPictureStyleInformation(
    //     FilePathAndroidBitmap(bigPicture),
    //     largeIcon: FilePathAndroidBitmap(largeIcon)
    // );

    return NotificationDetails(
      android: AndroidNotificationDetails(
          'channel id',
          'Receive call',
          color: Color.fromARGB(255, 42, 190, 133),
          channelDescription: 'Alert before 5 Min',
          importance: Importance.defaultImportance,
          //enableVibration: true
          // styleInformation: styleInformation
      ),
      iOS: IOSNotificationDetails()
    );
  }

  static Future init({bool initScheduled = false}) async {
    final iOS = IOSInitializationSettings();
    final android = AndroidInitializationSettings('app_icon');
    final settings = InitializationSettings(
      android: android,
      iOS: iOS
    );

    final details = await _notification.getNotificationAppLaunchDetails();
    if(details != null && details.didNotificationLaunchApp){
      onNotifications.add(details.payload);
    }

    await _notification.initialize(
      settings,
      onSelectNotification: (payload) async {
        onNotifications.add(payload);
      },
    );
    if(initScheduled){
      tz.initializeTimeZones();
      final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    }
  }

  static Future showNotification({
    int id = 0 ,
    String title,
    String body,
    String payload,
  }) async => _notification.show(
      id,
      title,
      body,
      await _notificationDetails(),
      payload: payload
  );

  static Future showScheduledNotification({
    int id = 0 ,
    String title,
    String body,
    String payload,
    DateTime scheduledDate,
    //Time time
  }) async => _notification.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      //_scheduledDaily(time),
      await _notificationDetails(),
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
       UILocalNotificationDateInterpretation.absoluteTime,
      // Remove this
      //matchDateTimeComponents: DateTimeComponents.time
  );

  static tz.TZDateTime _scheduledDaily(Time time){
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
        time.second
    );
    return scheduledDate.isBefore(now)
        ? scheduledDate.add(Duration(days: 1)) :
        scheduledDate ;
  }

  static void cancel(int id) => _notification.cancel(id);

  static void cancelAll() => _notification.cancelAll();


}