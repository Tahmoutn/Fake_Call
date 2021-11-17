import 'dart:async';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:fake_call/Monetization/MyBannerWidget.dart';
import 'package:fake_call/Services/PermissionsHandler.dart';
import 'package:fake_call/Services/TimeCalculator.dart';
import 'package:fake_call/UI/CallNow.dart';
import 'package:fake_call/UI/Home/HAppBar.dart';
import 'package:fake_call/UI/Home/HDrawer.dart';
import 'package:fake_call/database/HistoryDatabase.dart';
import 'package:fake_call/database/database.dart';
import 'package:fake_call/monetization/AdsManager.dart';
import 'package:fake_call/constants.dart';
import 'package:fake_call/notifications/notifications_api.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:fake_call/Services/CallServices.dart';
import 'package:fake_call/View/AddCallSheet.dart';
import 'package:fake_call/View/AlertDeleteCall.dart';
import 'package:fake_call/View/ShowCallSheet.dart';
import 'package:fake_call/model/Call.dart';
import 'package:fake_call/model/ListCallModel.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const iOSLocalizedLabels = false;

class Home extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Home> {
  List<Color> _circleIcon = [];
  List<ListCallModel> items = [];
  Map<String, Call> calls = {};
  bool _selected = false;
  bool done = false;

  ScrollController _scrollController = ScrollController(initialScrollOffset: 0.0,keepScrollOffset: true);

  void setCircleColors() {
    for (var i = 0; i < Colors.accents.length; i++) {
      _circleIcon.insert(
          i, Colors.accents[Random().nextInt(Colors.accents.length)]);
    }
  }

  @override
  void initState() {
    super.initState();
    _getData();
    setCircleColors();
    askPermissions(context);
    NotificationApi.init(initScheduled: true);
    listenNotifications();
    displayAlarmCall();
  }

  void listenNotifications() =>
      NotificationApi.onNotifications.stream.listen(onClickedNotification);

  void onClickedNotification(String payload) {
    _showCall(
        item: items[int.parse('${payload[0]}')],
        color: Color(int.parse('${payload.substring(1, 10)}')));
    //Navigator.push(context, MaterialPageRoute(builder: (context)=> CallNow()));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future _getData() async {
    await DatabaseHelper().getCalls().then((value) {
      if (value != null) {
        setState(() {
          items = value;
          done = true;
        });
      } else
        items.clear();
      return true;
    });
    return false;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HAppBar(),
      drawer: HDrawer(),
      drawerScrimColor: Colors.green.withAlpha(40),
      primary: true,
      body: GridView(
        physics: BouncingScrollPhysics(),
        controller: _scrollController,
        padding: const EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                (MediaQuery.of(context).orientation == Orientation.portrait)
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
              child: new Stack(
                children: [
                  Positioned(
                    top: MediaQuery.of(context).size.width * 0.04,
                    left: MediaQuery.of(context).size.width * 0.04,
                    child: CircleAvatar(
                      child: Icon(Icons.phone_callback_rounded),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.width * 0.04,
                    right: MediaQuery.of(context).size.width * 0.04,
                    child: Switch(value: true, onChanged: (v){

                    }),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.width * 0.18,
                    left: MediaQuery.of(context).size.width * 0.04,
                    right: 5.0,
                    bottom: 0.5,
                    child: Text(
                      'After 5 min',
                      style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.width * 0.25,
                    left: MediaQuery.of(context).size.width * 0.04,
                    right: 5.0,
                    bottom: 0.5,
                    child: Text(
                      'John smith',
                      style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.teal,
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Positioned(
                      bottom: MediaQuery.of(context).size.width * 0.04,
                      left: MediaQuery.of(context).size.width * 0.04,
                      child: Text(
                        '+212655996438',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ))
                ],
              )),
          new Card(
              elevation: 0,
              shadowColor: Colors.green.withOpacity(0.3),
              color: Colors.green.shade50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(width: 0.0, color: Colors.white)),
              margin: const EdgeInsets.all(12),
              child: new Stack(
                children: [
                  Positioned(
                    top: MediaQuery.of(context).size.width * 0.04,
                    left: MediaQuery.of(context).size.width * 0.04,
                    child: CircleAvatar(
                      child: Icon(Icons.phone_callback_rounded),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.width * 0.04,
                    right: MediaQuery.of(context).size.width * 0.04,
                    child: Switch(value: true, onChanged: (v){

                    }),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.width * 0.18,
                    left: MediaQuery.of(context).size.width * 0.04,
                    right: 5.0,
                    bottom: 0.5,
                    child: Text(
                      'After 30 min',
                      style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.width * 0.25,
                    left: MediaQuery.of(context).size.width * 0.04,
                    right: 5.0,
                    bottom: 0.5,
                    child: Text(
                      'Adam smith',
                      style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.teal,
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Positioned(
                      bottom: MediaQuery.of(context).size.width * 0.04,
                      left: MediaQuery.of(context).size.width * 0.04,
                      child: Text(
                        '+212655996438',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ))
                ],
              )),
          new Card(
              elevation: 0,
              shadowColor: Colors.green.withOpacity(0.3),
              color: Colors.green.shade50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(width: 0.0, color: Colors.white)),
              margin: const EdgeInsets.all(12),
              child: new Stack(
                children: [
                  Positioned(
                    top: MediaQuery.of(context).size.width * 0.04,
                    left: MediaQuery.of(context).size.width * 0.04,
                    child: CircleAvatar(
                      child: Icon(Icons.phone_callback_rounded),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.width * 0.04,
                    right: MediaQuery.of(context).size.width * 0.04,
                    child: Switch(value: true, onChanged: (v){

                    }),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.width * 0.18,
                    left: MediaQuery.of(context).size.width * 0.04,
                    right: 5.0,
                    bottom: 0.5,
                    child: Text(
                      'After 1 hours',
                      style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.width * 0.25,
                    left: MediaQuery.of(context).size.width * 0.04,
                    right: 5.0,
                    bottom: 0.5,
                    child: Text(
                      'John smith',
                      style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.teal,
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Positioned(
                      bottom: MediaQuery.of(context).size.width * 0.04,
                      left: MediaQuery.of(context).size.width * 0.04,
                      child: Text(
                        '+212655996438',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ))
                ],
              )),
          new Card(
              elevation: 0,
              shadowColor: Colors.green.withOpacity(0.3),
              color: Colors.green.shade50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(width: 0.0, color: Colors.white)),
              margin: const EdgeInsets.all(12),
              child: new Stack(
                children: [
                  Positioned(
                    top: MediaQuery.of(context).size.width * 0.04,
                    left: MediaQuery.of(context).size.width * 0.04,
                    child: CircleAvatar(
                      child: Icon(Icons.phone_callback_rounded),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.width * 0.04,
                    right: MediaQuery.of(context).size.width * 0.04,
                    child: Switch(value: true, onChanged: (v){

                    }),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.width * 0.18,
                    left: MediaQuery.of(context).size.width * 0.04,
                    right: 5.0,
                    bottom: 0.5,
                    child: Text(
                      'After 5 hours',
                      style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.width * 0.25,
                    left: MediaQuery.of(context).size.width * 0.04,
                    right: 5.0,
                    bottom: 0.5,
                    child: Text(
                      'John smith',
                      style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.teal,
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Positioned(
                      bottom: MediaQuery.of(context).size.width * 0.04,
                      left: MediaQuery.of(context).size.width * 0.04,
                      child: Text(
                        '+212655996438',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ))
                ],
              ))
        ],
      ),
      // FutureBuilder(
      //   //future: _getData(),
      //   builder: (context, snapshot) {
      //     if (items.isEmpty && done) {
      //       return Padding(
      //         padding: EdgeInsets.all(10),
      //         child: SingleChildScrollView(
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               Padding(
      //                 padding: const EdgeInsets.only(left: 10, right: 10),
      //                 child: Container(
      //                   width: BannerSize.MEDIUM_RECTANGLE.width * 1.0,
      //                   height: BannerSize.MEDIUM_RECTANGLE.height * 1.0,
      //                   child: MyBannerWidget(
      //                     placementId: mainActivityBannerAdUnitId(),
      //                     bannerSize: BannerSize.MEDIUM_RECTANGLE,
      //                   ),
      //                 ),
      //               ),
      //               Card(
      //                 elevation: 0,
      //                 color: Colors.amber,
      //                 shape: RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.only(
      //                         bottomRight: Radius.circular(4.0),
      //                         bottomLeft: Radius.circular(4.0)
      //                     )
      //                 ),
      //                 child: Padding(
      //                   padding: const EdgeInsets.all(4.0),
      //                   child: Text('Advertising',
      //                     style: TextStyle(
      //                         color: Colors.white
      //                     ),),
      //                 ),
      //               ),
      //               // Container(
      //               //   alignment: Alignment.center,
      //               //   child: nativeAdWidget,
      //               //   width: MediaQuery.of(context).size.width,
      //               //   height: 100,
      //               // ),
      //               SizedBox(
      //                 height: MediaQuery.of(context).size.height * 0.05,
      //               ),
      //               Padding(
      //                 padding: const EdgeInsets.only(left: 20, right: 20),
      //                 child: Image.asset('assets/images/take-action.png'),
      //               ),
      //               SizedBox(
      //                 height: MediaQuery.of(context).size.height * 0.1,
      //               ),
      //               FloatingActionButton(
      //                 tooltip: 'Take action',
      //                 shape: RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.circular(15)
      //                 ),
      //                 onPressed: () async {
      //                   _buildSpeedDial(context);
      //                 },
      //                 child: Icon(Icons.add_call),
      //               ),
      //             ],
      //           ),
      //         ),
      //       );
      //     } else if (items.isNotEmpty) {
      //       return ListView.separated(
      //         physics: BouncingScrollPhysics(),
      //         padding: const EdgeInsets.only(
      //             top: 4.0, left: 4.0, right: 4.0, bottom: 80.0),
      //         itemCount: items.length,
      //         itemBuilder: (context, index) {
      //           return Container(
      //             child: Card(
      //               elevation: 0,
      //               margin: const EdgeInsets.only(
      //                   top: 8.0, right: 12.0, left: 12.0),
      //               shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.circular(10),
      //                   side: BorderSide(width: 0.8, color: Colors.black12)),
      //               child: InkWell(
      //                 borderRadius: BorderRadius.circular(10),
      //                 // onLongPress: _selected ? null : (){
      //                 //   setState(() {
      //                 //     selectItems.add(items[index]);
      //                 //     _selected = true;
      //                 //   });
      //                 // },
      //                 onTap: _selected
      //                     ? () {}
      //                     : () {
      //                   _showCall(
      //                       item: items[index],
      //                       color: _circleIcon[index]);
      //                 },
      //                 child: ListTile(
      //                   title: items[index].name == null
      //                       ? Text('${items[index].number}')
      //                       : Text('${items[index].name}'),
      //                   subtitle: Text(
      //                     '${items[index].number} • at ${items[index].time.replaceAll('TimeOfDay(', '').replaceAll(')', '')}',
      //                     overflow: TextOverflow.ellipsis,
      //                   ),
      //                   leading: Padding(
      //                     padding: EdgeInsets.all(2),
      //                     child: CircleAvatar(
      //                       radius: 20.3,
      //                       backgroundColor: Colors.black26,
      //                       child: CircleAvatar(
      //                         radius: 20.0,
      //                         backgroundColor: _circleIcon[index],
      //                         child:
      //                         Icon(Icons.person, color: Colors.black45),
      //                       ),
      //                     ),
      //                   ),
      //                   trailing: SizedBox(
      //                     height: 50,
      //                     width: 50,
      //                     child: InkWell(
      //                       onTap: () {
      //                         _showAlert(items[index], index);
      //                       },
      //                       borderRadius: BorderRadius.circular(30.0),
      //                       child: Icon(
      //                         Icons.remove_circle,
      //                         color: Colors.red,
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           );
      //         },
      //         separatorBuilder: (BuildContext context, int index) {
      //           if (index % 10 == 0) {
      //             return Container(
      //               padding:
      //               EdgeInsets.only(top: 8.0, right: 12.0, left: 12.0),
      //               child: new MyBannerWidget(
      //                 placementId: mainActivityBannerAdUnitId(),
      //                 bannerSize: BannerSize.STANDARD,
      //               ),
      //             );
      //           }
      //           return SizedBox();
      //         },
      //       );
      //     }
      //     return Center(
      //       child: CircularProgressIndicator(),
      //     );
      //   },
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: items.isEmpty != true
          ? FloatingActionButton.extended(
              tooltip: 'Take action',
              icon: Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Icon(Icons.phone_callback_rounded),
              ),
              label: Text("Make it now"),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              onPressed: () {
                _buildSpeedDial(context);
                if(isExtended){
                  setState(() {
                    isExtended = false;
                  });
                }else {
                  setState(() {
                    isExtended = true;
                  });
                }
              },
              // child: Icon(Icons.add_ic_call_rounded),
            )
          : null,
    );
  }

  bool isExtended = false;

  _buildSpeedDial(BuildContext context) async {
    await showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Card(
                    elevation: 0,
                    color: Colors.grey,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    child: SizedBox(
                      height: 5,
                      width: 50,
                    ),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                        child: Text(
                          'Please select your choice',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                side: BorderSide(
                                    width: 0.5, color: Colors.black26)),
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FloatingActionButton(
                                    tooltip: 'Take action',
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Icon(Icons.dialpad_rounded),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      FacebookInterstitialAd
                                          .loadInterstitialAd();
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  CallNow()));
                                      AdsManager().showAds();
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      'Make incoming \ncal now!',
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                side: BorderSide(
                                    width: 0.5, color: Colors.black26)),
                            child: Stack(
                              children: [
                                Card(
                                  margin: EdgeInsets.all(0.0),
                                  elevation: 0,
                                  shadowColor: Colors.transparent,
                                  color: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(10.0),
                                          topLeft: Radius.circular(15.0)),
                                      side: BorderSide(
                                          color: Colors.blue, width: 0.5)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Beta',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FloatingActionButton(
                                        tooltip: 'Take action',
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Icon(Icons.timer_rounded),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          _addNewCall();
                                        },
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          'Make incoming \ncall after time!',
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  _addNewCall() async {
    await showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return AddCallSheet();
        }).then((value) {
      // setAppBar(Colors.transparent, Brightness.light);
      if (value != null) {
        if (value) {
          AdsManager().showAds();
        }
      }
      _getData();
    });
  }

  _showCall({ListCallModel item, Color color}) async {
    FacebookInterstitialAd.loadInterstitialAd();
    await showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return ShowCallSheet(item, color);
        }).then((value) {
      AdsManager().showAds();
    });
  }

  _showAlert(ListCallModel call, int index) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDeleteCall(MAIN_DB, call);
        }).then((value) {
      if (value) {
        setState(() {
          _getData();
        });
      }
    });
  }
}

Future displayAlarmCall() async {
  List<ListCallModel> list;
  await DatabaseHelper().getCalls().then((value) {
    list = value;
  });
  if (list.isNotEmpty) {
    for (var i = 0; i < list.length; i++) {
      Timer(
          Duration(
              hours: int.parse(
                  '${TimeCalculator().calculateFromString(list[i].time).first}'),
              minutes: int.parse(
                  '${TimeCalculator().calculateFromString(list[i].time).last}')),
          () {
        DisplayCall().displayCall(list[i].number);
        HistoryDatabase().saveCall(list[i]);
      });
      NotificationApi.showScheduledNotification(
          title: 'You have an incoming fake call after 5 min',
          body: 'Tap for more options.',
          payload:
              '${list[i]}${Colors.accents[Random().nextInt(Colors.accents.length)].toString()}',
          //scheduledDate: DateTime.now().add(Duration(seconds: 10)),
          time: Time(
              int.parse(
                  '${TimeCalculator().calculateFromString(list[i].time).first}'),
              int.parse(
                  '${TimeCalculator().calculateFromString(list[i].time).last}')));
    }
  }
}
