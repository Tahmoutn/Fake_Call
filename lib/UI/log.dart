import 'package:fake_call/database/HistoryDatabase.dart';
import 'package:fake_call/model/HistoriesDatabaseModel.dart';
import 'package:fake_call/monetization/AdsManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_applovin_max/banner.dart';
import 'package:flutter_applovin_max/flutter_applovin_max.dart';

class Log extends StatefulWidget {
  @override
  _LogState createState() => _LogState();
}

class _LogState extends State<Log> {

  List<HistoriesDataBaseModel> items = [];

  @override
  initState(){
    _getData();
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

  Future _getData() async {
    await HistoryDatabase().getCalls().then((value){
      if(value!=null){
        setState(() {
          items = value;
        });
      }
      else
        items.clear();
      return true;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 16,top: 8,bottom: 8),
            child: Tooltip(
              message: 'Return',
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
        shadowColor: Colors.green.withOpacity(0.05),
        elevation: 5,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Call log',
        style: TextStyle(
          fontFamily: 'myFont',
          fontWeight: FontWeight.w600,
          color: Colors.green,
          fontSize: 20,
        ),),
        actions: [
          Container(
            height: 50,
            width: 55,
            child: Padding(
              padding: const EdgeInsets.only(right: 16,top: 8,bottom: 8),
              child: SizedBox(
                height: 30,
                width: 40,
                child: Tooltip(
                  message: 'Clear all',
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      if(items.isEmpty){
                        _showAlertToClearAll(msg:'Your log box is empty');
                      }else{
                        _showAlertToClearAll().then((value){
                          if(value){
                            initInterstitialAd();
                          }
                        });
                      }
                    },
                    child: Column(
                      children: [
                        Icon(Icons.cleaning_services_rounded,
                          color: Colors.deepOrange,),
                        Text('Clear',
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontSize: 10
                        ),)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: FutureBuilder(
        builder: (context,snapshot){
          if(items.isEmpty){
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Center(
                    child: Image.asset('assets/images/history_design.png'),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child : new BannerMaxView(
                            (AppLovinAdListener event) =>
                                AdsManager().listener(event),
                        BannerAdSize.banner,
                        mainBannerAdUnitId()
                    ),
                  ),
                )
              ],
            );
          }else if(items.isNotEmpty){
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.only(top :4.0, left: 4.0, right: 4.0, bottom: 80.0),
              itemCount: items.length,
              itemBuilder: (context,index){
                return Container(
                  child: Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(top: 8.0,right: 12.0,left: 12.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                            width: 0.8,
                            color: Colors.black12
                        )
                    ),
                    child: ListTile(
                      title: items[index].name == null ? Text('${items[index].number}')
                          : Text('${items[index].name}'),
                      subtitle: Text('${items[index].number} ',
                        overflow: TextOverflow.ellipsis,),
                      leading: Padding(
                        padding: EdgeInsets.all(2),
                        child: CircleAvatar(
                          radius: 20.3,
                          backgroundColor: Colors.black26,
                          child: CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.person,
                                color: Colors.black45),
                          ),
                        ),
                      ),
                      trailing: SizedBox(
                        height: 50,
                        width: 50,
                        child: InkWell(
                          onTap: (){
                            _showAlert(items[index]).then((value){
                              if(value){
                                setState(() {
                                  items.removeAt(index);
                                  initInterstitialAd();
                                });
                              }
                            });
                          },
                          borderRadius: BorderRadius.circular(30.0),
                          child: Icon(Icons.delete_outline_rounded,
                            color: Colors.red,),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future<bool> _showAlert(HistoriesDataBaseModel call) async{
    return await showDialog(
        context: context,
        barrierColor: Colors.green.withOpacity(0.1),
        builder: (context){
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)
            ),
            actionsPadding: const EdgeInsets.only(right: 14,bottom: 10),
            title: Text('Delete from log.',
              style: TextStyle(
                  fontWeight: FontWeight.w400
              ),
            ),
            content: RichText(
              text: new TextSpan(
                style: new TextStyle(
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  new TextSpan(text: 'Did you want to ',
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16
                      )),
                  TextSpan(
                    text: 'delete ',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.deepOrange,
                    )
                  ),
                  new TextSpan(
                    text: '${call.name} ?',
                    style: new TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black87),
                  ),
                ],
              ),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('No. cancel',style: TextStyle(
                    color: Colors.green
                ),),
              ),
              MaterialButton(
                color: Colors.deepOrange.shade50,
                elevation: 0.5,
                onPressed: () async{
                  deleteCall(call);
                  Navigator.of(context).pop(true);
                },
                child: Text('Yes. delete it',style: TextStyle(
                    color: Colors.deepOrange
                ),),
              ),
            ],
          );
        }
        //=> AlertDeleteCall(HISTORY_DB,call)
    );
  }

  Future deleteCall(HistoriesDataBaseModel call) async{
    await HistoryDatabase().db;
    var hdbHelper =  HistoryDatabase();
    await hdbHelper.deleteCall(call);
  }

  Future<bool> _showAlertToClearAll({String msg}) async{
    return await showDialog(
        barrierColor: Colors.green.withOpacity(0.1),
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0)
          ),
          actionsPadding: const EdgeInsets.only(right: 14,bottom: 10),
          title: msg == null ? Text('Clear all log.',
            style: TextStyle(
                fontWeight: FontWeight.w400
            ),
          ) : null,
          content: msg == null ? RichText(
            text: new TextSpan(
              style: new TextStyle(
                color: Colors.black,
              ),
              children: <TextSpan>[
                new TextSpan(text: 'Did you want to clear ',
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16
                    )),
                new TextSpan(
                  text: 'all log ?',
                  style: new TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87),
                ),
                TextSpan(
                  text: '\nThat does not effect on real and fake recent call on your phone',
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16
                    )
                )
              ],
            ),
          ) : Text(msg,
          textAlign: TextAlign.center,),
          actions: [
            msg == null ?
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('No. cancel',
              style: TextStyle(
                color: Colors.green
              ),),
            ) : SizedBox(),
            msg == null ? MaterialButton(
              color: Colors.green,
              onPressed: (){
                _clearHistory().then((value) {
                  _getData();
                  Navigator.of(context).pop(true);
                });
              },
              child: Text('Yes. Clear all',
              style: TextStyle(
                color: Colors.white
              ),),
            ) : MaterialButton(
              color: Colors.green,
              onPressed: (){
                  Navigator.of(context).pop(false);
              },
              child: Text('Ok. I got it',style: TextStyle(
                color: Colors.white
              ),),
            ),
          ],
        ));
  }

  Future<bool> _clearHistory() async{
    await HistoryDatabase().db;
    var dbHelper =  HistoryDatabase();
    var result = await dbHelper.deleteAll();
    return result;
  }


}
