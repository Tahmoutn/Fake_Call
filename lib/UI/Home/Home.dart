import 'dart:async';
import 'package:fake_call/Services/PermissionsHandler.dart';
import 'package:fake_call/UI/Home/HAppBar.dart';
import 'package:fake_call/UI/Home/HDrawer.dart';
import 'package:fake_call/UI/Moment/Moment.dart';
import 'package:fake_call/database/HistoryDatabase.dart';
import 'package:fake_call/database/database.dart';
import 'package:fake_call/model/DataBaseModel.dart';
import 'package:fake_call/model/HistoriesDatabaseModel.dart';
import 'package:fake_call/monetization/AdsManager.dart';
import 'package:fake_call/notifications/notifications_api.dart';
import 'package:fake_call/providers/HomeProvider.dart';
import 'package:fake_call/providers/IntroProvider.dart';
import 'package:flutter/material.dart';
import 'package:fake_call/Services/CallServices.dart';
import 'package:flutter_applovin_max/banner.dart';
import 'package:flutter_applovin_max/flutter_applovin_max.dart';
import 'package:provider/provider.dart';
import 'HomeBottomSheet.dart';

const iOSLocalizedLabels = false;

class Home extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Home> {


  @override
  void initState() {
    super.initState();
    askPer();
    NotificationApi.init(initScheduled: true);
    listenNotifications();
    context.read<HomeProvider>().initProviderState(context, true);
  }

  void askPer() {
    IntroProvider().getAcceptingAgreementState().then((value) => setState((){
      if(value){
        askPermissions(context);
      }
    }));
  }

  void listenNotifications() =>
      NotificationApi.onNotifications.stream.listen(onClickedNotification);

  void onClickedNotification(String payload) {
    if(payload!=null){
      showDialog(
          context: context,
          barrierColor: Colors.green.withOpacity(0.1),
          builder: (_){
            return AlertDialog(
              elevation: 30,
              title: Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Icon(Icons.phone_callback_rounded),
                    ),
                    Expanded(
                      child: Text('Call • $payload',
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,),
                    ),
                  ],
                ),
              ),
              content: RichText(
                text: TextSpan(
                    children: [
                      TextSpan(
                          text: '  Please late the app open to receive the call.\n',
                          style: TextStyle(
                              fontSize: 20,
                              decoration: TextDecoration.underline,
                              color: Colors.black87
                          )
                      ),
                      TextSpan(
                          text: '  Or you can tab on',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black87
                          )
                      ),
                      TextSpan(
                          text: ' ◉ ',
                          style: TextStyle(
                              fontSize: 36,
                              color: Colors.black45
                          )
                      ),
                      TextSpan(
                          text: 'Home button.',
                          style: TextStyle(
                              fontSize: 20,
                              decoration: TextDecoration.underline,
                              color: Colors.black87
                          )
                      ),
                    ]
                ),
              ),
              actions: [
                OutlinedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HAppBar(),
      drawer: HDrawer(),
      drawerScrimColor: Colors.green.withAlpha(40),
      primary: true,
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Container(
            height: MediaQuery.of(context).size.width,
            child: GridView(
              physics: BouncingScrollPhysics(),
              //controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (MediaQuery.of(context).orientation ==
                          Orientation.portrait)
                      ? 2
                      : 3),
              children: [
                new Card(
                    elevation: 0,
                    shadowColor: Colors.green.withOpacity(0.3),
                    color: Colors.green.shade50,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(width: 0.0, color: Colors.white)),
                    margin: const EdgeInsets.all(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () async {
                        _onCardTap(
                            0, 'After 5 min', Duration(hours: 0, minutes: 5));
                      },
                      child: Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.05),
                        child: new Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  child: Icon(Icons.phone_callback_rounded),
                                ),
                                Switch(
                                    value: context
                                        .watch<HomeProvider>()
                                        .afterFiveMinuets,
                                    onChanged: (v) {
                                      _onCardTap(0, 'After 5 min',
                                          Duration(hours: 0, minutes: 5));
                                    }),
                              ],
                            ),
                            Text(
                              'After 5 min',
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.green.shade800,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              context.watch<HomeProvider>().nameOfFirstCard,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.teal,
                                  fontWeight: FontWeight.w800,
                                  fontStyle: FontStyle.italic),
                            ),
                            Text(
                              context.watch<HomeProvider>().numberOfFirstCard,
                              style: TextStyle(fontStyle: FontStyle.normal),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    )),
                new Card(
                    elevation: 0,
                    shadowColor: Colors.green.withOpacity(0.3),
                    color: Colors.green.shade50,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(width: 0.0, color: Colors.white)),
                    margin: const EdgeInsets.all(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () async {
                        _onCardTap(
                            1, 'After 30 min', Duration(hours: 0, minutes: 30));
                      },
                      child: Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.05),
                        child: new Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  child: Icon(Icons.phone_callback_rounded),
                                ),
                                Switch(
                                    value: context
                                        .watch<HomeProvider>()
                                        .afterThirtyMinuets,
                                    onChanged: (v) {
                                      _onCardTap(1, 'After 30 min',
                                          Duration(hours: 0, minutes: 30));
                                    }),
                              ],
                            ),
                            Text(
                              'After 30 min',
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.green.shade800,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              context.watch<HomeProvider>().nameOfSecondCard,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.teal,
                                  fontWeight: FontWeight.w800,
                                  fontStyle: FontStyle.italic),
                            ),
                            Text(
                              context.watch<HomeProvider>().numberOfSecondCard,
                              style: TextStyle(fontStyle: FontStyle.normal),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    )),
                new Card(
                    elevation: 0,
                    shadowColor: Colors.green.withOpacity(0.3),
                    color: Colors.green.shade50,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(width: 0.0, color: Colors.white)),
                    margin: const EdgeInsets.all(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () async {
                        _onCardTap(
                            2, 'After 1 hour', Duration(hours: 1, minutes: 0));
                      },
                      child: Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.05),
                        child: new Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  child: Icon(Icons.phone_callback_rounded),
                                ),
                                Switch(
                                    value: context
                                        .watch<HomeProvider>()
                                        .afterOneHour,
                                    onChanged: (v) {
                                      _onCardTap(2, 'After 1 hour',
                                          Duration(hours: 1, minutes: 0));
                                    }),
                              ],
                            ),
                            Text(
                              'After 1 hour',
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.green.shade800,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              context.watch<HomeProvider>().nameOfThirdCard,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.teal,
                                  fontWeight: FontWeight.w800,
                                  fontStyle: FontStyle.italic),
                            ),
                            Text(
                              context.watch<HomeProvider>().numberOfThirdCard,
                              style: TextStyle(fontStyle: FontStyle.normal),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    )),
                new Card(
                    elevation: 0,
                    shadowColor: Colors.green.withOpacity(0.3),
                    color: Colors.green.shade50,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(width: 0.0, color: Colors.white)),
                    margin: const EdgeInsets.all(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () async {
                        _onCardTap(
                            3, 'After 5 hours', Duration(hours: 5, minutes: 0));
                      },
                      child: Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.05),
                        child: new Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  child: Icon(Icons.phone_callback_rounded),
                                ),
                                Switch(
                                    value: context
                                        .watch<HomeProvider>()
                                        .afterFiveHours,
                                    onChanged: (v) {
                                      _onCardTap(3, 'After 5 hours',
                                          Duration(hours: 5, minutes: 0));
                                    }),
                              ],
                            ),
                            Text(
                              'After 5 hours',
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.green.shade800,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              context.watch<HomeProvider>().nameOfForthCard,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.teal,
                                  fontWeight: FontWeight.w800,
                                  fontStyle: FontStyle.italic),
                            ),
                            Text(
                              context.watch<HomeProvider>().numberOfForthCard,
                              style: TextStyle(fontStyle: FontStyle.normal),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
          Card(
            margin: EdgeInsets.only(top: 6.0, left: 20.0, right: 20.0),
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
                            top: 8.0, left: 18, right: 8.0, bottom: 10),
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
                    child: new BannerMaxView(
                            (AppLovinAdListener event) => AdsManager().listener(event)
                        ,BannerAdSize.banner,
                        mainBannerAdUnitId()),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        tooltip: 'Make the call now',
        icon: Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: Icon(Icons.phone_callback_rounded),
        ),
        label: Text("Make it now"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        onPressed: () async {
          Navigator.push(context, MaterialPageRoute(builder: (_)=> Moment()));
        },
      ),
    );
  }

  void _onCardTap(int index, String title, Duration duration) async {
    if (Provider.of<HomeProvider>(context, listen: false)
        .getCardStatusIndex(index)) {
      context.read<HomeProvider>().changeSwitchValue(index, false);
      onCallScheduledCancel(index, context);
    } else {
      context.read<HomeProvider>().changeSwitchValue(index, true);
      await HomeBottomSheet(context, index, title).bottomSheet().then((value) {
        if (value != null) {
          context.read<HomeProvider>().changeSwitchValue(index, value);
          /***
           * Start scheduled call and save data on sqlite database
          ***/
          startScheduledCall(index, duration, context, false);
        } else
          context.read<HomeProvider>().changeSwitchValue(index, false);
      });
    }
  }

  Timer _first_timer;
  Timer _second_timer;
  Timer _third_timer;
  Timer _forth_timer;

  void onCallScheduledCancel(int index, BuildContext context) {
    context.read<HomeProvider>().cancelScheduledCall(index);
    cancelTimerAndNotifications(index);
    deleteDataFromSqfLite(index, context);
  }

  void startScheduledCall(
      int index, Duration duration, BuildContext context, bool isSaved) {
    switch (index) {
      case 0:
        {
          if (!isSaved) {
            saveDataOnSqfLite(index, context);
            context.read<HomeProvider>().initProviderState(context, false);
          }

          NotificationApi.showNotification(
              id: index,
              title: NotificationApi.title(!isSaved ? 5 : duration.inMinutes),
              body: NotificationApi.body(
                  '${Provider.of<HomeProvider>(context, listen: false).nameOfFirstCard}'),
              payload:
                  '${Provider.of<HomeProvider>(context, listen: false).nameOfFirstCard} - ${Provider.of<HomeProvider>(context, listen: false).numberOfFirstCard}');
          //DatabaseHelper().saveCall();
          _first_timer = Timer(duration, () {
            DisplayCall().displayCall(
                Provider.of<HomeProvider>(context, listen: false)
                    .numberOfFirstCard);
            HistoryDatabase().saveCall(HistoriesDataBaseModel(
                '${Provider.of<HomeProvider>(context, listen: false).nameOfFirstCard}',
                '${Provider.of<HomeProvider>(context, listen: false).numberOfFirstCard}',
                TimeOfDay.now().toString()));
            onCallScheduledCancel(index, context);
          });
          break;
        }
      case 1:
        {
          if (!isSaved) {
            saveDataOnSqfLite(index, context);
            context.read<HomeProvider>().initProviderState(context, false);
          }
          NotificationApi.showScheduledNotification(
              id: index,
              title: NotificationApi.title(5),
              body: NotificationApi.body(
                  '${Provider.of<HomeProvider>(context, listen: false).nameOfSecondCard}'),
              payload:
                  '${Provider.of<HomeProvider>(context, listen: false).nameOfSecondCard} - ${Provider.of<HomeProvider>(context, listen: false).numberOfSecondCard}',
              scheduledDate: DateTime.now()
                  .add(Duration(minutes: duration.inMinutes - 5)));
          _second_timer = Timer(duration, () {
            DisplayCall().displayCall(
                Provider.of<HomeProvider>(context, listen: false)
                    .numberOfSecondCard);
            HistoryDatabase().saveCall(HistoriesDataBaseModel(
                '${Provider.of<HomeProvider>(context, listen: false).nameOfSecondCard}',
                '${Provider.of<HomeProvider>(context, listen: false).numberOfSecondCard}',
                TimeOfDay.now().toString()));
            onCallScheduledCancel(index, context);
          });
          break;
        }
      case 2:
        {
          if (!isSaved) {
            saveDataOnSqfLite(index, context);
            context.read<HomeProvider>().initProviderState(context, false);
          }
          NotificationApi.showScheduledNotification(
              id: index,
              title: NotificationApi.title(5),
              body: NotificationApi.body(
                  '${Provider.of<HomeProvider>(context, listen: false).nameOfThirdCard}'),
              payload:
                  '${Provider.of<HomeProvider>(context, listen: false).nameOfThirdCard} - ${Provider.of<HomeProvider>(context, listen: false).numberOfThirdCard}',
              scheduledDate: DateTime.now()
                  .add(Duration(minutes: duration.inMinutes - 5)));
          _third_timer = Timer(duration, () {
            DisplayCall().displayCall(
                Provider.of<HomeProvider>(context, listen: false)
                    .numberOfThirdCard);
            HistoryDatabase().saveCall(HistoriesDataBaseModel(
                '${Provider.of<HomeProvider>(context, listen: false).nameOfThirdCard}',
                '${Provider.of<HomeProvider>(context, listen: false).numberOfThirdCard}',
                TimeOfDay.now().toString()));
            onCallScheduledCancel(index, context);
          });
          break;
        }
      case 3:
        {
          if (!isSaved) {
            saveDataOnSqfLite(index, context);
            context.read<HomeProvider>().initProviderState(context, false);
          }
          NotificationApi.showScheduledNotification(
              id: index,
              title: NotificationApi.title(5),
              body: NotificationApi.body(
                  '${Provider.of<HomeProvider>(context, listen: false).nameOfForthCard}'),
              payload:
                  '${Provider.of<HomeProvider>(context, listen: false).nameOfForthCard} - ${Provider.of<HomeProvider>(context, listen: false).numberOfForthCard}',
              scheduledDate: DateTime.now().add(Duration(
                  hours: duration.inHours, minutes: duration.inMinutes - 5)));
          _forth_timer = Timer(duration, () {
            DisplayCall().displayCall(
                Provider.of<HomeProvider>(context, listen: false)
                    .numberOfForthCard);
            HistoryDatabase().saveCall(HistoriesDataBaseModel(
                '${Provider.of<HomeProvider>(context, listen: false).nameOfForthCard}',
                '${Provider.of<HomeProvider>(context, listen: false).numberOfForthCard}',
                TimeOfDay.now().toString()));
            onCallScheduledCancel(index, context);
          });
          break;
        }
    }
  }

  void cancelTimerAndNotifications(int index) {
    switch (index) {
      case 0:
        {
          if (_first_timer != null && _first_timer.isActive) {
            _first_timer.cancel();
          }
          NotificationApi.cancel(index);
          break;
        }
      case 1:
        {
          if (_second_timer != null && _second_timer.isActive) {
            _second_timer.cancel();
          }
          NotificationApi.cancel(index);
          break;
        }
      case 2:
        {
          if (_third_timer != null && _third_timer.isActive) {
            _third_timer.cancel();
          }
          NotificationApi.cancel(index);
          break;
        }
      case 3:
        {
          if (_forth_timer != null && _forth_timer.isActive) {
            _forth_timer.cancel();
          }
          NotificationApi.cancel(index);
          break;
        }
    }
  }

  void saveDataOnSqfLite(int index, BuildContext context) {
    switch (index) {
      case 0:
        {
          DatabaseHelper().saveCall(DataBaseModel(
              index + 1,
              '${Provider.of<HomeProvider>(context, listen: false).nameOfFirstCard}',
              '${Provider.of<HomeProvider>(context, listen: false).numberOfFirstCard}',
              TimeOfDay.now().toString()));
          break;
        }
      case 1:
        {
          DatabaseHelper().saveCall(DataBaseModel(
              index + 1,
              '${Provider.of<HomeProvider>(context, listen: false).nameOfSecondCard}',
              '${Provider.of<HomeProvider>(context, listen: false).numberOfSecondCard}',
              TimeOfDay.now().toString()));
          break;
        }
      case 2:
        {
          DatabaseHelper().saveCall(DataBaseModel(
              index + 1,
              '${Provider.of<HomeProvider>(context, listen: false).nameOfThirdCard}',
              '${Provider.of<HomeProvider>(context, listen: false).numberOfThirdCard}',
              TimeOfDay.now().toString()));
          break;
        }
      case 3:
        {
          DatabaseHelper().saveCall(DataBaseModel(
              index + 1,
              '${Provider.of<HomeProvider>(context, listen: false).nameOfForthCard}',
              '${Provider.of<HomeProvider>(context, listen: false).numberOfForthCard}',
              TimeOfDay.now().toString()));
          break;
        }
    }
  }

  void deleteDataFromSqfLite(int index, BuildContext context) {
    switch (index) {
      case 0:
        {
          DatabaseHelper()
              .deleteCall(
                  Provider.of<HomeProvider>(context, listen: false).list[index])
              .then((value) {
            print('Deleted success $value');
          });
          break;
        }
      case 1:
        {
          DatabaseHelper()
              .deleteCall(
                  Provider.of<HomeProvider>(context, listen: false).list[index])
              .then((value) {
            print('Deleted success $value');
          });
          break;
        }
      case 2:
        {
          DatabaseHelper()
              .deleteCall(
                  Provider.of<HomeProvider>(context, listen: false).list[index])
              .then((value) {
            print('Deleted success $value');
          });
          break;
        }
      case 3:
        {
          DatabaseHelper()
              .deleteCall(
                  Provider.of<HomeProvider>(context, listen: false).list[index])
              .then((value) {
            print('Deleted success $value');
          });
          break;
        }
    }
  }
}
